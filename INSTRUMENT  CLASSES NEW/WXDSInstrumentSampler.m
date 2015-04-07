// ***************************************************************************************
//  WXDSInstrumentSampler
//  Created by Paul Webb on Mon Aug 15 2005.
// ***************************************************************************************

#import "WXDSInstrumentSampler.h"


@implementation WXDSInstrumentSampler
// ***************************************************************************************
-(id)   init
{
if(self=[super init])
	{
	// We don't make the waves here yet, because
	// we don't know what they will be.
	adsr =[[WXDSInstrumentEnvelopeBase alloc]init];
	baseFrequency = 440.0;
	filter =[[WXFilterOnePole alloc]init];
	attackGain = 0.25;
	loopGain = 0.25;
	whichOne = 0;
	}
return self;
}  
// ***************************************************************************************
-(void) dealloc
{
[adsr release];
[filter release];
[super release];
}
// ***************************************************************************************
-(void) keyONWithFreqGain:(float)freq gain:(float)gain
{
[adsr keyOnWithGain:1.0];
[attacks[0] gotoStartOfWave];
}
// ***************************************************************************************
-(void) keyOFF
{
[adsr keyOff];
}
// ************************************************************************************************
-(OSStatus)		audioCallbackOnDevice:(AudioBufferList*)ioData bus:(UInt32)bus frame:(UInt32)inNumFrames time:(AudioTimeStamp*)timeStamp
{

if(!isActive) return [self RenderBlank:ioData bus:bus frame:inNumFrames];
UInt32 i;
float* out1 =(float*) ioData->mBuffers[0].mData;


	
for (i=0; i<inNumFrames; ++i) 
	{
	lastOutput = attackGain * [attacks[whichOne] tick];
	lastOutput += loopGain * [loops[whichOne] tick];
	lastOutput = [filter filter:lastOutput];
	lastOutput *= [adsr tick];
	*out1++ = lastOutput;
	}


[self doMonoToStereoPan:ioData frame:inNumFrames];

return noErr;
}
// ***************************************************************************************

@end
