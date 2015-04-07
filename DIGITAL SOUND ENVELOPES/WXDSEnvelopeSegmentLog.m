// ***************************************************************************************
//  WXDSEnvelopeSegmentLog
//  Created by Paul Webb on Sat Jul 23 2005.
// ***************************************************************************************

#import "WXDSEnvelopeSegmentLog.h"


@implementation WXDSEnvelopeSegmentLog

// ***************************************************************************************
-(id)		init
{
if(self=[super init])
	{
	gain1=0.0;  gain2=1.0;
	lrange1=100.0;
	log1=log(10.0);
	log2=log(lrange1);
	}
return self;
}
// ***************************************************************************************
-(id)		initSegmentLinear:(float)g1 g2:(float)g2
{
if(self=[super init])
	{
	gain1=g1;   gain2=g2;
	lrange1=100.0;
	log1=log(10.0);
	log2=log(lrange1);
	}
return self;
}
// ***************************************************************************************
-(void)		dealloc
{
[super dealloc];
}
// ***************************************************************************************
-(float)	tick
{
counter++;
if(counter>=evelopeDuration) done=YES;

logvalue=WXUNormalise(counter,0,evelopeDuration,10.0,lrange1);
logvalue=log(logvalue);
return WXUNormalise(logvalue,log1,log2,gain1,gain2);
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
	counter++;
	if(counter>=evelopeDuration) done=YES;
	logvalue=WXUNormalise(counter,0,evelopeDuration,10.0,lrange1);
	logvalue=log(logvalue);
	gain=WXUNormalise(logvalue,log1,log2,gain1,gain2);	
	out1[i+skipSize] = out1[i+skipSize]*gain;
	out2[i+skipSize] = out2[i+skipSize]*gain;
	}
}
// ***************************************************************************************


@end
