// ***************************************************************************************
//  WXDSInstrumentBellOne
//  Created by Paul Webb on Sun Aug 14 2005.
// ***************************************************************************************

#import "WXDSInstrumentBellOne.h"


@implementation WXDSInstrumentBellOne
// ************************************************************************************************
-(id)   initWithType:(short)type
{
if(self=[super init])
	{
	masterGain=1.0;
	waveIndex=0;
	theWave=nil;
	filterSeries=nil;
	waveLength=44100.0;
	waveLengthEndIndex=waveLength-1.0;
	waveMaker=[[WXDSEnvelopeTableMaker alloc]init];
	
	// wave type for this electro bass instrument
	switch(2)
		{
		case 1: theWave=[waveMaker makeDecaySineWaveTable:44100 r1:-1.0 r2:1.0 freq:4];										break;
		case 2: theWave=[waveMaker makePartialSineTable:44100 freq:@"1,3,5,7,9,13" amp:@"1,1,0.8,1,1,1" r1:-1.0 r2:1.0];	break;
		case 3: theWave=[waveMaker makePulseTable:44700 r1:-1.0 r2:1.0 freq:1.0 pulsePercent:7];							break;
		case 4: theWave=[waveMaker makeSincEnvelope:44100 r1:-1.0 r2:1.0 phases:15.0];										break;
		}
		

		/*	
	// filter series for this electro bass instrument
	
	
	comb1=[[WXCombFilterFeedBack alloc]initComb:44100 delay:5];

	filterSeries=[[WXDSFilterSeries alloc]init];
	[filterSeries addObject:bandPass];
	//[filterSeries addObject:comb1];
	[filterSeries addObject:reverb];

	*/
	resonator=[[WXSPKitBWBandPassFilter alloc]init];
	reverb=[[WXFilterJohnChowningReverb alloc]initFilter:0.4];
	filterSeries=[[WXDSFilterSeries alloc]init];
	[filterSeries addObject:resonator];	
	[filterSeries addObject:reverb];
	
	// default attacks
	[envelope setAttack:1.0 time:0.01];
	[envelope setDecay:0.6 time:0.2];
	[envelope setRelease:0.0 time:0.7];	
	
	// default filter variations
	centre1=220;		centre2=300;
	width1=20;			width2=230;
	//feedback1=0.1;  feedback2=0.55;
	//delay1=10;		delay2=30;
	//pan1=0.0;		pan2=1.0;
	}
return self;
}
// ************************************************************************************************
-(void)		dealloc
{
[waveMaker release];
free(theWave);
[filterSeries release];
//[bandPass release];
//[comb1 release];
//[reverb release];

[super dealloc];
}
// ************************************************************************************************
/*
-(void)		setCentreVariation:(float)v1 v2:(float)v2		{	centre1=v1;		centre2=v2;			}
-(void)		setWidthVariation:(float)v1 v2:(float)v2		{	width1=v1;		width2=v2;			}
-(void)		setFeedVariation:(float)v1 v2:(float)v2			{	feedback1=v1;   feedback2=v2;		}
-(void)		setDelayVariation:(float)v1 v2:(float)v2		{	delay1=v1;		delay2=v2;			}
-(void)		setPanvariation:(float)v1 v2:(float)v2			{	pan1=v1;		pan2=v2;			}
*/
// ************************************************************************************************
-(void)		setFrequency:(float)freq	
{ 
waveIncrement=freq;		
}
// ************************************************************************************************
-(void)		doKeyOnExtra:(float)freq
{
noise=.3;
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
	
	theSample=theWave[(int)waveIndex];
	if(noise>0.0) theSample+=WXUFloatRandomBetween(-noise,noise);
	theSample*=masterGain;
	theSample*=adsrGain;
	waveIndex+=waveIncrement;
	if(waveIndex>=waveLengthEndIndex) waveIndex=waveIndex-waveLength;
	*out1++ = theSample;
	noise=noise-0.01;
	}

[resonator setCenterFreq:WXUNormalise(adsrGain,0,1.0,centre1,centre2)];
[resonator setBandWidth:WXUNormalise(adsrGain,0,1.0,width1,width2)];
//[comb1 setFStrength:WXUNormalise(adsrGain,0,1.0,feedback1,feedback2)];	
//[comb1 setDelay:WXUNormalise(adsrGain,0,1.0,delay1,delay2)];


[filterSeries filterChunk:(float*) ioData->mBuffers[0].mData frame:inNumFrames];	
[self doMonoToStereoPan:ioData frame:inNumFrames];


return noErr;
}
// ************************************************************************************************


@end
