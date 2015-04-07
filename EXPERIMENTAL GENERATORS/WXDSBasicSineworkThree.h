// ************************************************************************************************
//  WXDSBasicSineworkThree
//  Created by Paul Webb on Tue Jul 26 2005.
// ************************************************************************************************
//  gestured variation with noise
//  quantising and band pass filtering
//
//
// ************************************************************************************************

#import <Foundation/Foundation.h>
#import "WXDSRenderBase.h"
#import "WXSPKitBWBandPassFilter.h"
// ************************************************************************************************

@interface WXDSBasicSineworkThree : WXDSRenderBase {


float   noiseValue;

float   origPan,panShift;
int		resetCounter,resetEvery;
int		noiseLevelQuantise,delay;
float   noiseLevelQuantiseHalf;
int		updateCounter;
float   noiseUpdateCount,noiseUpdateDelta,origNoiseUpdateCount;
float   centreFreq,centreDelta,centreFreqOrig;

WXSPKitBWBandPassFilter *bandPass;

//		basic tap
int		tapcount,theTapDelay,maxTapSize;
float   tap[44100],tapStrength;
}





// ************************************************************************************************

@end
