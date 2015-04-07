// ************************************************************************************************
//  WXFilterTwoZero.h
//  Created by Paul Webb on Thu Dec 30 2004.
// ************************************************************************************************

#import "WXFilterTwoZero.h"


@implementation WXFilterTwoZero

// ************************************************************************************************
-(id)   init
{
if(self=[super init])
	{
	float B[3] = {1.0, 0.0, 0.0};
	float A = 1.0;
	[super setCoefficients:3 bc:B na:1 ac:&A];
	[self setNotch:240 radius:0.8];
	}
return self;
}
// ******************************************************************************************
-(void)		dealloc
{
[super dealloc];
}
// ************************************************************************************************
-(void) clear
{
[super clear];
}
// ***************************************************************************************
-(void)		doController:(int)index value:(float)value
{
switch(index)
	{
	case 1:		[self setB0:value];						break;
	case 2:		[self setB1:value];						break;
	case 3:		[self setB2:value];						break;
	case 4:		[self setNotchFreq:value];				break;
	case 5:		[self setNotchRadius:value];			break;
	case 6:		[self setGain:value];					break;
	}
}
// ************************************************************************************************
-(void) setB0NSO:(id)b0						{   [self setB0:[b0 floatValue]];					}
-(void) setB1NSO:(id)b1						{   [self setB1:[b1 floatValue]];					}
-(void) setB2NSO:(id)b2						{   [self setB2:[b2 floatValue]];					}
-(void) setNotchFreqNSO:(id)frequency		{   [self setNotchFreq:[frequency floatValue]];		}
-(void) setNotchRadiusNSO:(id)radius		{   [self setNotchRadius:[radius floatValue]];		}
-(void) setGainNSO:(id)theGain				{   [self setGain:[theGain floatValue]];			}
// ************************************************************************************************
-(void) setB0:(float)b0
{
b[0] = b0;
}
// ************************************************************************************************
-(void) setB1:(float)b1
{
b[1] = b1;
}
// ************************************************************************************************
-(void) setB2:(float)b2
{
b[2] = b2;
}
// ************************************************************************************************
-(void)		setNotchFreq:(float)frequency
{
[self setNotch:frequency radius:notchRadius];
}
// ************************************************************************************************
-(void)		setNotchRadius:(float)radius
{
[self setNotch:notchFreq radius:radius];
}
// ************************************************************************************************
-(void) setNotch:(float)frequency radius:(float)radius
{
notchFreq=frequency;
notchRadius=radius;

b[2] = radius * radius;
b[1] = (float) -2.0 * radius * cos(TWO_PI * (double) frequency / 44100.0);

  // Normalize the filter gain.
if (b[1] > 0.0) // Maximum at z = 0.
    b[0] = 1.0 / (1.0+b[1]+b[2]);
else            // Maximum at z = -1.
    b[0] = 1.0 / (1.0-b[1]+b[2]);

b[1] *= b[0];
b[2] *= b[0];
}
// ************************************************************************************************
-(void) setGain:(float)theGain
{
[super setGain:theGain];
}
// ************************************************************************************************
-(float) getGain
{
return [super getGain];
}
// ************************************************************************************************
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
	outputs[0] = b[2] * inputs[2] + b[1] * inputs[1] + b[0] * inputs[0];
	inputs[2] = inputs[1];
	inputs[1] = inputs[0];


	*ioData++=outputs[0];
	}
}
// ************************************************************************************************
-(float) filter:(float)sample
{
inputs[0] = gain * sample;
outputs[0] = b[2] * inputs[2] + b[1] * inputs[1] + b[0] * inputs[0];
inputs[2] = inputs[1];
inputs[1] = inputs[0];

return outputs[0];
}
// ************************************************************************************************


@end
