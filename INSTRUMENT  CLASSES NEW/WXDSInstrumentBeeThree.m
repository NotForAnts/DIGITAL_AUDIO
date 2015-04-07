// ******************************************************************************************
//  WXDSInstrumentBeeThree
//  Created by Paul Webb on Mon Aug 15 2005.
// ******************************************************************************************
#import "WXDSInstrumentBeeThree.h"


@implementation WXDSInstrumentBeeThree

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

	[self setRatio:0 ratio: 0.999];
	[self setRatio:1 ratio: 1.997];
	[self setRatio:2 ratio: 3.006];
	[self setRatio:3 ratio: 6.009];

	gains[0] = __FM_gains[95];
	gains[1] = __FM_gains[95];
	gains[2] = __FM_gains[99];
	gains[3] = __FM_gains[95];

	[adsr[0] setAllTimes:0.005 v2:0.003 v3:1.0 v4:0.01];
	[adsr[1] setAllTimes:0.005 v2:0.003 v3:1.0 v4:0.01];
	[adsr[2] setAllTimes:0.005 v2:0.003 v3:1.0 v4:0.01];
	[adsr[3] setAllTimes:0.005 v2:0.001 v3:0.4 v4:0.03];

	[twozero setGain:0.1];
	[self setFrequency:100];
	
	modDepth=0.3;
	}
return self;
}  
// ******************************************************************************************
-(void) setFrequency:(float)frequency
{   
int i; 
baseFrequency = frequency * (float) 1.0;
for (i=0; i<nOperators; i++ )
    [waves[i] setFrequencyForWave:baseFrequency * ratios[i]];
}
// ******************************************************************************************
-(void) keyONWithFreqGain:(float)freq gain:(float)gain
{
int i;
gains[0] = gain * __FM_gains[95];
gains[1] = gain * __FM_gains[95];
gains[2] = gain * __FM_gains[99];
gains[3] = gain * __FM_gains[95];
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
  register float temp;

for (i=0; i<inNumFrames; ++i) 
	{
	if (modDepth > 0.0)	{
	temp = 1.0 + (modDepth * [vibrato tick] * 0.1);
	[waves[0] setFrequencyForWave:baseFrequency * temp * ratios[0]];
	[waves[1] setFrequencyForWave:baseFrequency * temp * ratios[1]];
	[waves[2] setFrequencyForWave:baseFrequency * temp * ratios[2]];
	[waves[3] setFrequencyForWave:baseFrequency * temp * ratios[3]];
	}

	[waves[3] addPhaseOffset:[twozero lastOut]];
	temp = control1 * 2.0 * gains[3] * [adsr[3] tick] * [waves[3] tick];
	[twozero filter:temp];

	temp += control2 * 2.0 * gains[2] * [adsr[2] tick] * [waves[2] tick];
	temp += gains[1] * [adsr[1] tick] * [waves[1] tick];
	temp += gains[0] * [adsr[0] tick] * [waves[0] tick];

	lastOutput = temp * 0.125;
	*out1++ = lastOutput;
	}


[self doMonoToStereoPan:ioData frame:inNumFrames];

return noErr;
}
// ******************************************************************************************

@end
