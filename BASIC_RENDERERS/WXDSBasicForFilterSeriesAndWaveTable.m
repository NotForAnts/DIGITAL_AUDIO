// ***************************************************************************************
//  WXDSBasicForFilterSeriesAndWaveTable.h
//  Created by Paul Webb on Wed Apr 13 2005.
// ***************************************************************************************

#import "WXDSBasicForFilterSeriesAndWaveTable.h"


@implementation WXDSBasicForFilterSeriesAndWaveTable


// ************************************************************************************************
-(id)   init
{
if(self=[super init])
	{
	masterGain=1.0;
	waveIndex=0;
	waveIncrement=440;
	theWave=nil;
	filterSeries=nil;
	waveLength=44100.0;
	waveLengthEndIndex=waveLength-1.0;
	waveMaker=[[WXDSEnvelopeTableMaker alloc]init];
	
	theWave=[waveMaker makePulseTable:44100 r1:-1.0 r2:1.0 freq:880.0*4.0 pulsePercent:10];
	}
return self;
}
// ************************************************************************************************
-(void)		dealloc
{
[waveMaker release];
if(theWave!=nil) free(theWave);
if(filterSeries!=nil) [filterSeries release];
[super dealloc];
}
// ************************************************************************************************
-(void)		setFilterSeries:(WXDSFilterSeries*)fs
{
filterSeries=fs;
[filterSeries retain];
}
// ************************************************************************************************
-(WXDSFilterSeries*)	filterSeries
{
return filterSeries;
}
// ************************************************************************************************
-(void)		setFrequencyNSO:(id)freq
{
waveIncrement=[freq floatValue];	
}
// ************************************************************************************************
-(void)		setFrequency:(float)freq	
{ 
waveIncrement=freq;		
}
// ************************************************************************************************
// This is doing something not like others in that it is chunking the filter and pan data
// for increased speed
// ************************************************************************************************
-(OSStatus)		audioCallbackOnDevice:(AudioBufferList*)ioData bus:(UInt32)bus frame:(UInt32)inNumFrames time:(AudioTimeStamp*)timeStamp
{

if(!isActive) return [self RenderBlank:ioData bus:bus frame:inNumFrames];
UInt32 i;
float* out1 =(float*) ioData->mBuffers[0].mData;
float* out2 =(float*) ioData->mBuffers[1].mData;

for (i=0; i<inNumFrames; ++i) 
	{
	if(updateCollection!=nil)   [updateCollection doUpdate];
	theSample=theWave[(int)waveIndex]*masterGain;
	waveIndex+=waveIncrement;
	if(waveIndex>=waveLengthEndIndex) waveIndex=waveIndex-waveLength;
	
	if(filterSeries!=nil) theSample=[filterSeries filter:theSample];
	
	*out1++ = theSample*panRight;
	*out2++ = theSample*panLeft;
	}
	
//[filterSeries filterChunk:(float*) ioData->mBuffers[0].mData frame:inNumFrames];	
//[self doMonoToStereoPan:ioData frame:inNumFrames];

return noErr;
}
// ************************************************************************************************
@end
