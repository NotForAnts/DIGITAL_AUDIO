// ******************************************************************************************
//  WXSPKitResonator
//  Created by Paul Webb on Mon Jan 10 2005.
// ******************************************************************************************
#import "WXSPKitResonator.h"

// ******************************************************************************************

@implementation WXSPKitResonator

// ******************************************************************************************
-(id)		init
{
if(self=[super init])
	{
	[self setCenterFreqAndBW:4000 width:1000];
	}
return self;
}
// ***************************************************************************************
-(void)		doController:(int)index value:(float)value
{
switch(index)
	{
	case 1:		[self setCenterFreq:value];		break;
	case 2:		[self setBandWidth:value];		break;
	}
}
// ******************************************************************************************
-(void) setBandWidth:(float)bw 
{
[self setCenterFreqAndBW:centerFreq width:bw];
}
// ******************************************************************************************
-(void) setCenterFreq:(float)f 
{
[self setCenterFreqAndBW:f width:bandwidth];
}
// ******************************************************************************************
-(void) setCenterFreqAndBW:(float)f width:(float)bw
{
centerFreq = f;
bandwidth = bw;

b2 = exp(-(2 * M_PI) * (bandwidth / 44100.0));
b1 = (-4.0 * b2) / (1.0 + b2)
 * cos(2 * M_PI * (centerFreq / 44100.0));
a0 = (1.0 - b2) * sqrt(1.0 - (b1 * b1) / (4.0 * b2));
}
// ******************************************************************************************
-(float)	filter:(float)inputSample
{
float outputSample;
outputSample = a0 * inputSample - b1 * y1 - b2 * y2;

y2 = y1;
y1 = outputSample;
return outputSample;
}
// ******************************************************************************************
-(void)		clear
{
}
// ******************************************************************************************


@end
