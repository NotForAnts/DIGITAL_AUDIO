// ******************************************************************************************
//  WXDSWavemixSynthesisObject
//  Created by Paul Webb on Thu Jul 21 2005.
// ******************************************************************************************

#import "WXDSWavemixSynthesisObject.h"


@implementation WXDSWavemixSynthesisObject

// ******************************************************************************************
-(id)		initFromTime:(int)ctime
{
if(self=[super init])
	{
	waveSize=512;
	done=NO;
	
	masterGain=0.1;	
	renderCount=0;
	renderer=nil;
	theEnvelope=nil;
	thePanEnvelope=nil;
	}
return self;
}
// ******************************************************************************************
-(void)		dealloc
{
if(renderer!=nil)		[renderer release];
if(theEnvelope!=nil)	[theEnvelope release];
if(thePanEnvelope!=nil) [thePanEnvelope release];
[super dealloc];
}
// ******************************************************************************************
-(void)		setStartEndTime:(int)start end:(int)end
{
startTime=start;
endTime=end;
duration=endTime-startTime;
}
// ******************************************************************************************
-(void)		setStartAndDuration:(int)start dur:(int)dur
{
startTime=start;
duration=dur;
endTime=startTime+duration;
}
// ******************************************************************************************
-(int)		duration
{
return duration;
}
// ******************************************************************************************
-(void)		setRenderer:(WXDSRenderBase*)r
{
renderer=r;
}
// ******************************************************************************************
-(void)		setMasterGain:(float)gain
{
masterGain=gain;
}
// ******************************************************************************************
-(void)		setSoundEnvelope:(WXDSEnvelopeBasic*)env
{
theEnvelope=env;
[theEnvelope reset];
}
// ******************************************************************************************
-(void)		setPanEnvelope:(WXDSEnvelopeBasic*)env
{
thePanEnvelope=env;
[thePanEnvelope reset];
}
// ******************************************************************************************
-(BOOL)		done
{
return done;
}

// ******************************************************************************************
-(void)		doRenderWave:(int)ctime ioData:(AudioBufferList*)ioData bus:(UInt32)bus frame:(UInt32)inNumFrames time:(AudioTimeStamp*)timeStamp
{
float*  out1 =(float*) ioData->mBuffers[0].mData;
float*  out2 =(float*) ioData->mBuffers[1].mData;
float   gain;


memset(ioData->mBuffers[0].mData,0,inNumFrames*4);		// fill block with zero chars
memset(ioData->mBuffers[1].mData,0,inNumFrames*4);		// *4 as sizeof(float)==4

UInt32 i;
if(ctime>endTime)   
	{
	done=YES;
	return;
	}


preBlankSize=startTime-ctime;
if(preBlankSize<0)  preBlankSize=0;

if(ctime<=startTime)	currentDuration=duration; else
if(ctime>startTime)		currentDuration=duration-(ctime-startTime);

renderSize=WXUMinInteger(inNumFrames-preBlankSize,currentDuration);
if(renderSize<=0)   return;

if(renderer==nil)   return;

[renderer setPreBlankSize:preBlankSize];
[renderer audioCallbackOnDevice:ioData bus:bus frame:renderSize time:timeStamp];

if(theEnvelope!=nil)	[theEnvelope renderEnvelopeOnto:ioData frame:renderSize skipSize:preBlankSize];
	
// apply the pan gesture to the wave form
// this is too in-efficient
if(thePanEnvelope!=nil) [thePanEnvelope renderEnvelopeForPanOnto:ioData frame:renderSize skipSize:preBlankSize];;


}
// ******************************************************************************************


@end
