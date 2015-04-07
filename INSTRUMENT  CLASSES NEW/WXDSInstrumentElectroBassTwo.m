// ***************************************************************************************
//  WXDSInstrumentElectroBassTwo
//  Created by Paul Webb on Sun Aug 14 2005.
// ***************************************************************************************

#import "WXDSInstrumentElectroBassTwo.h"


@implementation WXDSInstrumentElectroBassTwo
// ************************************************************************************************
-(id)   initWithType:(short)type
{
if(self=[super init])
	{
	masterGain=5.0;
	theWave=nil;
	filterSeries=nil;
	waveIndex=0;
	waveLength=44100.0;
	waveLengthEndIndex=waveLength-1.0;
	waveMaker=[[WXDSEnvelopeTableMaker alloc]init];
	
	// wave type for this electro bass instrument
	switch(type)
		{
		case 1: theWave=[waveMaker makeDecaySineWaveTable:44100 r1:-1.0 r2:1.0 freq:4];										break;
		case 2: theWave=[waveMaker makePartialSineTable:44800 freq:@"1,2,16,3,5,7" amp:@"1,1,0.8,1,1,1" r1:-1.0 r2:1.0];	break;
		case 3: theWave=[waveMaker makePulseTable:44700 r1:-1.0 r2:1.0 freq:1.0 pulsePercent:20];							break;
		case 4: theWave=[waveMaker makeSincEnvelope:44100 r1:-1.0 r2:1.0 phases:3.0];										break;
		case 5: theWave=[waveMaker makeNoisePulseWave:44100 r1:-1.0 r2:1.0 freq:1.0 pulsePercent:60];						break;
		case 6: theWave=[waveMaker makeNoisePulseWave:44100 r1:-1.0 r2:1.0 freq:1.0 pulsePercent:80];						break;
		case 7: theWave=[waveMaker makeNoisePulseWave:44100 r1:-1.0 r2:1.0 freq:1.0 pulsePercent:30];						break;	
		case 8: theWave=[waveMaker makePartialSineTable:44800 freq:@"1,2,3,7,21,47" amp:@"1,1,0.8,1,1,1" r1:-1.0 r2:1.0];	break;	
		case 9: theWave=[waveMaker makeDecaySineWaveTable:44400 r1:-1.0 r2:1.0 freq:4];										break;		
		}
		
		
	// filter series for this electro bass instrument
	bandPass=[[WXSPKitBWBandPassFilter alloc]init];
	reverb=[[WXFilterPRCReverb alloc]initFilter:1.4];
	
	filterSeries=[[WXDSFilterSeries alloc]init];
	[filterSeries addObject:bandPass];
	[filterSeries addObject:reverb];

	// default attacks
	[envelope setAttack:1.0 time:0.01];
	[envelope setDecay:0.8 time:0.05];
	[envelope setRelease:0.0 time:0.1];	
	
	// default filter variations
	centre1=1620;	centre2=100;
	width1=520;		width2=30;
	feedback1=0.1;  feedback2=0.55;
	delay1=10;		delay2=30;
	pan1=0.0;		pan2=1.0;
	}
return self;
}
// ************************************************************************************************
-(void)		dealloc
{
[waveMaker release];
free(theWave);
[filterSeries release];
[bandPass release];
[reverb release];

[super dealloc];
}
// ************************************************************************************************
-(void)		setCentreVariation:(float)v1 v2:(float)v2		{	centre1=v1;		centre2=v2;			}
-(void)		setWidthVariation:(float)v1 v2:(float)v2		{	width1=v1;		width2=v2;			}
// ************************************************************************************************
-(void)		setFrequency:(float)freq	
{ 
waveIncrement=freq;		
}
// ************************************************************************************************
-(void)		doKeyOnExtra:(float)freq
{
waveIndex=0;
panTick=0;
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
	
	theSample=theWave[(int)waveIndex]*masterGain;
	theSample*=adsrGain;
	waveIndex+=waveIncrement;
	if(waveIndex>=waveLengthEndIndex) waveIndex=waveIndex-waveLength;
	*out1++ = theSample;
	}

[bandPass setCenterFreq:WXUNormalise(adsrGain,0,1.0,centre1,centre2)];
[bandPass setBandWidth:WXUNormalise(adsrGain,0,1.0,width1,width2)];


[filterSeries filterChunk:(float*) ioData->mBuffers[0].mData frame:inNumFrames];	
[self doMonoToStereoPan:ioData frame:inNumFrames];


return noErr;
}
// ************************************************************************************************


@end
