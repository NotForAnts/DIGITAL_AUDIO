// ***************************************************************************************
//  WXDSInstrumentModal
//  Created by Paul Webb on Sun Aug 14 2005.
// ***************************************************************************************
#import "WXDSInstrumentModal.h"


@implementation WXDSInstrumentModal

// ***************************************************************************************

-(id) initInstrumentModal:(short)modes
{
if(self=[super init])
	{
	int i;
	nModes=modes;

  // We don't make the excitation wave here yet, because we don't know
  // what it's going to be.

	for (i=0;i<nModes;i++) 
		{
		filters[i] =[[WXFilterBiQuad alloc]initFilter];
		[filters[i] setEqualGainZeroes];
		}

	anEnvelope =[[WXDSInstrumentEnvelopeRamp alloc]init];
	onepole = [[WXFilterOnePole alloc]init];

	vibrato=[[WXDSWaveTable alloc]init];
	[vibrato loadWaveOfName: "rawwaves/sinewave.raw"];
	
	


	// Set some default values.
	[vibrato setFrequency:6.0];
	vibratoGain = 0.0;
	directGain = 0.0;
	aMasterGain = 1.0;
	baseFrequency = 440.0;

	[self clear];

	stickHardness =  0.5;
	strikePosition = 0.561;
	}
return self;
}  
// ***************************************************************************************
-(void) dealloc
{
[super dealloc];
}
// ***************************************************************************************
-(void) clear
{    
int i;
[onepole clear];
for(i=0; i<nModes; i++ )
    [filters[i] clear];
}
// ***************************************************************************************
-(void) setFrequency:(float)frequency
{
int i;
baseFrequency = frequency;
for (i=0; i<nModes; i++ )
   [self setRatioAndRadius:i ratio:ratios[i] radius:radii[i]];
}
// ***************************************************************************************
-(void) setRatioAndRadius:(int)modeIndex ratio:(float)ratio radius:(float)radius
{
float nyquist = 44100.0 / 2.0;
float temp;

if (ratio * baseFrequency < nyquist)
	ratios[modeIndex] = ratio;
else 
	{
	temp = ratio;
	while (temp * baseFrequency > nyquist) temp *= (float) 0.5;
	ratios[modeIndex] = temp;
	}
radii[modeIndex] = radius;
if (ratio < 0) 
	temp = -ratio;
else
	temp = ratio*baseFrequency;

[filters[modeIndex] setResonance:temp radius:radius normalise:NO];
}
// ***************************************************************************************
-(void) setaMasterGain:(float)aGain
{
aMasterGain = aGain;
}
// ***************************************************************************************
-(void) setDirectGain:(float)aGain
{
directGain = aGain;
}
// ***************************************************************************************
-(void)  setModeGain:(int)modeIndex gain:(float)gain
{
[filters[modeIndex] setGain:gain];
}
// ***************************************************************************************
-(void) strike:(float)amplitude
{
float gain = amplitude;

gain=WXUFloatBetween(0.0,1.0,amplitude);

[anEnvelope setRate:0.01];
[anEnvelope setTarget:gain];
[anEnvelope keyOnWithGain:1.0];
[onepole setPole:1.0 - gain];
[anEnvelope tick];
[wave gotoStartOfWave];

float temp;
int i;
for (i=0; i<nModes; i++) 
	{
	if (ratios[i] < 0)
	  temp = -ratios[i];
	else
	  temp = ratios[i] * baseFrequency;
	[filters[i] setResonance:temp radius:radii[i] normalise:NO];
	}
	
}
// ***************************************************************************************
-(void) keyONWithFreqGain:(float)freq gain:(float)gain
{
[self strike:gain];
[self setFrequency:freq];
}
// ***************************************************************************************
-(void) keyOFF
{
float amplitude=0.7;
// This calls damp, but inverts the meaning of amplitude (high
// amplitude means fast damping).
[self damp:1.0 - (amplitude * 0.03)];
}
// ***************************************************************************************
-(void) damp:(float)amplitude
{
float temp;
int i;
for (i=0; i<nModes; i++) 
	{
	if (ratios[i] < 0)
		temp = -ratios[i];
	else
		temp = ratios[i] * baseFrequency;
	[filters[i] setResonance:temp radius:radii[i]*amplitude normalise:NO];
	}
}
// ***************************************************************************************
-(OSStatus)		audioCallbackOnDevice:(AudioBufferList*)ioData bus:(UInt32)bus frame:(UInt32)inNumFrames time:(AudioTimeStamp*)timeStamp
{
if(!isActive) return [self RenderBlank:ioData bus:bus frame:inNumFrames];
UInt32 i;
int k;
float* out1 =(float*) ioData->mBuffers[0].mData;
float temp = 0.0; 
float temp2 = 0.0;
 
for (i=0; i<inNumFrames; ++i) 
	{
	temp = aMasterGain * [onepole filter:[wave tick] * [anEnvelope tick]];
	temp2=0.0;
	for (k=0; k<nModes; k++)
		temp2 += [filters[k] filter:temp];

	temp2  -= temp2 * directGain;
	temp2 += directGain * temp;
	// Calculate AM and apply to master out
	if (vibratoGain != 0.0)	
		{
		temp = 1.0 + [vibrato tick] * vibratoGain;
		temp2 = temp * temp2;
		}
		
		
	*out1++ = temp2;
	}


[self doMonoToStereoPan:ioData frame:inNumFrames];

return noErr;
}
// ***************************************************************************************
@end
