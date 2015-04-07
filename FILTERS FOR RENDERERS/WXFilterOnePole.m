// ******************************************************************************************
//  WXFilterOnePole
//  Created by Paul Webb on Thu Dec 30 2004.
// ******************************************************************************************

#import "WXFilterOnePole.h"


@implementation WXFilterOnePole

// ******************************************************************************************
-(id)   init
{
if(self=[super init])
	{
	float B = 0.1;
	float A[2] = {1.0, -0.9};
	[super setCoefficients:1 bc:&B na:2 ac:A];
	}
return self;
}
// ******************************************************************************************
-(id)   initFilter:(float)thePole
{
if(self=[super init])
	{
	float B;
	float A[2] = {1.0, -0.9};
	// Normalize coefficients for peak unity gain.
	if (thePole > 0.0)
		B = (float) (1.0 - thePole);
	else
		B = (float) (1.0 + thePole);

	A[1] = -thePole;
	[super setCoefficients:1 bc:&B na:2 ac:A];
	}
return self;
}
// ******************************************************************************************	
-(void)		clear
{
[super clear];
}
// ***************************************************************************************
-(void)		doController:(int)index value:(float)value
{
switch(index)
	{
	case 1:		[self setB0:value];			break;
	case 2:		[self setA1:value];			break;
	case 3:		[self setPole:value];		break;
	case 4:		[self setGain:value];		break;
	}
}
// ******************************************************************************************
-(void)		setB0NSO:(id)b0				{   [self setB0:[b0 floatValue]];			}
-(void)		setA1NSO:(id)a1				{   [self setA1:[a1 floatValue]];			}
-(void)		setPoleNSO:(id)thePole		{   [self setPole:[thePole floatValue]];	}
-(void)		setGainNSO:(id)theGain		{   [self setGain:[theGain floatValue]];	}
// ******************************************************************************************
-(void)		setB0:(float)b0
{
b[0] = b0;
}
// ******************************************************************************************
-(void)		setA1:(float)a1
{
a[1] = a1;
}
// ******************************************************************************************
-(void)		setPole:(float)thePole
{
// Normalize coefficients for peak unity gain.
if (thePole > 0.0)
    b[0] = (float) (1.0 - thePole);
else
    b[0] = (float) (1.0 + thePole);

a[1] = -thePole;
}
// ******************************************************************************************
-(void)		setGain:(float)theGain
{
[super setGain:theGain];
}
// ******************************************************************************************
-(float)	getGain
{
return [super getGain];
}
// ******************************************************************************************
-(float)	lastOut
{
return [super lastOut];
}
// ************************************************************************************************
-(void)		filterChunk:(float*)ioData frame:(UInt32)inNumFrames
{
UInt32 i;
float inputSample;

for (i=0; i<inNumFrames; ++i) 
	{
	inputSample=*ioData;
	inputs[0] = gain * inputSample;
	outputs[0] = b[0] * inputs[0] - a[1] * outputs[1];
	outputs[1] = outputs[0];
	*ioData++=outputs[0];
	}
}
// ******************************************************************************************
-(float)	filter:(float)sample
{
inputs[0] = gain * sample;
outputs[0] = b[0] * inputs[0] - a[1] * outputs[1];
outputs[1] = outputs[0];

return outputs[0];
}
// ******************************************************************************************



@end
