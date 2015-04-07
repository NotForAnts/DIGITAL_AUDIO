// ******************************************************************************************
//  WXDSInstrumentWurley
//  Created by Paul Webb on Mon Aug 15 2005.
// ******************************************************************************************

#import "WXDSInstrumentWurley.h"


@implementation WXDSInstrumentWurley

// ******************************************************************************************

-(id)   init
{
if(self=[super initInstrumentFM:4])
	{
	int i;
	for (i=0; i<3; i++ )
		{
		[waves[i] release];
		waves[i]=[[WXDSWaveTable alloc]init];
		[waves[i] loadWaveOfName:"rawwaves/sinewave.raw"];
		}
	
	waves[3]=[[WXDSWaveTable alloc]init];
	[waves[3] loadWaveOfName:"rawwaves/fwavblnk.raw"];

	[self setRatio:0 ratio:1.0];
	[self setRatio:1 ratio:4.0];
	[self setRatio:2 ratio:-510.0];
	[self setRatio:3 ratio:-510.0];

	gains[0] = __FM_gains[99];
	gains[1] = __FM_gains[82];
	gains[2] = __FM_gains[92];
	gains[3] = __FM_gains[68];

	[adsr[0] setAllTimes:0.001 v2:1.50 v3:0.0 v4:0.04];
	[adsr[1] setAllTimes:0.001 v2:1.50 v3:0.0 v4:0.04];
	[adsr[2] setAllTimes:0.001 v2:0.25 v3:0.0 v4:0.04];
	[adsr[3] setAllTimes:0.001 v2:0.15 v3:0.0 v4:0.04];

	[twozero setGain:2.0];
	[vibrato setFrequencyForWave:8.0];
	[self setFrequency:105];
	}
return self;
}  
// ******************************************************************************************
-(void) setFrequency:(float)frequency
{    
baseFrequency = frequency;
[waves[0] setFrequencyForWave:baseFrequency * ratios[0]];
[waves[1] setFrequencyForWave:baseFrequency * ratios[1]];
[waves[2] setFrequencyForWave:-ratios[2]];	// Note here a 'fixed resonance'.
[waves[3] setFrequencyForWave:-ratios[3]];
}
// ******************************************************************************************
-(void) keyONWithFreqGain:(float)freq gain:(float)gain
{
int i;
gains[0] = gain * __FM_gains[99];
gains[1] = gain * __FM_gains[82];
gains[2] = gain * __FM_gains[82];
gains[3] = gain * __FM_gains[68];
[self setFrequency:freq];
for (i=0; i<nOperators; i++ )
    [adsr[i] keyOnWithGain:1.0];

}
// ******************************************************************************************
-(OSStatus)		audioCallbackOnDevice:(AudioBufferList*)ioData bus:(UInt32)bus frame:(UInt32)inNumFrames time:(AudioTimeStamp*)timeStamp
{
if(!isActive) return [self RenderBlank:ioData bus:bus frame:inNumFrames];
UInt32 i;
float* out1 =(float*) ioData->mBuffers[0].mData;
float temp, temp2;

for (i=0; i<inNumFrames; ++i) 
	{
	temp = gains[1] * [adsr[1] tick] * [waves[1] tick];
	temp = temp * control1;

	[waves[0] addPhaseOffset:temp];
	[waves[3] addPhaseOffset:[twozero lastOut]];
	temp = gains[3] * [adsr[3] tick] * [waves[3] tick];
	[twozero filter:temp];

	[waves[2] addPhaseOffset:temp];
	temp = ( 1.0 - (control2 * 0.5)) * gains[0] * [adsr[0] tick] * [waves[0] tick];
	temp += control2 * 0.5 * gains[2] * [adsr[2] tick] * [waves[2] tick];

	// Calculate amplitude modulation and apply it to output.
	temp2 = [vibrato tick] * modDepth;
	temp = temp * (1.0 + temp2);

	lastOutput = temp * 0.5;
	*out1++ = lastOutput;
	}


[self doMonoToStereoPan:ioData frame:inNumFrames];

return noErr;
}
// ******************************************************************************************

@end
