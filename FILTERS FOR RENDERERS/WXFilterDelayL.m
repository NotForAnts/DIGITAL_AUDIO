// ************************************************************************************************
//  WXFilterDelayL
//  Created by Paul Webb on Wed Dec 29 2004.
// ************************************************************************************************/

#import "WXFilterDelayL.h"


@implementation WXFilterDelayL

// ************************************************************************************************
-(id)   initDelay:(long)theDelay md:(long)maxDelay
{
if(self=[super initDelay:theDelay md:maxDelay])
	{
	// Writing before reading allows delays from 0 to length-1. 
	length = maxDelay+1;

	if ( length > 4096 ) {
		// We need to delete the previously allocated inputs.
		free(inputs);
		inputs=malloc(length*sizeof(float));
		[self clear];
		}

	inPoint = 0;
	[self setDelay:theDelay];
	doNextOut = YES;	
	}
return self;
}
// ******************************************************************************************
-(void)		dealloc
{
[super dealloc];
}
// ************************************************************************************************
-(void)		setDelayNSO:(long)theDelay
{
[self setDelay:[theDelay floatValue]];
}
// ************************************************************************************************
-(void)		setDelay:(long)theDelay
{
float outPointer;

if (theDelay > length-1) {
    // Force delay to maxLength
    outPointer = inPoint + 1.0;
    delay = length - 1;
  }
  else if (theDelay < 0 ) {
    outPointer = inPoint;
    delay = 0;
  }
  else {
    outPointer = inPoint - theDelay;  // read chases write
    delay = theDelay;
  }

while (outPointer < 0)
    outPointer += length; // modulo maximum length

outPoint = (long) outPointer;  // integer part
alpha = outPointer - outPoint; // fractional part
omAlpha = (float) 1.0 - alpha;
}
// ************************************************************************************************
-(float)	getDelay
{
return delay;
}
// ************************************************************************************************
-(float)	nextOut
{
if ( doNextOut ) {
    // First 1/2 of interpolation
    nextOutput = inputs[outPoint] * omAlpha;
    // Second 1/2 of interpolation
    if (outPoint+1 < length)
      nextOutput += inputs[outPoint+1] * alpha;
    else
      nextOutput += inputs[0] * alpha;
    doNextOut = false;
  }

return nextOutput;
}
// ************************************************************************************************
-(void)		filterChunk:(float*)ioData frame:(UInt32)inNumFrames
{
UInt32 i;
float inputSample;

for (i=0; i<inNumFrames; ++i) 
	{
	inputSample=*ioData;
	inputs[inPoint++] = inputSample;

	// Increment input pointer modulo length.
	if (inPoint == length)
		inPoint -= length;

	outputs[0] = [self nextOut];
	doNextOut = true;

	// Increment output pointer modulo length.
	if (++outPoint >= length)
		outPoint -= length;
		*ioData++=outputs[0];
	}
}
// ************************************************************************************************
-(float)	filter:(float)sample
{
inputs[inPoint++] = sample;

// Increment input pointer modulo length.
if (inPoint == length)
    inPoint -= length;

outputs[0] = [self nextOut];
doNextOut = true;

// Increment output pointer modulo length.
if (++outPoint >= length)
    outPoint -= length;

return outputs[0];
}
// ************************************************************************************************


@end
