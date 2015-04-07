// ***************************************************************************************
//  WXDSBasicSineWave
//  Created by Paul Webb on Sat Mar 26 2005.
// ***************************************************************************************

#import "WXDSBasicSineWave.h"

// ***************************************************************************************

@implementation WXDSBasicSineWave


// ************************************************************************************************
-(id)		initWithFreq:(double)r
{
if(self=[super init])
	{
	[self setMasterPan:0.5];
	filterSeries=nil;
	waveIndex=0;
	waveIncrement=r;
	degree1=0;
	delta1=WXUFreqToDelta(r);
	theWave=[waveMaker makeSineWaveTable:44100 r1:-1.0 r2:1.0 freq:1.0];
	}
return self;
}// ************************************************************************************************
-(void)		setFrequencyNSO:(id)freq		{		[self setFrequency:[freq floatValue]];				}
-(void)		setFrequency:(float)freq		{		delta1=WXUFreqToDelta(freq);					}
// ************************************************************************************************
-(OSStatus)		audioCallbackOnDevice:(AudioBufferList*)ioData bus:(UInt32)bus frame:(UInt32)inNumFrames time:(AudioTimeStamp*)timeStamp
{

if(!isActive) return [self RenderBlank:ioData bus:bus frame:inNumFrames];
UInt32 i;
float* out1 =(float*) ioData->mBuffers[0].mData;
float* out2 =(float*) ioData->mBuffers[1].mData;
for (i=0; i<inNumFrames; ++i,degree1+=delta1) 
	{
	if(updateCollection!=nil)   [updateCollection doUpdate];
	
	theSample=sin(degree1)*masterGain;
	theSample=[filterSeries filter:theSample];
	*out1++ = theSample*panRight;
	*out2++ = theSample*panLeft;	
	}
	
//[filterSeries filterChunk:(float*) ioData->mBuffers[0].mData frame:inNumFrames];	
//[self doMonoToStereoPan:ioData frame:inNumFrames];

return noErr;
}
// ************************************************************************************************


@end