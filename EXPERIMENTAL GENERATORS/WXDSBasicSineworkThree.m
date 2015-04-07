// ************************************************************************************************
//  WXDSBasicSineworkThree
//  Created by Paul Webb on Tue Jul 26 2005.
// ************************************************************************************************

#import "WXDSBasicSineworkThree.h"


@implementation WXDSBasicSineworkThree

// ************************************************************************************************
-(id)		initWithFreq:(double)r
{
if(self=[super initWithFreq:r])
	{
	updateCounter=0;
	noiseUpdateCount=WXURandomInteger(8,64);
	
	noiseUpdateDelta=WXUFloatRandomBetween(0.02,0.002);
	if(WXUPercentChance(50))	noiseUpdateDelta=noiseUpdateDelta*-1.0;
	noiseUpdateDelta=25;//noiseUpdateDelta/10.0;
	//noiseUpdateDelta=noiseUpdateDelta/WXUFloatRandomBetween(10.0,1000.0);	
	
	noiseLevelQuantise=WXURandomInteger(1000,60000);
	noiseLevelQuantiseHalf=noiseLevelQuantise/2;
	
	
	centreFreq=WXURandomInteger(1000,8000);
	centreDelta=WXUFloatRandomBetween(0.02,0.5);
	if(WXUPercentChance(50))	centreDelta=centreDelta*-1.0;
	
	bandPass=[[WXSPKitBWBandPassFilter alloc]init];
	[bandPass setCenterFreq:2000];
	[bandPass setBandWidth:400];
	
	
	// basic tap
	maxTapSize=44100;
	tapcount=0;
	theTapDelay=WXURandomInteger(100,2000);
	tapStrength=-0.98;
	
	
	// pan
	if(WXUPercentChance(50))	origPan=WXUFloatRandomBetween(0.0,0.4); else origPan=WXUFloatRandomBetween(0.6,1.0);
	[self setMasterPan:origPan]; 
	panShift=WXUFloatRandomBetween(0.0,0.008);
	//if(WXUPercentChance(30))	panShift=WXUFloatRandomBetween(0.0,0.01);
	if(origPan>0.5)	panShift=panShift*-1.0;
	
	//
	resetEvery=WXURandomInteger(6,20);
	resetCounter=resetEvery;
	centreFreqOrig=centreFreq;
	origNoiseUpdateCount=noiseUpdateDelta;
	}
return self;
}
// ************************************************************************************************
-(void)		dealloc
{
[bandPass release];
[super dealloc];
}
// ************************************************************************************************
-(OSStatus)		audioCallbackOnDevice:(AudioBufferList*)ioData bus:(UInt32)bus frame:(UInt32)inNumFrames time:(AudioTimeStamp*)timeStamp
{

if(!isActive) return [self RenderBlank:ioData bus:bus frame:inNumFrames];
UInt32 i;

float* out1 =(float*) ioData->mBuffers[0].mData;
float* out2 =(float*) ioData->mBuffers[1].mData;

out1=out1+preBlankSize*2;
out2=out2+preBlankSize*2;

resetCounter--;
if(resetCounter<=0)
	{
	centreFreq=centreFreqOrig;
	centreDelta*=-1.0;
	noiseUpdateDelta=origNoiseUpdateCount;
	resetCounter=resetEvery;
	masterPan=origPan;
	}



for (i=0; i<inNumFrames; ++i) 
	{
	if(updateCounter<=0)
		{
		//printf("update %f\n",noiseUpdateCount);
		updateCounter=noiseUpdateCount;
		noiseValue=-1.0+random()%noiseLevelQuantise/noiseLevelQuantiseHalf;
		
		}
	
	//if(noiseValue>-0.5) leftSample=noiseValue;
	//else leftSample=-1.0;
	leftSample=noiseValue;
	
	[bandPass setCenterFreq:centreFreq];
	leftSample=[bandPass filter:leftSample];	
		
	if(tapcount>theTapDelay)leftSample=leftSample+tapStrength*tap[(tapcount-theTapDelay)%maxTapSize]; 
	tap[tapcount%maxTapSize]=leftSample;
	tapcount++;	
		

	
	*out1++ = leftSample*masterGain*masterPan;
	*out2++ = leftSample*masterGain*(1.0-masterPan);


	centreFreq+=centreDelta;
	if(centreFreq<400.0) centreFreq=400.0;
	noiseUpdateCount+=noiseUpdateDelta;
	updateCounter--;
	
	//masterPan+=panShift;
	//if(masterPan>1.0) masterPan=1.0; else
	//if(masterPan<0.0) masterPan=0.0;
	}
	
return noErr;
}
// ************************************************************************************************


@end
