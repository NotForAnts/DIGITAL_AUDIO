// ************************************************************************************************
//  WXDSBasicSineworkFour
//  Created by Paul Webb on Tue Jul 26 2005.
// ************************************************************************************************

#import <Foundation/Foundation.h>
#import "WXDSRenderBase.h"


// ************************************************************************************************

@interface WXDSBasicSineworkFour : WXDSRenderBase {

int		 sustainLevel;
double   pulseCount,pulseRate;
double   pulseLevel,pulseDelta1,pulseDelta2,pulsePeriod,pulseRateDelta1,pulseRateDelta2;

double   pulseRateOrig,pulseRateDelta1Orig,pulseDelta1Orig,freq;

float    pan1,pan2,panDelta;


int		resetEveryCount,resetEvery;
int		paramSetEvery,paramSetCount;
}


-(void)		setParameters;
-(void)		mutateParameters;

@end
