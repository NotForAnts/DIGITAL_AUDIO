// ***************************************************************************************
//  WXDSNOISEone
//  Created by Paul Webb on Mon Sep 19 2005.
// ***************************************************************************************
#import "WXDSNOISEone.h"


@implementation WXDSNOISEone

// ***************************************************************************************
-(id)   init
{
if(self=[super init])
	{
	combineType=1;
	delta1=1.62636191114421113646;
	delta2=0.00002591641978933724;
	delta3=-0.00000201702812595130;
	delta4=1.52534652831449180077;
	delta5=-0.00000302063911918564;

	deltaStart1=delta1;
	deltaStart2=delta2;
	deltaStart4=delta4;

	degree1=degree2=0;

	maxRateEvery=3;
	resetEvery=6008;
	resetCount=resetEvery;	
	
	doPanShift=YES;
	masterPan=origPan=0.5111200333;
	panShift=0.0002101605;
	
	mutateOneActive=YES;
	mutateOneRate=64;	
	mutateOneCount=0;
	mutateStrength=5.0;
	
	reverb=[[WXFilterPRCReverb alloc]initFilter:4.0];
	}
return self;
}
// ************************************************************************************************
//  RANGES FOR THIS FOR A KNOB BOX CONTROL OR EXTERNAL ALGORITHM CONTROL
//  strength 0..10 (when zero no changes occur)
//  rate 1..200
//  every 1...20
//  1=-1.92636191114421113646, 1.92636191114421113646
//  2=-0.00030591641978933724, 0.00030591641978933724
//  4=-1.92534652831449180077, 1.92534652831449180077
// ************************************************************************************************
-(void)			setCombineType:(int)t			{   combineType=t;				}
-(void)			setPanShiftActive:(BOOL)b		{	doPanShift=b;				}
-(void)			setMutateStrength:(float)v		{   mutateStrength=v;			}
-(void)			setMutateRate:(int)v			{   mutateOneRate=v;			}
-(void)			setEveryCount:(int)v			{   resetEvery=v;				}
-(void)			setDeltaStart1:(float)v			{   deltaStart1=v;				}
-(void)			setDeltaStart2:(float)v			{   deltaStart2=v;				}
-(void)			setDeltaStart4:(float)v			{   deltaStart4=v;				}
-(void)			setPanPosition:(float)v			{   masterPan=origPan==v;		}
// ************************************************************************************************
-(void)			setCombineTypeNSO:(id)t			{   combineType=[t floatValue];					}
-(void)			setPanShiftActiveNSO:(id)b		{	doPanShift=[b floatValue];					}
-(void)			setMutateStrengthNSO:(id)v		{   mutateStrength=[v floatValue];				}
-(void)			setMutateRateNSO:(id)v			{   mutateOneRate=[v floatValue];				}
-(void)			setEveryCountNSO:(id)v			{   resetEvery=[v floatValue];					}
-(void)			setDeltaStart1NSO:(id)v			{   deltaStart1=[v floatValue];					}
-(void)			setDeltaStart2NSO:(id)v			{   deltaStart2=[v floatValue];					}
-(void)			setDeltaStart4NSO:(id)v			{   deltaStart4=[v floatValue];					}
-(void)			setPanPositionNSO:(id)v			{   masterPan=origPan=[v floatValue];			}
// ************************************************************************************************
-(void)			doMutate
{
float shift;
if(!mutateOneActive)	return;
if(mutateStrength==0)   return;
mutateOneCount++;
if(mutateOneCount % mutateOneRate!=0)  return;

shift=(deltaStart1*mutateStrength)/500.0;
shift=WXUFloatRandomBetween(-shift,shift);
deltaStart1+=shift;

shift=(deltaStart2*mutateStrength)/200.0;
shift=WXUFloatRandomBetween(-shift,shift);
deltaStart2+=shift;

shift=(deltaStart4*mutateStrength)/100.0;
shift=WXUFloatRandomBetween(-shift,shift);
deltaStart4+=shift;

shift=(origPan*mutateStrength)/10.0;
shift=WXUFloatRandomBetween(-shift,shift);
origPan+=shift;


shift=(panShift*mutateStrength)/10.0;
shift=WXUFloatRandomBetween(-shift,shift);
panShift+=shift;

resetEvery=WXURandomInteger(1,maxRateEvery);

if(origPan<0.2 || origPan>0.8) 
	{
	origPan=0.5;
	panShift=0.0002101605;
	}
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
	[self doMutate];
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
	if(sin(degree1)>sin(degree2)*8) leftSample=1.0; else leftSample=-1.0;
	
	if(combineType>1)   leftSample=sin(degree1)+sin(degree2);
	if(combineType>2)   if(leftSample>sin(degree1)-sin(degree2)) leftSample=1.0; else leftSample=-1.0;
	
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
