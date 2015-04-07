// ***************************************************************************************
//  WXDSEnvelopeBasic
//  Created by Paul Webb on Fri Jul 22 2005.
// ***************************************************************************************

#import "WXDSEnvelopeBasic.h"


@implementation WXDSEnvelopeBasic


// ***************************************************************************************
-(id)		init
{
if(self=[super init])
	{
	done=NO;
	counter=-1;
	}
return self;
}
// ***************************************************************************************
-(id)		initEvelope:(int)duration attack:(int)attack release:(int)release
{
if(self=[super init])
	{
	done=NO;
	evelopeDuration=duration;
	attackTime=attack;	
	releaseTime=release; 
	releaseStart=duration-release;
	counter=-1;
	}
return self;
}
// ***************************************************************************************
-(void)		dealloc
{
[super dealloc];
}
// ***************************************************************************************
-(void)		reset								
{
done=NO;   
counter=-1;						
}
// ***************************************************************************************
-(BOOL)		done								{	return done;														}
-(int)		evelopeDuration						{	return evelopeDuration;												}
-(void)		setDuration:(int)duration			{   evelopeDuration=duration;	[self setDurationExtra];				}
-(void)		setDurationExtra					{}
-(void)		setAttack:(int)attack				{   attackTime=attack;													}
-(void)		setRelease:(int)release				{	releaseTime=release;	releaseStart=evelopeDuration-release;		}

// ***************************************************************************************
//  OVERRRIDE THIS
// ***************************************************************************************
-(float)	tick
{
counter++;
if(counter>=evelopeDuration) done=YES;
if(counter<attackTime)				return WXUNormalise(counter,0,attackTime,0.0,1.0);
if(counter>=releaseStart)			return WXUNormalise(counter,releaseStart,evelopeDuration,1.0,0.0);

return 1.0;
}
// ***************************************************************************************
-(void)		renderEnvelopeForPanOnto:(AudioBufferList*)ioData frame:(UInt32)inNumFrames skipSize:(int)skipSize
{
UInt32 i;
float*  out1 =(float*) ioData->mBuffers[0].mData;
float*  out2 =(float*) ioData->mBuffers[1].mData;
float   gain;

for (i=0; i<inNumFrames; i++) 
	{
	gain=1.0;
	counter++;
	if(counter>=evelopeDuration)		done=YES;
	if(counter<attackTime)				gain=WXUNormalise(counter,0,attackTime,0.0,1.0);   else
	if(counter>=releaseStart)			gain=WXUNormalise(counter,releaseStart,evelopeDuration,1.0,0.0);
	
	out1[i+skipSize] = out1[i+skipSize]*gain;
	out2[i+skipSize] = out2[i+skipSize]*(1.0-gain);
	}
}
// ***************************************************************************************
-(void)		renderEnvelopeOnto:(AudioBufferList*)ioData frame:(UInt32)inNumFrames skipSize:(int)skipSize
{
UInt32 i;
float*  out1 =(float*) ioData->mBuffers[0].mData;
float*  out2 =(float*) ioData->mBuffers[1].mData;
float   gain;

for (i=0; i<inNumFrames; i++) 
	{
	gain=1.0;
	counter++;
	if(counter>=evelopeDuration)		done=YES;
	if(counter<attackTime)				gain=WXUNormalise(counter,0,attackTime,0.0,1.0);   else
	if(counter>=releaseStart)			gain=WXUNormalise(counter,releaseStart,evelopeDuration,1.0,0.0);
	
	out1[i+skipSize] = out1[i+skipSize]*gain;
	out2[i+skipSize] = out2[i+skipSize]*gain;
	}
}
// ***************************************************************************************


@end
