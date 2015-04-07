// ***************************************************************************************
//  WXDSBasicRampWave
//  Created by Paul Webb on Wed Apr 13 2005.
// ***************************************************************************************

#import "WXDSBasicRampWave.h"


@implementation WXDSBasicRampWave
// ************************************************************************************************
-(id)		initWithFreq:(double)r
{
if(self=[super init])
	{
	[self setMasterPan:0.5];
	filterSeries=nil;
	waveIndex=0;
	waveIncrement=r;
	theWave=[waveMaker makeStraightEnvelope:44100 r1:-1.0 r2:1.0];
	}
return self;
}

// ************************************************************************************************
@end
