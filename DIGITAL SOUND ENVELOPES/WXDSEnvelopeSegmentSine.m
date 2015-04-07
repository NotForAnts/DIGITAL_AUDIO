// ***************************************************************************************
//  WXDSEnvelopeSegmentSine
//  Created by Paul Webb on Sat Jul 23 2005.
// ***************************************************************************************

#import "WXDSEnvelopeSegmentSine.h"


@implementation WXDSEnvelopeSegmentSine
// ***************************************************************************************
-(id)		init
{
if(self=[super init])
	{
	gain1=0.0;  gain2=1.0;
	degree1=270;  degree2=630.0;
	}
return self;
}
// ***************************************************************************************
-(id)		initSegmentLinear:(float)g1 g2:(float)g2
{
if(self=[super init])
	{
	gain1=g1;   gain2=g2;
	degree1=270;  degree2=630.0;
	}
return self;
}
// ***************************************************************************************
-(void)		dealloc
{
[super dealloc];
}

// ***************************************************************************************
-(void)		setDurationExtra
{
radianValue=(6.283185*degree1)/360.0;
radianIncrement=(6.283185*degree2)/360.0-radianValue;
radianIncrement=radianIncrement/(float)evelopeDuration;
}
// ***************************************************************************************
-(void)		setDegree:(float) d1 d2:(float)d2
{
degree1=d1;
degree2=d2;
[self setDurationExtra];
}
// ***************************************************************************************
-(float)	tick
{
counter++;
if(counter>=evelopeDuration) done=YES;
//degree=WXUNormalise(counter,0,evelopeDuration,degree1,degree2);
//degree=(6.283185*degree)/360.0; 
//degree=sin(degree);

 //degree=WXUNormalise(counter,0,evelopeDuration,degree1,degree2);
//degree=(6.283185*degree)/360; 
//degree=sin(radianValue);
//radianValue+=radianIncrement;
	
degree=WXUNormalise(sin(radianValue),-1,1,gain1,gain2);   
radianValue+=radianIncrement;


return degree;
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
	counter++;
	if(counter>=evelopeDuration) done=YES;
	//degree=WXUNormalise(counter,0,evelopeDuration,degree1,degree2);
	//degree=(6.283185*degree)/360; 
	//degree=sin(radianValue);
	//radianValue+=radianIncrement;
	
	gain=WXUNormalise(sin(radianValue),-1,1,gain1,gain2);   
	radianValue+=radianIncrement;
	
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
	counter++;
	if(counter>=evelopeDuration) done=YES;
	//degree=WXUNormalise(counter,0,evelopeDuration,degree1,degree2);
	//degree=(6.283185*degree)/360; 
	//degree=sin(radianValue);
	//radianValue+=radianIncrement;
	
	gain=WXUNormalise(sin(radianValue),-1,1,gain1,gain2);   
	radianValue+=radianIncrement; 
	out1[i+skipSize] = out1[i+skipSize]*gain;   
	out2[i+skipSize] = out2[i+skipSize]*gain;
	}
}
// ***************************************************************************************

@end
