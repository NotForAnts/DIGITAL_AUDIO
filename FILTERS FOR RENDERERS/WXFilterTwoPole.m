// ************************************************************************************************
//  WXFilterTwoPole
//  Created by Paul Webb on Thu Dec 30 2004.
// ************************************************************************************************
#import "WXFilterTwoPole.h"


@implementation WXFilterTwoPole
// ************************************************************************************************
-(id)   init
{
if(self=[super init])
	{
	float B = 1.0;
	float A[3] = {1.0, 0.0, 0.0};
	[self setCoefficients:1 bc:&B na:3 ac:A];
	[self setResonance:440 radius:0.3 normalise:YES];
	}
return self;
}
// ******************************************************************************************
-(void)		dealloc
{
[super dealloc];
}
// ************************************************************************************************
-(void)  clear
{
[super clear];
}
// ***************************************************************************************
-(void)		doController:(int)index value:(float)value
{
switch(index)
	{
	case 1:		[self setB0:value];						break;
	case 2:		[self setA1:value];						break;
	case 3:		[self setA2:value];						break;
	case 4:		[self setResonanceFreq:value];			break;
	case 5:		[self setResonanceRadius:value];		break;
	case 6:		[self setGain:value];					break;
	}
}
// ************************************************************************************************
-(void)  setB0NSO:(id)b0							{   [self setB0:[b0 floatValue]];						}
-(void)  setA1NSO:(id)a1							{   [self setA1:[a1 floatValue]];						}
-(void)  setA2NSO:(id)a2							{   [self setA2:[a2 floatValue]];						}
-(void)  setResonanceFreqNSO:(id)frequency			{   [self setResonanceFreq:[frequency floatValue]];		}
-(void)  setResonanceRadiusNSO:(id)radius			{   [self setResonanceRadius:[radius floatValue]];		}
-(void)  setGainNSO:(id)theGain						{   [self setGain:[theGain floatValue]];				}	
// ************************************************************************************************
-(void)  setB0:(float)b0
{
b[0] = b0;
}
// ************************************************************************************************
-(void)  setA1:(float)a1
{
a[1] = a1;
}
// ************************************************************************************************
-(void)  setA2:(float)a2
{
a[2] = a2;
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
-(void)  setResonance:(float) frequency radius:(float)radius normalise:(BOOL)normalize
{
resoFreq=frequency;
resoRadius=radius;
resoNormalise=normalize;

a[2] = radius * radius;
a[1] = (float) -2.0 * radius * cos(TWO_PI * frequency / 44100.0);

if(normalize) 
	{
    // Normalize the filter gain ... not terribly efficient.
    float real = 1 - radius + (a[2] - radius) * cos(TWO_PI * 2 * frequency / 44100.0);
    float imag = (a[2] - radius) * sin(TWO_PI * 2 * frequency / 44100.0);
    b[0] = sqrt( pow(real, 2) + pow(imag, 2) );
	}
}
// ************************************************************************************************
-(void)  setGain:(float)theGain
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
	outputs[0] = b[0] * inputs[0] - a[2] * outputs[2] - a[1] * outputs[1];
	outputs[2] = outputs[1];
	outputs[1] = outputs[0];


	*ioData++=outputs[0];
	}
}
// ************************************************************************************************
-(float) filter:(float)sample
{
inputs[0] = gain * sample;
outputs[0] = b[0] * inputs[0] - a[2] * outputs[2] - a[1] * outputs[1];
outputs[2] = outputs[1];
outputs[1] = outputs[0];

return outputs[0];
}
// ************************************************************************************************


@end
