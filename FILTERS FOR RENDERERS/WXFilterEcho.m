// ************************************************************************************************
//  WXFilterEcho
//  Created by Paul Webb on Wed Dec 29 2004.
// ************************************************************************************************

#import "WXFilterEcho.h"


@implementation WXFilterEcho

// ************************************************************************************************
-(id)   initEcho:(float)longestDelay
{
if(self=[super init])
	{
	length = (long) longestDelay + 2;
	delayLine = [[WXFilterDelay alloc]initDelay:length>>1 md:length];
	effectMix = 0.5;
	[self clear];
	}
return self;
}
// ******************************************************************************************
-(void)		dealloc
{
[delayLine release];
[super dealloc];
}
// ************************************************************************************************
-(void) clear
{
[delayLine clear];
lastOutput = 0.0;
}
// ************************************************************************************************
-(void) setDelayAndMix:(float)delay mix:(float)mix
{
[self setDelay:delay];
[self setEffectMix:mix];
}
// ************************************************************************************************
-(void) setDelayNSO:(id)delay			{   [self setDelay:[delay floatValue]];			}
-(void) setEffectMixNSO:(id)mix		{   [self setEffectMix:[mix floatValue]];		}
// ************************************************************************************************
-(void) setDelay:(long)delay
{
float size = delay;
if ( delay < 0.0 ) {
    size = 0.0;
  }
else if ( delay > length ) {
    size = length;
  }

[delayLine setDelay:(long)size];
}
// ************************************************************************************************
-(void) setEffectMix:(float)mix
{
effectMix = mix;
if ( mix < 0.0 ) {
	effectMix = 0.0;
  }
else if ( mix > 1.0 ) {
    effectMix = 1.0;
  }
  
}
// ************************************************************************************************
-(float) lastOut
{
return lastOutput;
}
// ************************************************************************************************
-(void)		filterChunk:(float*)ioData frame:(UInt32)inNumFrames
{
UInt32 i;
float inputSample;

for (i=0; i<inNumFrames; ++i) 
	{
	inputSample=*ioData;
	lastOutput = effectMix * [delayLine filter:inputSample];
	lastOutput += inputSample * (1.0 - effectMix);
	*ioData++=lastOutput;
	}
}
// ************************************************************************************************
-(float) filter:(float)input
{
lastOutput = effectMix * [delayLine filter:input];
lastOutput += input * (1.0 - effectMix);
return lastOutput;
}
// ************************************************************************************************


@end
