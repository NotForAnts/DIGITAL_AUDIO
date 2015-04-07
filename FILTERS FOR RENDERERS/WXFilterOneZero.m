// ******************************************************************************************
//  WXFilterOneZero
//  Created by Paul Webb on Thu Dec 30 2004.
// ******************************************************************************************

#import "WXFilterOneZero.h"


@implementation WXFilterOneZero

// ******************************************************************************************
-(id)   init
{
if(self=[super init])
	{
	float B[2] = {0.5, 0.5};
	float A = 1.0;
	[super setCoefficients:2 bc:B na:1 ac:&A];
	}
return self;
}
// ******************************************************************************************
-(id)   initFilter:(float)theZero
{
if(self=[super init])
	{
	float B[2];
	float A = 1.0;

	// Normalize coefficients for unity gain.
	if (theZero > 0.0)
		B[0] = 1.0 / ((float) 1.0 + theZero);
	else
		B[0] = 1.0 / ((float) 1.0 - theZero);

	B[1] = -theZero * B[0];
	[super setCoefficients:2 bc:B na:1 ac:&A];
	}
return self;
}
// ******************************************************************************************
-(void) clear
{
[super clear];
}
// ***************************************************************************************
-(void)		doController:(int)index value:(float)value
{
switch(index)
	{
	case 1:		[self setB0:value];			break;
	case 2:		[self setB1:value];			break;
	case 3:		[self setZero:value];		break;
	case 4:		[self setGain:value];		break;
	}
}
// ******************************************************************************************
-(void) setB0NSO:(id)b0					{   [self setB0:[b0 floatValue]];			}
-(void) setB1NSO:(id)b1					{   [self setB1:[b1 floatValue]];			}
-(void) setZeroNSO:(id)theZero			{   [self setZero:[theZero floatValue]];	}
-(void) setGainNSO:(id)theGain			{   [self setGain:[theGain floatValue]];	}
// ******************************************************************************************
-(void) setB0:(float)b0
{
b[0] = b0;
}
// ******************************************************************************************
-(void) setB1:(float)b1
{
b[1] = b1;
}
// ******************************************************************************************
-(void) setZero:(float)theZero
{
// Normalize coefficients for unity gain.
if (theZero > 0.0)
    b[0] = 1.0 / ((float) 1.0 + theZero);
else
    b[0] = 1.0 / ((float) 1.0 - theZero);

b[1] = -theZero * b[0];
}
// ******************************************************************************************
-(void) setGain:(float)theGain
{
[super setGain:theGain];
}
// ******************************************************************************************
-(float) getGain
{
return [super getGain];
}
// ******************************************************************************************
-(float) lastOut
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
	outputs[0] = b[1] * inputs[1] + b[0] * inputs[0];
	inputs[1] = inputs[0];

	*ioData++=outputs[0];
	}
}
// ******************************************************************************************
-(float) filter:(float)sample
{
inputs[0] = gain * sample;
outputs[0] = b[1] * inputs[1] + b[0] * inputs[0];
inputs[1] = inputs[0];

return outputs[0];
}
// ******************************************************************************************


@end
