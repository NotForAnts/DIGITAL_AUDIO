// ************************************************************************************************
//  WXDSBasicSineworkFour
//  Created by Paul Webb on Tue Jul 26 2005.
// ************************************************************************************************

#import "WXDSBasicSineworkFour.h"


@implementation WXDSBasicSineworkFour


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
-(void)		dealloc
{
[super dealloc];
}
// ************************************************************************************************
-(void)		setParameters
{
pulseCount=0;
pulseRate=44100/freq;
pulseRateDelta1=WXUFloatRandomBetween(0.0,0.002);
if(WXUPercentChance(50))	pulseRateDelta1=pulseRateDelta1*-1.0;

pulseRateDelta2=WXUFloatRandomBetween(0.0,0.00002);
if(WXUPercentChance(50))	pulseRateDelta2=pulseRateDelta2*-1.0;
pulseRateDelta2=pulseRateDelta2/WXUFloatRandomBetween(10.0,100.0);	

pulsePeriod=WXURandomInteger(10,30);
sustainLevel=WXURandomInteger(5,20);

pulseLevel=1.0;
pulseDelta1=-2.0/pulsePeriod;


pan1=WXUFloatRandomBetween(0.0,1.0);
pan2=WXUFloatRandomBetween(0.0,1.0);


pulseDelta2=WXUFloatRandomBetween(0.0,0.00002);
//if(WXUPercentChance(50));
pulseDelta2=pulseDelta2*-1.0;
pulseDelta2=pulseDelta2/WXUFloatRandomBetween(100.0,1000.0);	

resetEvery=WXURandomInteger(2,10);
resetEveryCount=resetEvery;

panDelta=(pan2-pan1)/(float)(resetEveryCount*512.0);
if(WXUPercentChance(90)) panDelta=panDelta*WXUFloatRandomBetween(3.0,5.0);

paramSetEvery=WXURandomInteger(2,160);
paramSetCount=paramSetEvery;

pulseRateOrig=pulseRate;
pulseRateDelta1Orig=pulseRateDelta1;
pulseDelta1Orig=pulseDelta1;
}


// ************************************************************************************************
-(void)		mutateParameters
{
pulseDelta1*=WXUFloatRandomBetween(0.8,1.2);
pulseDelta2*=WXUFloatRandomBetween(0.8,1.2);
pulseRateDelta2*=WXUFloatRandomBetween(0.8,1.2);
pulseRateDelta1*=WXUFloatRandomBetween(0.8,1.2);
panDelta*=WXUFloatRandomBetween(0.8,1.2);
resetEvery*=WXUFloatRandomBetween(0.5,2.0);
resetEveryCount=resetEvery;



pulseRateOrig=pulseRate;
pulseRateDelta1Orig=pulseRateDelta1;
pulseDelta1Orig=pulseDelta1;
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

if(--paramSetCount<=0)
	[self mutateParameters];

if(--resetEveryCount<=0)
	{
	pulseRate=pulseRateOrig;
	pulseRateDelta1=pulseRateDelta1Orig;
	pulseDelta1=pulseDelta1Orig;
	resetEveryCount=resetEvery;
	masterPan=pan1;
	}
	

for (i=0; i<inNumFrames; ++i) 
	{
	if(pulseCount==0)   pulseLevel=1.0;
	
	
	
	pulseCount++;
	if(pulseCount>=pulseRate)   pulseCount=0;
	
	leftSample=pulseLevel;
	*out1++ = leftSample*masterGain*masterPan;
	*out2++ = leftSample*masterGain*(1.0-masterPan);

	if(resetEveryCount<sustainLevel)
		{
		pulseLevel-=pulseDelta1;
		pulseDelta1+=pulseDelta2;
		pulseRate+=pulseRateDelta1;
		pulseRateDelta1+=pulseRateDelta2;
		}
	
	if(pulseLevel<-1.0) pulseLevel=-1.0;
	masterPan+=panDelta;
	
	if(masterPan>1.0) masterPan=1.0; else
	if(masterPan<0.0) masterPan=0.0; 	
	}
	
return noErr;
}
// ************************************************************************************************



@end
