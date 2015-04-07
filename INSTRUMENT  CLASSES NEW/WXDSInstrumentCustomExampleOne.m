// ***************************************************************************************
//  WXDSInstrumentCustomExampleOne
//  Created by Paul Webb on Sat Aug 13 2005.
// ***************************************************************************************

#import "WXDSInstrumentCustomExampleOne.h"

@implementation WXDSInstrumentCustomExampleOne
// ************************************************************************************************
-(id)   init
{
if(self=[super init])
	{
	masterGain=3.0;
	waveIndex=0;
	waveIncrement=440;
	theWave=nil;
	filterSeries=nil;
	waveLength=44100.0;
	waveLengthEndIndex=waveLength-1.0;
	waveMaker=[[WXDSEnvelopeTableMaker alloc]init];
	
	theWave=[waveMaker makeDecaySineWaveTable:44100 r1:-1.0 r2:1.0 freq:4];
	//theWave=[waveMaker makePartialSineTable:44100 freq:@"1,2,16,3,5,7" amp:@"1,1,0.8,1,1,1" r1:-1.0 r2:1.0];
	//theWave=[waveMaker makePulseTable:44700 r1:-1.0 r2:1.0 freq:1.0 pulsePercent:7];
	theWave=[waveMaker makeSincEnvelope:44100 r1:-1.0 r2:1.0 phases:15.0];
	// for testing....please removed later
		
	filterSeries=[[WXDSFilterSeries alloc]init];
	bandPass=[[WXSPKitBWBandPassFilter alloc]init];
	[bandPass setBandWidth:100.0];
	reverb=[[WXFilterJohnChowningReverb alloc]initFilter:1.6];
	comb1=[[WXCombFilterFeedBack alloc]initComb:44100 delay:100];
	[comb1 setFStrength:0.8];
	[comb1 setDelay:20];	
	
	[filterSeries addObject:bandPass];
	[filterSeries addObject:comb1];
	[filterSeries addObject:reverb];
	[self setFilterSeries:filterSeries];
	
	[envelope setAttack:1.0 time:0.05];
	[envelope setDecay:0.2 time:0.2];
	[envelope setRelease:0.0 time:0.1];	
	
	width=[[WXDSInstrumentEnvelopeBase alloc]init];
	[width setAttack:1.0 time:0.05];
	[width setDecay:0.2 time:0.2];
	[width setRelease:0.0 time:2.1];	
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
-(void)		keyOnWithGainFrequencyDuration:(float)freq gain:(float)gain duration:(float)duration
{
noteFrequency=freq;
[self setFrequency:noteFrequency];
[envelope keyOnWithGainAndDuration:gain dur:duration];
[width keyOnWithGainAndDuration:gain dur:duration];
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
	stage=[envelope getCurrentState];
	

	
	
	theSample=theWave[(int)waveIndex]*masterGain;
	//theSample+=WXUFloatRandomBetween(0.0,adsrGain);
	theSample*=adsrGain;
	waveIndex+=waveIncrement;
	if(waveIndex>=waveLengthEndIndex) waveIndex=waveIndex-waveLength;
	*out1++ = theSample;
	}
	
[bandPass setCenterFreq:20+adsrGain*300];
[bandPass setBandWidth:20+[width tick]*200];
[comb1 setFStrength:0.2+adsrGain*0.799];	
[comb1 setDelay:10+adsrGain*20];


if(filterSeries!=nil)
	[filterSeries filterChunk:(float*) ioData->mBuffers[0].mData frame:inNumFrames];	

[self doMonoToStereoPan:ioData frame:inNumFrames];


return noErr;
}
// ************************************************************************************************


@end
