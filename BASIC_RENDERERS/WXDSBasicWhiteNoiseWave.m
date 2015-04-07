// ***************************************************************************************
//  WXDSBasicWhiteNoiseWave
//  Created by Paul Webb on Wed Apr 13 2005.
// ***************************************************************************************
#import "WXDSBasicWhiteNoiseWave.h"


@implementation WXDSBasicWhiteNoiseWave

// ************************************************************************************************
-(id)		init
{
if(self=[super init])
	{
	[self setMasterPan:0.5];
	[self setMasterGain:0.0];
	filterSeries=nil;
	isActive=YES;
	
	changeChance=0;
	resolution=128;
	counter=0;
	
	reverb=[[WXFilterPRCReverb alloc]initFilter:1.5];
	combFilter=[[WXCombFilterFeedBack alloc]initComb:88200 delay:1000];
	[combFilter setDelay:22595];
	[combFilter setFStrength:-0.86];
	}
return self;
}
// ************************************************************************************************
-(void)		setCombFB:(float)v
{
[combFilter setFStrength:v];
}
// ************************************************************************************************
-(void)		setCombDelay:(float)v
{
[combFilter setDelay:v];
}

// ************************************************************************************************
-(void)		setChangeChance:(int)v
{
changeChance=v;
}
// ************************************************************************************************
-(void)		setResolutionNSO:(id)r			{   resolution=[r floatValue];		}
-(void)		setResolution:(int)r			{	resolution=r;					}
// ************************************************************************************************
-(OSStatus)		audioCallbackOnDevice:(AudioBufferList*)ioData bus:(UInt32)bus frame:(UInt32)inNumFrames time:(AudioTimeStamp*)timeStamp
{
if(!isActive) return [self RenderBlank:ioData bus:bus frame:inNumFrames];
UInt32 i;
float* out1 =(float*) ioData->mBuffers[0].mData;
float* out2 =(float*) ioData->mBuffers[1].mData;
out1=out1+preBlankSize*2;
out2=out2+preBlankSize*2;

if(WXURandomInteger(0,100)<changeChance)
	{
	resolution=WXURandomInteger(1,8);
	}
	
if(changeChance>90)
	{
	if(WXURandomInteger(0,100)<10)	[combFilter setDelay:WXURandomInteger(10,150)];
	if(WXURandomInteger(0,100)<5)	[combFilter setDelay:WXURandomInteger(1000,44150)];
	if(WXURandomInteger(0,100)<10)	[combFilter setFStrength:WXUFloatRandomBetween(0.6,1.0)];
	}


for (i=0; i<inNumFrames; ++i) 
	{
	if(updateCollection!=nil)   [updateCollection doUpdate];
	if( counter % resolution ==0)   currentSample=-1.0+random()%60000/30000.0;
	counter++;
	
	theSample= currentSample;
	

	theSample=[combFilter  filter:theSample];
	//theSample=[reverb filter:theSample];
	
	theSample*=masterGain;
	*out1++ = theSample;//*panRight;
	*out2++ = theSample;//*panLeft;	
	
	}
	
//if(filterSeries!=nil)
//	[filterSeries filterChunk:(float*) ioData->mBuffers[0].mData frame:inNumFrames];	
//[self doMonoToStereoPan:ioData frame:inNumFrames];	
return noErr;
}
// ************************************************************************************************


@end
