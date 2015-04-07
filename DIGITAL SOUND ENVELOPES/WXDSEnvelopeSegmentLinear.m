// ***************************************************************************************
//  WXDSEnvelopeSegmentLinear
//  Created by Paul Webb on Sat Jul 23 2005.
// ***************************************************************************************

#import "WXDSEnvelopeSegmentLinear.h"


@implementation WXDSEnvelopeSegmentLinear

// ***************************************************************************************
-(id)		init
{
if(self=[super init])
	{
	
	}
return self;
}
// ***************************************************************************************
-(id)		initSegmentLinear:(float)g1 g2:(float)g2
{
if(self=[super init])
	{
	gain1=g1;
	gain2=g2;
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
return WXUNormalise(counter,0,evelopeDuration,gain1,gain2);
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
	gain=WXUNormalise(counter,0,evelopeDuration,gain1,gain2);
	out1[i+skipSize] = out1[i+skipSize]*gain;
	out2[i+skipSize] = out2[i+skipSize]*gain;
	}
}
// ***************************************************************************************





// ***************************************************************************************


@end
