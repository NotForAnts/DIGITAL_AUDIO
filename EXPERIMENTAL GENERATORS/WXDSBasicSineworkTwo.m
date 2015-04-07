// ************************************************************************************************
//  WXDSBasicSineworkTwo
//  Created by Paul Webb on Mon Jul 25 2005.
// ************************************************************************************************

#import "WXDSBasicSineworkTwo.h"


@implementation WXDSBasicSineworkTwo





// ************************************************************************************************
-(id)		initWithFreq:(double)r
{
if(self=[super initWithFreq:r])
	{
	doPanShift=YES;
	if(WXUPercentChance(10))	doPanShift=YES;
	
	if(WXUPercentChance(50))	origPan=WXUFloatRandomBetween(0.0,0.4); else origPan=WXUFloatRandomBetween(0.6,1.0);
	[self setMasterPan:origPan]; 
	panShift=WXUFloatRandomBetween(0.0,0.008);
	if(WXUPercentChance(30))	panShift=WXUFloatRandomBetween(0.0,0.01);
	if(origPan>0.5)	panShift=panShift*-1.0;
	
	
	resetEvery=8000;
	resetCount=resetEvery;
	
	delta4=WXUFreqToDelta(WXURandomInteger(200,12000));
	
	delta2=WXUFloatRandomBetween(0.0,0.0002);
	if(WXUPercentChance(50))	delta2=delta2*-1.0;
	delta2=delta2/WXUFloatRandomBetween(1.0,20.0);
	
	delta3=WXUFloatRandomBetween(0.0,0.0002);
	if(WXUPercentChance(50))	delta3=delta3*-1.0;
	delta3=delta3/WXUFloatRandomBetween(100.0,10000.0);	
	
	delta5=WXUFloatRandomBetween(0.0,0.0002);
	if(WXUPercentChance(50))	delta5=delta5*-1.0;
	delta5=delta5/WXUFloatRandomBetween(20.0,10000.0);	
	
	deltaStart1=delta1;
	deltaStart2=delta2;
	deltaStart4=delta4;
	
	degree2=0;
	
	//[self printParams];
	
	reverb=[[WXFilterJohnChowningReverb alloc]initFilter:7.0];
	}
return self;
}
// ************************************************************************************************
-(void)			printParams
{
printf("delta1=%1.20f delta2=%1.20f delta3=%1.20f delta4=%1.20f delta5=%1.20f \n",delta1,delta2,delta3,delta4,delta5);
printf("every %d pan=%1.10f panshift=%1.10f doPan=%d\n",resetEvery,origPan,panShift,doPanShift);
printf("-----\n");
}
// ************************************************************************************************
-(void)			setPanShift:(BOOL)v start:(float)start shift:(float)shift
{
doPanShift=v;
origPan=start;
panShift=shift;
}
// ************************************************************************************************
-(void)			setEvery:(int)v
{
resetEvery=v;
resetCount=resetEvery;
}
// ************************************************************************************************
-(void)			setDeltas:(float)d1 d2:(float)d2 d3:(float)d3 d4:(float)d4 d5:(float)d5
{
delta1=d1;
delta2=d2;
delta3=d3;
delta4=d4;
delta5=d5;

deltaStart1=delta1;
deltaStart2=delta2;
deltaStart4=delta4;
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

resetCount--;
if(resetCount<=0)
	{
	resetCount=resetEvery;
	delta1=deltaStart1;
	delta2=deltaStart2;
	delta4=deltaStart4;
	if(doPanShift)
		{
		origPan*=-1.0;
		panShift*=-1.0;
		}
	masterPan=origPan;	
	}

for (i=0; i<inNumFrames; ++i) 
	{
	if(sin(degree1)>sin(degree2)) leftSample=sin(degree1); else leftSample=sin(degree2);
	
	*out1++ = leftSample*masterGain*masterPan;
	*out2++ = leftSample*masterGain*(1.0-masterPan);

	degree2+=delta4;
	degree1+=delta1;
	delta1+=delta2;
	delta2+=delta3;
	delta4+=delta5;
	
	masterPan+=panShift;
	if(masterPan>1.0) masterPan=1.0; else
	if(masterPan<0.0) masterPan=0.0; 
	}
	
	
[reverb filterChunk:(float*) ioData->mBuffers[0].mData frame:inNumFrames];	
[self doMonoToStereoPan:ioData frame:inNumFrames];	
	
return noErr;
}
// ************************************************************************************************

@end
