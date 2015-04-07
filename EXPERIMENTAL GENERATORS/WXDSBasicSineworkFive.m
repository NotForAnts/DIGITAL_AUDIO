// ************************************************************************************************
//  WXDSBasicSineworkFive
//  Created by Paul Webb on Thu Jul 28 2005.
// ************************************************************************************************



#import "WXDSBasicSineworkFive.h"


@implementation WXDSBasicSineworkFive


// ************************************************************************************************
-(id)		initWithFreq:(double)r
{
if(self=[super initWithFreq:r])
	{
	freq=r;
	[self setParameters];
	
	}
return self;
}
// ************************************************************************************************
-(void)			setParameters
{
degree2=0;
panCounter=0;

panTime1=WXURandomInteger(135,180);
panTime2=WXURandomInteger(600,1200);
silentCount=WXURandomInteger(320,850);
//silentCount=5;
totalPanTime=panTime1+panTime2+(silentCount*1);

panChangeTime=panTime1+silentCount;
pan2EndTime=panChangeTime+panTime2;

pan1=0.0;
pan2=WXUFloatRandomBetween(0.01,0.04);
pdelta1=0;//(pan2-pan1)/(float)panTime1;

pan3=1.0;
pan4=WXUFloatRandomBetween(0.3,0.95);
pdelta2=(pan4-pan3)/(double)panTime2;

delta2=WXUFloatRandomBetween(0.0,0.0002);
if(WXUPercentChance(50))	delta2=delta2*-1.0;
delta2=delta2/WXUFloatRandomBetween(1.0,4.0);
	
delta3=WXUFloatRandomBetween(0.0,0.0002);
if(WXUPercentChance(50))	delta3=delta3*-1.0;
delta3=delta3/WXUFloatRandomBetween(10.0,100.0);	

delta4=WXUFreqToDelta(WXURandomInteger(200,12000));
	
delta1Orig=delta1;
delta2Orig=delta2;
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



for (i=0; i<inNumFrames; ++i) 
	{
	if(panCounter==0)
		{
		inSilence=NO;
		masterPan=pan1;
		currentPanDelta=pdelta1;
		delta1=delta1Orig*10;
		delta2=delta2Orig;
		}
	
	if(panCounter==panTime1) inSilence=YES;
	//if(panCounter==pan2EndTime) inSilence=YES;
	
	
	if(panCounter==panChangeTime)
		{
		inSilence=NO;
		masterPan=pan3;
		currentPanDelta=pdelta2;
		delta1=delta1Orig;
		delta2=delta2Orig;
		}
		
	panCounter++;
	if(panCounter>=totalPanTime) panCounter=0;
	
	if(inSilence) leftSample=0.0; else 
		{
		if(sin(degree1)>sin(degree2)) leftSample=1.0; else leftSample=-1.0;
		}
	
	
	*out1++ = leftSample*masterGain*masterPan;
	*out2++ = leftSample*masterGain*(1.0-masterPan);
	
	degree1+=delta1;
	degree2+=delta4;
	if(!inSilence) 
		{
		masterPan+=currentPanDelta;
		
		delta1+=delta2;
		delta2+=delta3;

		}
	}
	
return noErr;
}
// ************************************************************************************************

@end
