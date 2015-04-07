// ***************************************************************************************
//  WXDSEnvelopeSegmentExponential
//  Created by Paul Webb on Sat Jul 23 2005.
// ***************************************************************************************

#import "WXDSEnvelopeSegmentExponential.h"


@implementation WXDSEnvelopeSegmentExponential


// ***************************************************************************************
-(id)		init
{
if(self=[super init])
	{
	gain1=0.0;  gain2=1.0;
	exp1=exp(0.0);
	exp2=exp(5.0);
	erange2=5.0;
	}
return self;
}
// ***************************************************************************************
-(id)		initSegmentExp:(float)g1 g2:(float)g2
{
if(self=[super init])
	{
	gain1=g1;
	gain2=g2;
	
	exp1=exp(0.0);
	exp2=exp(5.0);
	erange2=5.0;
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

expvalue=WXUNormalise(counter,0,evelopeDuration,0,erange2);
expvalue=exp(expvalue);
return WXUNormalise(expvalue,exp1,exp2,gain1,gain2);
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
	expvalue=WXUNormalise(counter,0,evelopeDuration,0,erange2);
	expvalue=exp(expvalue);
	gain=WXUNormalise(expvalue,exp1,exp2,gain1,gain2);
	out1[i+skipSize] = out1[i+skipSize]*gain;
	out2[i+skipSize] = out2[i+skipSize]*gain;
	}
}
// ***************************************************************************************




@end
