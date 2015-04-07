// ************************************************************************************************
//  WXFilterBiQuad.h
//  Created by Paul Webb on Wed Dec 29 2004.
// ************************************************************************************************

#import "WXFilterBiQuad.h"


@implementation WXFilterBiQuad
// ************************************************************************************************
-(id)		initFilter
{
float A[3]={1.0, 0.0, 0.0};
float B[3]={1.0, 0.0, 0.0};
if(self=[super init])
	{
	[super setCoefficients:3 bc:B na:3 ac:A];
	[self setResonance:440 radius:0.7 normalise:YES];
	}
	
return self;
}
// ******************************************************************************************
-(void)		dealloc
{
[super dealloc];
}
// ************************************************************************************************
-(void)		setResonanceFreq:(float)frequency
{
[self setResonance:frequency radius:resoRadius normalise:resoNormalise];
}
// ************************************************************************************************
-(void)		setResonanceRadius:(float)radius
{
[self setResonance:resoFreq radius:radius normalise:resoNormalise];
}
// ************************************************************************************************
/*!
This method determines the filter coefficients corresponding to
two complex-conjugate poles with the given \e frequency (in Hz)
and \e radius from the z-plane origin.  If \e normalize is true,
the filter zeros are placed at z = 1, z = -1, and the coefficients
are then normalized to produce a constant unity peak gain
(independent of the filter \e gain parameter).  The resulting
filter frequency response has a resonance at the given \e
frequency.  The closer the poles are to the unit-circle (\e radius
close to one), the narrower the resulting resonance width.
*/
// ************************************************************************************************
-(void)		setResonance:(float)frequency radius:(float)radius normalise:(BOOL)normalize
{
resoFreq=frequency;
resoRadius=radius;
resoNormalise=normalize;

a[2] = radius * radius;
a[1] = -2.0 * radius * cos(2.0 * 3.14159265359 * frequency / 44100.0);

if(normalize) 
	{
    // Use zeros at +- 1 and normalize the filter peak gain.
    b[0] = 0.5 - 0.5 * a[2];
    b[1] = 0.0;
    b[2] = -b[0];
	}
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
-(void)		setNotch:(float)frequency radius:(float)radius
{
notchFreq=frequency;
notchRadius=radius;
// This method does not attempt to normalize the filter gain.
b[2] = radius * radius;
b[1] = (float) -2.0 * radius * cos(2.0 * 3.14159265359* (double) frequency / 44100.0);
}
// ************************************************************************************************
-(void)		setEqualGainZeroes
{
b[0] = 1.0;
b[1] = 0.0;
b[2] = -1.0;
}
// ************************************************************************************************
-(void)		setGain:(float)theGain
{
[super setGain:theGain];
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
	outputs[0] = b[0] * inputs[0] + b[1] * inputs[1] + b[2] * inputs[2];
	outputs[0] -= a[2] * outputs[2] + a[1] * outputs[1];
	inputs[2] = inputs[1];
	inputs[1] = inputs[0];
	outputs[2] = outputs[1];
	outputs[1] = outputs[0];
	*ioData++=outputs[0];
	}
}

// ************************************************************************************************
-(float)	filter:(float)sample
{
inputs[0] = gain * sample;
outputs[0] = b[0] * inputs[0] + b[1] * inputs[1] + b[2] * inputs[2];
outputs[0] -= a[2] * outputs[2] + a[1] * outputs[1];
inputs[2] = inputs[1];
inputs[1] = inputs[0];
outputs[2] = outputs[1];
outputs[1] = outputs[0];

return outputs[0];
}
// ************************************************************************************************
@end
