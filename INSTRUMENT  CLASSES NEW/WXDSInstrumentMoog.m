// ***************************************************************************************
//  WXDSInstrumentMoog
//  Created by Paul Webb on Mon Aug 15 2005.
// ***************************************************************************************
#import "WXDSInstrumentMoog.h"


@implementation WXDSInstrumentMoog

// ***************************************************************************************
-(id) init
{
if(self=[super init])
	{
	attacks[0]=[[WXDSWaveTable alloc]init];
	loops[0]=[[WXDSWaveTable alloc]init];
	loops[1]=[[WXDSWaveTable alloc]init];
	
	[attacks[0] loadWaveOfName: "rawwaves/mandpluk.raw"];
	[loops[0] loadWaveOfName: "rawwaves/impuls20.raw"];
	[loops[1] loadWaveOfName: "rawwaves/sinewave.raw"];
	[loops[1] setFrequency:(float) 6.122 / 512.0];

	filters[0]=[[WXFilterSweepableFormant alloc]init];
	[filters[0] setTargets:0.0 aRadius:0.7 aGain:1.0];

	filters[1]=[[WXFilterSweepableFormant alloc]init];
	[filters[1] setTargets:0.0 aRadius:0.7 aGain:1.0];

	//adsr->setAllTimes((float) 0.001,(float) 1.5,(float) 0.6,(float) 0.250);
	[adsr setAttack:1.0 time:0.001];
	[adsr setDecay:0.6 time:1.5];
	[adsr setRelease:0.0 time:0.250];	
	
	filterQ = (float) 0.85;
	filterRate = (float) 0.0001;
	modDepth = (float) 0.0;
	
	whichOne = 0;
	}
return self;
}  
// ***************************************************************************************
-(void) dealloc
{
[attacks[0] release];
[loops[0] release];
[loops[1] release];
[filters[0] release];
[filters[1] release];
  
[super dealloc]; 
}
// ***************************************************************************************
-(void) setFrequency:(float)frequency
{
  baseFrequency = frequency;
  if ( frequency <= 0.0 ) {
    baseFrequency = 220.0;
  }

float rate = [attacks[whichOne] getSize] * 0.01 * baseFrequency / 44100.0;
[attacks[whichOne] setFrequency:rate/512.0];
[loops[0] setFrequency:baseFrequency/512.0];
}
// ***************************************************************************************
-(void) keyOFF
{
[adsr keyOff];
}
// ***************************************************************************************
-(void) keyONWithFreqGain:(float)freq gain:(float)gain
{
  float temp;
    
[self setFrequency:freq];
[super keyONWithFreqGain:freq gain:gain];
attackGain = gain * (float) 0.5;
loopGain = gain;

temp = filterQ + (float) 0.05;
[filters[0] setStates:2000.0 aRadius:temp aGain:1.0];
[filters[1] setStates:2000.0 aRadius:temp aGain:1.0];

temp = filterQ + (float) 0.099;
[filters[0] setTargets:freq aRadius:temp aGain:1.0];
[filters[1] setTargets:freq aRadius:temp  aGain:1.0];

[filters[0] setSweepRate:filterRate * 22050.0 / 44100.0];
[filters[1] setSweepRate:filterRate * 22050.0 / 44100.0];

}
// ***************************************************************************************
-(void) setModulationSpeed:(float)mSpeed
{
[loops[1] setFrequency:mSpeed];
}
// ***************************************************************************************
-(void) setModulationDepth:(float)mDepth
{
modDepth = mDepth * (float) 0.5;
}
// ************************************************************************************************
-(OSStatus)		audioCallbackOnDevice:(AudioBufferList*)ioData bus:(UInt32)bus frame:(UInt32)inNumFrames time:(AudioTimeStamp*)timeStamp
{
if(!isActive) return [self RenderBlank:ioData bus:bus frame:inNumFrames];
UInt32 i;
float* out1 =(float*) ioData->mBuffers[0].mData;
float temp;
   
	
for (i=0; i<inNumFrames; ++i) 
	{
	if ( modDepth != 0.0 ) 
		{
		temp = [loops[1] tick] * modDepth;    
		[loops[0] setFrequency: baseFrequency * (1.0 + temp) / 512.0 ];
		}

	//temp = Sampler::tick();
	temp = attackGain * [attacks[whichOne] tick];
	temp += loopGain * [loops[whichOne] tick];
	temp = [filter filter:temp];
	temp *= [adsr tick];
	
	
	temp = [filters[0] filter:temp];
	lastOutput = [filters[1] filter:temp];
  
	*out1++ = lastOutput*3.0;
	}


[self doMonoToStereoPan:ioData frame:inNumFrames];

return noErr;
}
// ************************************************************************************************

@end
