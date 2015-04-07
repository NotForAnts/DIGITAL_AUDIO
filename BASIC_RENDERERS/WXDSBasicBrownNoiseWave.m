// ***************************************************************************************
//  WXDSBasicBrownNoiseWave
//  Created by Paul Webb on Wed Apr 13 2005.
// ***************************************************************************************

#import "WXDSBasicBrownNoiseWave.h"


@implementation WXDSBasicBrownNoiseWave
// ************************************************************************************************
-(id)		init
{
if(self=[super init])
	{
	[self setMasterPan:0.5];
	filterSeries=nil;
	brown=1.0;
	brownDelta=0.5;
	}
return self;
}
// ************************************************************************************************
-(OSStatus)		audioCallbackOnDevice:(AudioBufferList*)ioData bus:(UInt32)bus frame:(UInt32)inNumFrames time:(AudioTimeStamp*)timeStamp
{

if(!isActive) return [self RenderBlank:ioData bus:bus frame:inNumFrames];
UInt32 i;
float* out1 =(float*) ioData->mBuffers[0].mData;
float* out2 =(float*) ioData->mBuffers[1].mData;
out1=out1+preBlankSize*2;
out2=out2+preBlankSize*2;

for (i=0; i<inNumFrames; ++i) 
	{
	if(updateCollection!=nil)   [updateCollection doUpdate];
	brown=brown-(brownDelta+(random()%60000/30000.0)*brownDelta);
	if(brown<0.0)  brown=-brown;
	if(brown>2.0)  brown=2.0+(brown-2.0);
	
	theSample=(brown-1.0)*masterGain;



	if(filterSeries!=nil) theSample=[filterSeries filter:theSample];
	
	*out1++ = theSample*panRight;
	*out2++ = theSample*panLeft;
	
	degree1+=delta1;
	}
	
return noErr;
}
// ************************************************************************************************
@end
