// ************************************************************************************************
//  WXPitchShift
//  Created by Paul Webb on Thu Dec 30 2004.
// ************************************************************************************************
#import "WXPitchShift.h"


@implementation WXPitchShift

// ************************************************************************************************
-(id)   init
{
if(self=[super init])
	{
	delay1=12;
	delay2=512;

	delayline1=[[WXFilterBasicDelayTap alloc]initFilter:1024 delay:(UInt32)delay1 fb:1.0];
	delayline2=[[WXFilterBasicDelayTap alloc]initFilter:1024 delay:(UInt32)delay2 fb:1.0];

	rate = -2.0;
	lastOutput = 0.0;
	mixLevel=0.5;
	mixLevel=1.0;
	[self setShift:0.1];
	}
return self;
}
// ******************************************************************************************
-(void)		dealloc
{
[delayline1 release];
[delayline2 release];
[super dealloc];
}
// ******************************************************************************************
-(void)		clear
{
[delayline1 clear];
[delayline2 clear];
}
// ***************************************************************************************
-(void)		doController:(int)index value:(float)value
{
switch(index)
	{
	case 1:		[self setMix:value];					break;
	case 2:		[self setShift:value];					break;
	}
}
// ************************************************************************************************
-(void)	setMix:(float)v
{
mixLevel=v;
}
// ************************************************************************************************
-(void) setShift:(float)shift
{
if (shift < 1.0)    
	{
	rate = 1.0 - shift; 
	}
else if (shift > 1.0)       
	{
    rate = 1.0 - shift;
	}
else 
	{
    rate = 0.0;
    delay1 = 512;
	}
}
// ************************************************************************************************
-(void)		filterChunk:(float*)ioData frame:(UInt32)inNumFrames
{
UInt32 i;
float inputSample;

for (i=0; i<inNumFrames; ++i) 
	{
	inputSample=*ioData;
	delay1 = delay1 + rate;
	while (delay1 > 1012) delay1 -= 1000;
	while (delay1 < 12) delay1 += 1000;
	delay2 = delay1 + 500;
	  
	while (delay2 > 1012) delay2 -= 1000;
	while (delay2 < 12) delay2 += 1000;

	[delayline1 setDelay:(long)delay1];
	[delayline2 setDelay:(long)delay2];

	env2 = fabs(delay1 - 512) * 0.002;
	env1 = 1.0 - env2;
	lastOutput =  env1 * [delayline1 filter:inputSample];
	lastOutput += env2 * [delayline2 filter:inputSample];
	lastOutput *= mixLevel;
	lastOutput += (1.0 - mixLevel) * inputSample;
	*ioData++=lastOutput;
	}
}
// ************************************************************************************************
-(float) filter:(float)input
{
delay1 = delay1 + rate;
while (delay1 > 1012) delay1 -= 1000;
while (delay1 < 12) delay1 += 1000;
delay2 = delay1 + 500;
  
while (delay2 > 1012) delay2 -= 1000;
while (delay2 < 12) delay2 += 1000;

[delayline1 setDelay:(long)delay1];
[delayline2 setDelay:(long)delay2];

env2 = fabs(delay1 - 512) * 0.002;
env1 = 1.0 - env2;
lastOutput =  env1 * [delayline1 filter:input];
lastOutput += env2 * [delayline2 filter:input];
lastOutput *= mixLevel;
lastOutput += (1.0 - mixLevel) * input;

return lastOutput;
}
// ************************************************************************************************


@end
