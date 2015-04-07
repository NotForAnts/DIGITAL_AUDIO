// ***************************************************************************************
//  WXDSEnvelopeSegmentGaussian
//  Created by Paul Webb on Sun Jul 24 2005.
// ***************************************************************************************

#import "WXDSEnvelopeSegmentGaussian.h"


@implementation WXDSEnvelopeSegmentGaussian
// ***************************************************************************************
-(id)		init
{
if(self=[super init])
	{
	gain1=0.0;  gain2=1.0;
	maxMap=0.168311;
	float d=1.0;	
	d=d*d;
	aValue=1.0/(sqrt(pow(2,3.14159*d)));
	}
return self;
}
// ***************************************************************************************
-(id)		initSegmentGaussian:(float)g1 g2:(float)g2
{
if(self=[super init])
	{
	gain1=g1;   gain2=g2;
	maxMap=0.168311;
	float d=1.0;	
	d=d*d;
	aValue=1.0/(sqrt(pow(2,3.14159*d)));
	}
return self;
}
// ***************************************************************************************
-(void)		dealloc
{
[super dealloc];
}
// ***************************************************************************************
-(void)		setDuration:(int)duration			
{   
evelopeDuration=duration;		
halfDuration=evelopeDuration/2;			
}
// ***************************************************************************************
-(float)	tick
{
counter++;
if(counter>=evelopeDuration) done=YES;

float   b,x;


if(counter<=halfDuration) x=WXUNormalise(counter,0,halfDuration,-250,0);		else
if(counter>=halfDuration) x=WXUNormalise(counter,halfDuration,evelopeDuration,0,250);	
x=x/100.0;
b=pow(2.718282,-(x*x))/2;	b=aValue*b;	
return WXUNormalise(b,0,maxMap,gain1,gain2);


}
// ***************************************************************************************
-(void)		renderEnvelopeOnto:(AudioBufferList*)ioData frame:(UInt32)inNumFrames skipSize:(int)skipSize
{
UInt32 i;
float*  out1 =(float*) ioData->mBuffers[0].mData;
float*  out2 =(float*) ioData->mBuffers[1].mData;
float   gain=1.0;
float   b,x;

for (i=0; i<inNumFrames; i++) 
	{
	counter++;
	if(counter>=evelopeDuration) done=YES;
	if(counter<=halfDuration) x=WXUNormalise(counter,0,halfDuration,-250,0);		else
	if(counter>=halfDuration) x=WXUNormalise(counter,halfDuration,evelopeDuration,0,250);	
	x=x/100;
	b=pow(2.718282,-(x*x))/2;	b=aValue*b;	
	gain=WXUNormalise(b,0,maxMap,gain1,gain2);
	
	out1[i+skipSize] = out1[i+skipSize]*gain;
	out2[i+skipSize] = out2[i+skipSize]*gain;
	}
}
// ***************************************************************************************


@end
