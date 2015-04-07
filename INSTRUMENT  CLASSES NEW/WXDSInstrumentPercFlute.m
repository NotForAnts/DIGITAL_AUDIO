

#import "WXDSInstrumentPercFlute.h"


@implementation WXDSInstrumentPercFlute



-(id)   initInstrumentPercFlute
{
if(self=[super initInstrumentFM:4])
	{
	int i;
	// Concatenate the STK rawwave path to the rawwave files
	for (i=0; i<3; i++ )
		{
		[waves[i] release];
		waves[i]=[[WXDSWaveTable alloc]init];
		[waves[i] loadWaveOfName:"rawwaves/sinewave.raw"];
		}
	
	waves[3]=[[WXDSWaveTable alloc]init];
	[waves[3] loadWaveOfName:"rawwaves/fwavblnk.raw"];

	[self setRatio:0 ratio:1.50 * 1.000];
	[self setRatio:1 ratio:3.00 * 0.995];
	[self setRatio:2 ratio:2.99 * 1.005];
	[self setRatio:3 ratio:6.00 * 0.997];
	gains[0] = __FM_gains[99];
	gains[1] = __FM_gains[71];
	gains[2] = __FM_gains[93];
	gains[3] = __FM_gains[85];

	[adsr[0] setAllTimes:0.05 v2:0.05 v3:__FM_susLevels[14] v4:0.05];
	[adsr[1] setAllTimes:0.02 v2:0.50 v3:__FM_susLevels[13] v4:0.5];
	[adsr[2] setAllTimes:0.02 v2:0.30 v3:__FM_susLevels[11] v4:0.05];
	[adsr[3] setAllTimes:0.02 v2:0.05 v3:__FM_susLevels[13] v4:0.01];
	
	
	[self setFrequency:100];
	[twozero setGain:0.0];
	modDepth = 0.005;
	}
return self;
}  
// ******************************************************************************************
-(void) setFrequency:(float)frequency
{    
baseFrequency = frequency;
}
// ******************************************************************************************
-(void) keyONWithFreqGain:(float)freq gain:(float)gain
{
int i;
gains[0] = gain * __FM_gains[99] * 0.5;
gains[1] = gain * __FM_gains[71] * 0.5;
gains[2] = gain * __FM_gains[93] * 0.5;
gains[3] = gain * __FM_gains[85] * 0.5;
[self setFrequency:freq];

for (i=0; i<nOperators; i++ )
    [adsr[i] keyOnWithGain:1.0];
	
}
// ************************************************************************************************
-(OSStatus)		audioCallbackOnDevice:(AudioBufferList*)ioData bus:(UInt32)bus frame:(UInt32)inNumFrames time:(AudioTimeStamp*)timeStamp
{
if(!isActive) return [self RenderBlank:ioData bus:bus frame:inNumFrames];
UInt32 i;
float* out1 =(float*) ioData->mBuffers[0].mData;

register float temp;
for (i=0; i<inNumFrames; ++i) 
	{
	temp = [vibrato tick] * modDepth * (float) 0.2;    
	[waves[0] setFrequencyForWave:baseFrequency * ((float) 1.0 + temp) * ratios[0]];
	[waves[1] setFrequencyForWave:baseFrequency * ((float) 1.0 + temp) * ratios[1]];
	[waves[2] setFrequencyForWave:baseFrequency * ((float) 1.0 + temp) * ratios[2]];
	[waves[3] setFrequencyForWave:baseFrequency * ((float) 1.0 + temp) * ratios[3]];

	
	[waves[3] addPhaseOffset:[twozero lastOut]];
	

	temp = gains[3] * [adsr[3] tick] * [waves[3] tick];

	[twozero filter:temp];
	[waves[2] addPhaseOffset:temp];
	
	temp = (1.0 - (control2 * 0.5)) * gains[2] * [adsr[2] tick] * [waves[2] tick];
	
	temp += control2 * 0.5 * gains[1] * [adsr[1] tick] * [waves[1] tick];
	
	temp = temp * control1;

	[waves[0] addPhaseOffset:temp];
	temp = gains[0] * [adsr[0] tick] * [waves[0] tick];

	lastOutput = temp * (float) 0.5;
	

	*out1++ = lastOutput;
	}


[self doMonoToStereoPan:ioData frame:inNumFrames];

return noErr;
}
// ******************************************************************************************

@end
