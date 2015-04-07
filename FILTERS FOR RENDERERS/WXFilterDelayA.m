// ************************************************************************************************
//  WXFilterDelayA.h
//  Created by Paul Webb on Wed Dec 29 2004.
// ************************************************************************************************

#import "WXFilterDelayA.h"


@implementation WXFilterDelayA


// ************************************************************************************************
-(id)		initDelay:(long)theDelay md:(long)maxDelay
{
if(self=[super initDelay:theDelay md:maxDelay])
	{
	length = maxDelay+1;

	if ( length > 4096 ) {
		// We need to delete the previously allocated inputs.
		free(inputs);
		inputs=malloc(length*sizeof(float));
		[self clear];
	  }
	inPoint = 0;
	[self setDelay:theDelay];
	apInput = 0.0;
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
-(void)		clear
{
[super clear];
apInput = 0.0;
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
else if (theDelay < 0.5) {
    outPointer = inPoint + 0.4999999999;
    delay = 0.5;
  }
else {
    outPointer = inPoint - theDelay + 1.0;     // outPoint chases inpoint
    delay = theDelay;
  }

if (outPointer < 0)
    outPointer += length;  // modulo maximum length

outPoint = (long) outPointer;        // integer part
alpha = 1.0 + outPoint - outPointer; // fractional part

if (alpha < 0.5) {
    // The optimal range for alpha is about 0.5 - 1.5 in order to
    // achieve the flattest phase delay response.
    outPoint += 1;
    if (outPoint >= length) outPoint -= length;
    alpha += (float) 1.0;
  }

coeff = ((float) 1.0 - alpha) / ((float) 1.0 + alpha);         // coefficient for all pass
}
// ************************************************************************************************
-(float)	getDelay
{
return (long)delay;
}
// ************************************************************************************************
-(float)	nextOut
{
if ( doNextOut ) {
    // Do allpass interpolation delay.
    nextOutput = -coeff * outputs[0];
    nextOutput += apInput + (coeff * inputs[outPoint]);
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
	doNextOut = YES;

	// Save the allpass input and increment modulo length.
	apInput = inputs[outPoint++];
	if (outPoint == length)
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
doNextOut = YES;

// Save the allpass input and increment modulo length.
apInput = inputs[outPoint++];
if (outPoint == length)
    outPoint -= length;

return outputs[0];
}
// ************************************************************************************************

@end
