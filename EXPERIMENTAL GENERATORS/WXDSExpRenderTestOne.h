// ***************************************************************************************
//  WXDSExpRenderTestOne
//  Created by Paul Webb on Mon Jul 25 2005.
// ***************************************************************************************
//  simple test in which a single calculator is mapped into several parameters
//  so all is based on a single controller.
//
//
//
// ***************************************************************************************

#import <Foundation/Foundation.h>
#import "WXDSRenderBase.h"

// ***************************************************************************************
// some test mappers

//#import "WXDSMapperBasic.h"
//#import "WXDSMapperExp.h"
//#import "WXDSMapperLinear.h"
//#import "WXDSMapperLog.h"
//#import "WXDSMapperSine.h"

// ***************************************************************************************
// some test filters

#import "WXCombFilterFeedBack.h"
#import "WXSPKitBWBandPassFilter.h"
#import "WXSPKitResonator.h"
#import "WXFilterJohnChowningReverb.h"
// ***************************************************************************************
// calculator

#import "WXCalculatorUnstable2.h"
#import "WXCalculatorVariedTriangleWave.h"

@interface WXDSExpRenderTestOne : WXDSRenderBase {

float   noiseLevel;
WXCalculatorUnstable2*		calc1;

WXCombFilterFeedBack		*comb;
WXSPKitBWBandPassFilter		*bandPass;
WXSPKitResonator			*resonator;
WXFilterJohnChowningReverb  *reverb;

WXDSMapperSine				*sineMap1;
WXDSMapperSine				*sineMap2;
WXDSMapperSine				*sineMap3;
WXDSMapperSine				*sineMap4;
WXDSMapperSine				*sineMap5;

int							counter,updateCounter;
}


-(id)		initWithFreq:(double)r;

@end
