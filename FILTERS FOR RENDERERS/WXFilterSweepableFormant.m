// ******************************************************************************************
//  WXFilterSweepableFormant
//  Created by Paul Webb on Thu Dec 30 2004.
// ******************************************************************************************
#import "WXFilterSweepableFormant.h"


@implementation WXFilterSweepableFormant

// ******************************************************************************************
-(id)   init
{
if(self=[super init])
	{
	frequency = (float) 0.0;
	radius = (float) 0.0;
	targetGain = (float) 1.0;
	targetFrequency = (float) 0.0;
	targetRadius = (float) 0.0;
	deltaGain = (float) 0.0;
	deltaFrequency = (float) 0.0;
	deltaRadius = (float) 0.0;
	sweepState = (float)  0.0;
	sweepRate = (float) 0.002;
	dirty = NO;
	[self clear];
	}
return self;
}
// ******************************************************************************************
-(void) setResonance:(float)aFrequency aRadius:(float)aRadius
{
dirty = NO;
radius = aRadius;
frequency = aFrequency;
[super setResonance:frequency radius:radius normalise:YES];
}
// ******************************************************************************************
-(void) setStates:(float)aFrequency  aRadius:(float)aRadius aGain:(float)aGain
{
dirty = NO;

if ( frequency != aFrequency || radius != aRadius )
	[super setResonance:aFrequency radius:aRadius normalise:YES];

frequency = aFrequency;
radius = aRadius;
gain = aGain;
targetFrequency = aFrequency;
targetRadius = aRadius;
targetGain = aGain;
}
// ******************************************************************************************
-(void) setTargets:(float)aFrequency aRadius:(float)aRadius aGain:(float)aGain
{
dirty = YES;
startFrequency = frequency;
startRadius = radius;
startGain = gain;
targetFrequency = aFrequency;
targetRadius = aRadius;
targetGain = aGain;
deltaFrequency = aFrequency - frequency;
deltaRadius = aRadius - radius;
deltaGain = aGain - gain;
sweepState = (float) 0.0;
}
// ******************************************************************************************
-(void) setSweepRate:(float)aRate
{
sweepRate = aRate;
if ( sweepRate > 1.0 ) sweepRate = 1.0;
if ( sweepRate < 0.0 ) sweepRate = 0.0;
}
// ******************************************************************************************
-(void) setSweepTime:(float)aTime
{
sweepRate = 1.0 / ( aTime * 44100.0 );
if ( sweepRate > 1.0 ) sweepRate = 1.0;
if ( sweepRate < 0.0 ) sweepRate = 0.0;
}
// ************************************************************************************************
-(void)		filterChunk:(float*)ioData frame:(UInt32)inNumFrames
{
UInt32 i;
float inputSample;

for (i=0; i<inNumFrames; ++i) 
	{
	inputSample=*ioData;
	if (dirty)  {
		sweepState += sweepRate;
		if ( sweepState >= 1.0 )   {
			sweepState = (float) 1.0;
			dirty = NO;
			radius = targetRadius;
			frequency = targetFrequency;
			gain = targetGain;
		}
		else  {
			radius = startRadius + (deltaRadius * sweepState);
			frequency = startFrequency + (deltaFrequency * sweepState);
			gain = startGain + (deltaGain * sweepState);
		}
		[super setResonance:frequency radius:radius normalise:YES];
	}

	*ioData++=[super filter:inputSample];
	}
}
// ******************************************************************************************
-(float) filter:(float)sample
{
if (dirty)  {
	sweepState += sweepRate;
	if ( sweepState >= 1.0 )   {
		sweepState = (float) 1.0;
		dirty = NO;
		radius = targetRadius;
		frequency = targetFrequency;
		gain = targetGain;
	}
	else  {
		radius = startRadius + (deltaRadius * sweepState);
		frequency = startFrequency + (deltaFrequency * sweepState);
		gain = startGain + (deltaGain * sweepState);
	}
	[super setResonance:frequency radius:radius normalise:YES];
}

return [super filter:sample];
}
// ******************************************************************************************


@end
