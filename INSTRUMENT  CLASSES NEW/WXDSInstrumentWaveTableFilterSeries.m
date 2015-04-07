// ***************************************************************************************
//  WXDSInstrumentWaveTableFilterSeries
//  Created by Paul Webb on Sat Aug 13 2005.
// ***************************************************************************************

#import "WXDSInstrumentWaveTableFilterSeries.h"


@implementation WXDSInstrumentWaveTableFilterSeries


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
	
	theWave=[waveMaker makePulseTable:44100 r1:-1.0 r2:1.0 freq:1.0 pulsePercent:2];
	
	
	// for testing....please removed later
		
	filterSeries=[[WXDSFilterSeries alloc]init];
	bandPass=[[WXSPKitBWBandPassFilter alloc]init];
	[bandPass setBandWidth:100.0];
	reverb=[[WXFilterJohnChowningReverb alloc]initFilter:7.2];
	[filterSeries addObject:bandPass];
	[filterSeries addObject:reverb];
	[self setFilterSeries:filterSeries];
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
-(void)		setFrequency:(float)freq	
{ 
waveIncrement=freq;		
}
// ************************************************************************************************
-(OSStatus)		audioCallbackOnDevice:(AudioBufferList*)ioData bus:(UInt32)bus frame:(UInt32)inNumFrames time:(AudioTimeStamp*)timeStamp
{

if(!isActive) return [self RenderBlank:ioData bus:bus frame:inNumFrames];
UInt32 i;
float* out1 =(float*) ioData->mBuffers[0].mData;

for (i=0; i<inNumFrames; ++i) 
	{
	adsrGain=[envelope tick];
	
	theSample=theWave[(int)waveIndex]*masterGain*adsrGain;
	waveIndex+=waveIncrement;
	if(waveIndex>=waveLengthEndIndex) waveIndex=waveIndex-waveLength;
	*out1++ = theSample;
	}
	

if(filterSeries!=nil)
	[filterSeries filterChunk:(float*) ioData->mBuffers[0].mData frame:inNumFrames];	

[self doMonoToStereoPan:ioData frame:inNumFrames];


return noErr;
}
// ************************************************************************************************


@end
