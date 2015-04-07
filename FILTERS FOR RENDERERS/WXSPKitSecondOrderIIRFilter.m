// ******************************************************************************************
//  WXSPKitSecondOrderIIRFilter.h
//  Created by Paul Webb on Mon Jan 10 2005.
// ******************************************************************************************
#import "WXSPKitSecondOrderIIRFilter.h"

@implementation WXSPKitSecondOrderIIRFilter


// ******************************************************************************************
-(void)	filterChunk:(float*)ioData frame:(UInt32)inNumFrames
{
UInt32 i;
float inputSample,outputSample;

for (i=0; i<inNumFrames; ++i) 
	{
	if(paramControls!=nil)   [paramControls doUpdate];
	
	inputSample=*ioData;
	outputSample = a0 * inputSample + a1 * x[0] + a2 * x[1]
    		   - b1 * y[0] - b2 * y[1];

	x[1] = x[0];
	x[0] = inputSample;
	y[1] = y[0];
	y[0] = outputSample;	
	
	*ioData++=outputSample;
	
	}
}
// ******************************************************************************************
-(float) filter:(float)inputSample
{
float outputSample;

outputSample = a0 * inputSample + a1 * x[0] + a2 * x[1]
    		   - b1 * y[0] - b2 * y[1];

x[1] = x[0];
x[0] = inputSample;
y[1] = y[0];
y[0] = outputSample;

return outputSample;
}
// ******************************************************************************************
-(void)		clear
{
x[0]=x[1]=0;
y[0]=y[1]=0;
}
// ******************************************************************************************
@end