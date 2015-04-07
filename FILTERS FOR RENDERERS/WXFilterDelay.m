// ************************************************************************************************
//  WXFilterDelay
//  Created by Paul Webb on Wed Dec 29 2004.
// ************************************************************************************************

#import "WXFilterDelay.h"


@implementation WXFilterDelay

// ************************************************************************************************
-(id)   initDelay:(long)theDelay md:(long)maxDelay;
{
if(self=[super init])
	{
	length = maxDelay+1;
	// We need to delete the previously allocated inputs.
	free(inputs);
	inputs = malloc(length*sizeof(float));
	[self clear];

	inPoint = 0;
	[self setDelay:theDelay];
	}
return self;
}
// ******************************************************************************************
-(void)		dealloc
{
//free(inputs);
[super dealloc];
}
// ************************************************************************************************
-(void)		clear
{
long i;
for (i=0;i<length;i++) inputs[i] = 0.0;
outputs[0] = 0.0;
}
// ***************************************************************************************
-(void)		doController:(int)index value:(float)value
{
switch(index)
	{
	case 1: [self setDelay:value]; break;
	}
}
// ************************************************************************************************
-(void)		setDelayNSO:(id)theDelay
{
[self   setDelay:[theDelay floatValue]];
}
// ************************************************************************************************
-(void)		setDelay:(long)theDelay
{
if (theDelay > length-1) 
	{ 
	// The value is too big.
    // Force delay to maxLength.
    outPoint = inPoint + 1;
    delay = length - 1;
	}
else if (theDelay < 0 ) 
	{
    outPoint = inPoint;
    delay = 0;
	}
else 
	{
    outPoint = inPoint - (long) theDelay;  // read chases write
    delay = theDelay;
	}

while (outPoint < 0) outPoint += length;  // modulo maximum length
}
// ************************************************************************************************
-(long)		getDelay
{
return (long)delay;
}
// ************************************************************************************************
-(float)	energy
{
int i;
register float e = 0;
if(inPoint >= outPoint) 
	{
    for (i=outPoint; i<inPoint; i++) 
		{
		register float t = inputs[i];
		e += t*t;
		}
	} 
else 
	{
    for (i=outPoint; i<length; i++) 
		{
		register float t = inputs[i];
		e += t*t;
		}
    for (i=0; i<inPoint; i++)   
		{
		register float t = inputs[i];
		e += t*t;
		}
	}
return e;
}
// ************************************************************************************************
-(float)	contentsAt:(unsigned long)tapDelay
{
long i = tapDelay;
if (i < 1) 
	{
    i = 1;
	}
else if (i > delay) 
	{
    i = (long) delay;
	}

long tap = inPoint - i;
if (tap < 0) // Check for wraparound.
    tap += length;

return inputs[tap];
}
// ************************************************************************************************
-(float)	lastOut
{
return [super lastOut];
}
// ************************************************************************************************
-(float)	nextOut
{
return inputs[outPoint];
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

	// Check for end condition
	if (inPoint == length)
		inPoint -= length;

	// Read out next value
	outputs[0] = inputs[outPoint++];

	if (outPoint>=length)
		outPoint -= length;
	*ioData++=outputs[0];
	}
}
// ************************************************************************************************
-(float)	filter:(float)sample
{
inputs[inPoint++] = sample;

// Check for end condition
if (inPoint == length)
    inPoint -= length;

// Read out next value
outputs[0] = inputs[outPoint++];

if (outPoint>=length)
    outPoint -= length;

return outputs[0];
}
// ************************************************************************************************


@end
