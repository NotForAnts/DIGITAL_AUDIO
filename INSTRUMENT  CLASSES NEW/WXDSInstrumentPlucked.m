// ************************************************************************************************
//  WXDSInstrumentPlucked
//  Created by Paul Webb on Sun Aug 14 2005.
// ************************************************************************************************

#import "WXDSInstrumentPlucked.h"


@implementation WXDSInstrumentPlucked

// ************************************************************************************************
-(id)   initPlucked:(float)lowestFrequency
{
if(self=[super init])
	{
	length = (long) (44100.0 / lowestFrequency + 1);
	loopGain = (float) 0.999;
	delayLine = [[WXFilterDelayA alloc]initDelay:(length / 2.0) md:length];
	loopFilter = [[WXFilterOneZero alloc]init];
	pickFilter = [[WXFilterOnePole alloc]init];
	[self clear];
	}
return self;
}
// ************************************************************************************************
-(void) dealloc
{
[delayLine release];
[loopFilter release];
[pickFilter release];
[super dealloc];
}
// ************************************************************************************************
-(void) clear
{
[delayLine clear];
[loopFilter clear];
[pickFilter clear];
}
// ************************************************************************************************
-(void) setFrequency:(float)frequency
{
float freakency = frequency;


// Delay = length - approximate filter delay.
float delay = (44100.0 / freakency) - (float) 0.5;
if (delay <= 0.0) delay = 0.3;
else if (delay > length) delay = length;
[delayLine setDelay:delay];
loopGain = 0.995 + (freakency * 0.000005);
if ( loopGain >= 1.0 ) loopGain = (float) 0.99999;
}
// ************************************************************************************************

-(void) pluck:(float) amplitude
{
long i;
float gain = amplitude;
if ( gain > 1.0 ) {
gain = 1.0;
}
else if ( gain < 0.0 ) {
gain = 0.0;
}
	
[pickFilter setPole:(float) 0.999 - (gain * (float) 0.15)];
[pickFilter setGain:gain * (float) 0.5];
// Fill delay with noise additively with current contents.

for (i=0; i<length; i++)
	[delayLine filter:0.6 * [delayLine lastOut] + [pickFilter filter: WXUFloatRandomBetween(-1.0,1.0) ] ];
	

}
// ************************************************************************************************

-(void) keyONWithFreqGain:(float)freq gain:(float)gain
{
[self setFrequency:freq];
[self pluck:gain];
}
// ************************************************************************************************

-(void) keyOFF
{
float amplitude=0.2;
  loopGain = (float) 1.0 - amplitude;
  if ( loopGain < 0.0 ) {
    loopGain = 0.0;
  }
  else if ( loopGain > 1.0 ) {
    loopGain = (float) 0.99999;
  }

}
// ************************************************************************************************
-(OSStatus)		audioCallbackOnDevice:(AudioBufferList*)ioData bus:(UInt32)bus frame:(UInt32)inNumFrames time:(AudioTimeStamp*)timeStamp
{

if(!isActive) return [self RenderBlank:ioData bus:bus frame:inNumFrames];
UInt32 i;
float* out1 =(float*) ioData->mBuffers[0].mData;
float   v=0;
  // Here's the whole inner loop of the instrument!!
  
 for (i=0; i<inNumFrames; ++i) 
	{
	v=[delayLine lastOut] * loopGain;
	v=[loopFilter filter:v];
	lastOutput = [delayLine filter:v]; 
	lastOutput *= (float) 3.0;
	*out1++ = lastOutput;
	}


[self doMonoToStereoPan:ioData frame:inNumFrames];
return noErr;
}

// ************************************************************************************************

@end
