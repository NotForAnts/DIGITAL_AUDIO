// ************************************************************************************************
//  WXDSBasicSinework
//  Created by Paul Webb on Mon Jul 25 2005.
// ************************************************************************************************

#import "WXDSBasicSinework.h"


@implementation WXDSBasicSinework


// ************************************************************************************************
-(id)		initWithFreq:(double)r
{
if(self=[super initWithFreq:r])
	{
	typeCount=0;
	
	}
return self;
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

if(typeCount<=0) 
	{
	typeCount=WXURandomInteger(2,50);
	delta2=WXUFloatRandomBetween(0.0,0.0002);
	if(WXUPercentChance(50))	delta2=delta2*-1.0;
	delta2=delta2/WXUFloatRandomBetween(1.0,20.0);
	delta3=WXUFloatRandomBetween(0.0,0.0002);
	if(WXUPercentChance(50))	delta3=delta3*-1.0;
	delta3=delta3/WXUFloatRandomBetween(100.0,10000.0);
	
	flipChance1=0;
	if(WXUPercentChance(30)) flipChance1=WXURandomInteger(10,100);
	
	flipChance2=0;
	if(WXUPercentChance(10)) flipChance2=WXURandomInteger(10,40);	
	}
	
typeCount--;

if(WXUPercentChance(flipChance2)) 
	{
	delta2=delta2*-1.0;
	flipChance2--;
	}
	
if(WXUPercentChance(flipChance1)) 
	{
	delta3=delta3*-0.75;
	[self setMasterPan:1-masterPan];
	flipChance1--;
	}

for (i=0; i<inNumFrames; ++i) 
	{
	leftSample=sin(degree1);
	*out1++ = leftSample*masterGain*panRight;
	*out2++ = leftSample*masterGain*panLeft;

	degree1+=delta1;
	delta1+=delta2;
	delta2+=delta3;
	}
	
return noErr;
}
// ************************************************************************************************

@end
