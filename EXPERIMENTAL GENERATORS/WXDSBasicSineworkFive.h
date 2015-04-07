// ************************************************************************************************
//  WXDSBasicSineworkFive
//  Created by Paul Webb on Thu Jul 28 2005.
// ************************************************************************************************
//  
//  rhythmic pulses created through pan movements
//  technique does not work as expected
//  result is a rapid panning pulse generation with wider harmmonic shifting spectrum
// ************************************************************************************************

#import <Foundation/Foundation.h>
#import "WXDSRenderBase.h"


// ************************************************************************************************

@interface WXDSBasicSineworkFive : WXDSRenderBase {

double  degree2;
double  freq,delta1Orig,delta2,delta3,delta2Orig,delta4;
double   pan1,pan2,pdelta1;
double   pan3,pan4,pdelta2,currentPanDelta;

int		panTime1,panTime2,panCounter,totalPanTime,silentCount;
int		panChangeTime,pan2EndTime;

BOOL	inSilence;
}



-(id)			initWithFreq:(double)r;
-(void)			setParameters;

@end
