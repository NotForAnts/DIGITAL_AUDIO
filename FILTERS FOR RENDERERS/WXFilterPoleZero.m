// ************************************************************************************************
//  WXFilterPoleZero
//  Created by Paul Webb on Thu Aug 18 2005.
// ************************************************************************************************

#import "WXFilterPoleZero.h"


@implementation WXFilterPoleZero

// ************************************************************************************************
-(id)   init
{
if(self=[super init])
	{  // Default setting for pass-through.
	float B[2] = {1.0, 0.0};
	float A[2] = {1.0, 0.0};
	[super setCoefficients:2 bc:B na:2 ac:A];
	}
return self;
}
// ************************************************************************************************
-(void) clear
{
[super clear];
}
// ************************************************************************************************
-(void) setB0NSO:(id)b0						{   [self setB0:[b0 floatValue]];					}
-(void) setB1NSO:(id)b1						{   [self setB1:[b1 floatValue]];					}
-(void) setA1NSO:(id)a1						{   [self setA1:[a1 floatValue]];					}
-(void) setAllpassNSO:(id)coefficient		{   [self setAllpass:[coefficient floatValue]];		}
-(void) setBlockZeroNSO:(id)thePole			{   [self setBlockZero:[thePole floatValue]];		}
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
-(void) setA1:(float)a1
{
a[1] = a1;
}
// ************************************************************************************************
-(void) setAllpass:(float)coefficient
{
b[0] = coefficient;
b[1] = 1.0;
a[0] = 1.0; // just in case
a[1] = coefficient;
}
// ************************************************************************************************
-(void) setBlockZeroDef
{
[self setBlockZero:0.99];
}
// ************************************************************************************************
-(void) setBlockZero:(float)thePole
{
b[0] = 1.0;
b[1] = -1.0;
a[0] = 1.0; // just in case
a[1] = -thePole;
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
return outputs[0];
}
// ************************************************************************************************
-(float) filter:(float)sample
{
inputs[0] = gain * sample;
outputs[0] = b[0] * inputs[0] + b[1] * inputs[1] - a[1] * outputs[1];
inputs[1] = inputs[0];
outputs[1] = outputs[0];
return outputs[0];
}
// ************************************************************************************************

@end
