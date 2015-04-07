// ***************************************************************************************
//  WXDSBasicSquareWave.h
//  Created by Paul Webb on Wed Apr 13 2005.
// ***************************************************************************************

#import "WXDSBasicSquareWave.h"


@implementation WXDSBasicSquareWave


// ************************************************************************************************
-(id)		initWithFreq:(double)r
{
if(self=[super init])
	{
	masterGain=0.2;
	[self setMasterPan:0.5];
	filterSeries=nil;

	waveIndex=0;
	waveIncrement=r;
	waveLength=44100.0;
	waveHigh=22050;
	}
return self;
}
// ************************************************************************************************
-(void)			setWavehighNSO:(id)high		{   waveHigh=[high floatValue];		};		
-(void)			setWavehigh:(double)high	{   waveHigh=high;					}
// ************************************************************************************************
-(OSStatus)		audioCallbackOnDevice:(AudioBufferList*)ioData bus:(UInt32)bus frame:(UInt32)inNumFrames time:(AudioTimeStamp*)timeStamp
{

if(!isActive) return [self RenderBlank:ioData bus:bus frame:inNumFrames];
UInt32 i;
float* out1 =(float*) ioData->mBuffers[0].mData;
float* out2 =(float*) ioData->mBuffers[1].mData;

[updateCollection calculateValues];

for (i=0; i<inNumFrames; ++i) 
	{
	if(updateCollection!=nil)   [updateCollection doUpdate];
	if(waveIndex<=waveHigh)
		theSample=masterGain;
	else
		theSample=-masterGain;
	
	waveIndex+=waveIncrement;
	if(waveIndex>=waveLength) waveIndex=waveIndex-waveLength;
	
	theSample=[filterSeries filter:theSample];
	*out1++ = theSample*panRight;
	*out2++ = theSample*panLeft;	
	}
	
//if(filterSeries!=nil) [filterSeries filterChunk:(float*) ioData->mBuffers[0].mData frame:inNumFrames];	
//[self doMonoToStereoPan:ioData frame:inNumFrames];
return noErr;
}
// ************************************************************************************************


@end
