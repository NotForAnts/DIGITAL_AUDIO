// ************************************************************************************************
//  WXDSBasicSineworkSix
//  Created by Paul Webb on Thu Jul 28 2005.
// ************************************************************************************************

#import "WXDSBasicSineworkSix.h"


@implementation WXDSBasicSineworkSix

// ************************************************************************************************
-(id)		initWithFreq:(double)r
{
if(self=[super initWithFreq:r])
	{
	freq=r;
	[self setParameters];
	
	reverb=[[WXFilterPRCReverb alloc]initFilter:3.0];
	}
return self;
}

// ************************************************************************************************
-(void)		setParameters
{
leftSample=-1.0;
pulseCount=0;
pulseLength=10000*20;

	delta2=WXUFloatRandomBetween(0.0,0.0002);
	if(WXUPercentChance(50))	delta2=delta2*-1.0;
	delta2=delta2/WXUFloatRandomBetween(1.0,20.0);
	
	delta3=WXUFloatRandomBetween(0.0,0.0002);
	if(WXUPercentChance(50))	delta3=delta3*-1.0;
	delta3=delta3/WXUFloatRandomBetween(10.0,1000.0);	

delta2Orig=delta2;
delta1Orig=delta1;


if(WXUPercentChance(50))	origPan=WXUFloatRandomBetween(0.0,0.4); else origPan=WXUFloatRandomBetween(0.6,1.0);
[self setMasterPan:origPan]; 
panShift=WXUFloatRandomBetween(0.0,0.008);
panShift=panShift/10.0;
//if(WXUPercentChance(30))	panShift=WXUFloatRandomBetween(0.0,0.01);
if(origPan>0.5)	panShift=panShift*-1.0;
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
	if(++pulseCount>=pulseLength)
		{
		pulseCount=0;
		delta1=delta1Orig;
		delta2=delta2Orig;
		masterPan=origPan;
		//panShift=panShift*-1.0;
		
		//degree1=0.0;
		//leftSample=-1.0;
		//delta1Orig=delta1Orig*WXUFloatRandomBetween(0.8,1.2);
		//delta3=delta3*-1.0;
		}
	
	addDelta=sin(degree1);
	if(addDelta<-0.3) addDelta=-addDelta;
	leftSample=leftSample+addDelta;
	if(leftSample>1.0) leftSample=-1.0;
	if(leftSample<-1.0) leftSample=1.0;
	useValue=leftSample*addDelta;
	//if(leftSample>=0.0) useValue=1.0; else useValue=-1.0;
	
	*out1++ = useValue*masterGain*masterPan;
	*out2++ = useValue*masterGain*(1.0-masterPan);

	degree1+=delta1;
	delta1+=delta2;
	delta2+=delta3;
	
	masterPan+=panShift;
	if(masterPan>1.0) masterPan=1.0; else
	if(masterPan<0.0) masterPan=0.0; 	
	}
	
[reverb filterChunk:(float*) ioData->mBuffers[0].mData frame:inNumFrames];	
[self doMonoToStereoPan:ioData frame:inNumFrames];
	
return noErr;




}


@end
