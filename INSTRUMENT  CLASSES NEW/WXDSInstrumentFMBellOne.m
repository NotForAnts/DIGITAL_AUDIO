// ******************************************************************************************
//  WXDSInstrumentFMBellOne
//  Created by Paul Webb on Sun Aug 14 2005.
// ******************************************************************************************
#import "WXDSInstrumentFMBellOne.h"


@implementation WXDSInstrumentFMBellOne

// ******************************************************************************************
-(id)   init
{
if(self=[super initInstrumentFM:4])
	{
	[waves[0] freeWave];
	[waves[1] freeWave];
	[waves[2] freeWave];
	[waves[3] freeWave];
	
	[waves[0] setWave:[waveMaker makeSineWaveTable:44100 r1:-1.0 r2:1.0 freq:1.0]];
	[waves[1] setWave:[waveMaker makeSineWaveTable:44100 r1:-1.0 r2:1.0 freq:1.0]];
	[waves[2] setWave:[waveMaker makeSineWaveTable:44100 r1:-1.0 r2:1.0 freq:1.0]];
	[waves[3] setWave:[waveMaker makeRampTable:44100 freq:@"1,3" amp:@"1,1" r1:-1.0 r2:1.0]];
	
	
	gains[0] = __FM_gains[94];
	gains[1] = __FM_gains[76];
	gains[2] = __FM_gains[99];
	gains[3] = __FM_gains[71];	
		
	[self setRatio:0 ratio:1.0   * 0.995];
	[self setRatio:1 ratio:1.414 * 0.995];
	[self setRatio:2 ratio:1.0   * 1.005];
	[self setRatio:3 ratio:1.414 * 1.000];	
	
	[adsr[0] setAttack:1.0 time:0.005];
	[adsr[0] setDecay:0.0 time:4.0];
	[adsr[0] setRelease:0.0 time:0.04];	
	
	[adsr[1] setAttack:1.0 time:0.005];
	[adsr[1] setDecay:0.0 time:4.0];
	[adsr[1] setRelease:0.0 time:0.04];	
	
	[adsr[2] setAttack:1.0 time:0.001];
	[adsr[2] setDecay:0.0 time:2.0];
	[adsr[2] setRelease:0.0 time:0.04];	
	
	[adsr[2] setAttack:1.0 time:0.004];
	[adsr[2] setDecay:0.0 time:4.0];
	[adsr[2] setRelease:0.0 time:0.04];				
	
	[vibrato setFrequencyForWave:6.0];
	modDepth=0.2;

	[twozero setGain:0.5];	
	}
return self;
}
// ************************************************************************************************
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
    
	theSample = temp * 0.5;
	*out1++ = theSample;
	}


[self doMonoToStereoPan:ioData frame:inNumFrames];

return noErr;
}
// ******************************************************************************************

@end
