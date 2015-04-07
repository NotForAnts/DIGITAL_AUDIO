// ******************************************************************************************
//  WXDSWavemixSynthesis
//  Created by Paul Webb on Thu Jul 21 2005.
// ******************************************************************************************
// this allow for the dynamic inclusion of mixer in objects that are brought in for
// an ammount of time and have volume and pan envelopes
//
// it does this by using an array of WXDSWavemixSynthesisObjects which each have a
// render object (normal types) and former object does the time and envelope checks
// and flags itself that it should be removed when its time is up.
//
// ******************************************************************************************
#import <Foundation/Foundation.h>
#import "WXDSRenderBase.h"
#import "WXDSWavemixSynthesisObject.h"
#import "WXDSEnvelopeTableMaker.h"
#import "WXDSFilterSeries.h"

// test envelopes
#import "WXDSEnvelopeBasic.h"
#import "WXDSEnvelopeSegmentLinear.h"
#import "WXDSEnvelopeSeries.h"
#import "WXDSEnvelopeSegmentSine.h"
#import "WXDSEnvelopeSegmentExponential.h"
#import "WXDSEnvelopeSegmentSine.h"

// ******************************************************************************************
// some test wave forms
#import "WXDSBasicWhiteNoiseWave.h"
#import "WXDSBasicBrownNoiseWave.h"
#import "WXDSBasicSinework.h"
#import "WXDSBasicSineworkTwo.h"
#import "WXDSBasicSineworkThree.h"
#import "WXDSBasicSineworkFour.h"
#import "WXDSBasicSineworkFive.h"
#import "WXDSBasicSineworkSix.h"
// ******************************************************************************************
@interface WXDSWavemixSynthesis : WXDSRenderBase {


int		timerFrameCounter,waveSize;
NSMutableArray		*theWaves;
WXDSEnvelopeTableMaker		*waveMaker;
float						*envelope;
WXDSFilterSeries			*filterSeriesRight,*filterSeriesLeft;

float		*bufferLeft;
float		*bufferRight;
}

-(void)			removeAllWaves;
-(void)			setFilterSeriesRight:(WXDSFilterSeries*)fs;
-(void)			setFilterSeriesLeft:(WXDSFilterSeries*)fs;
-(void)			addSomeWavesOverride;
-(void)			removeOldObjects;

// ******************************************************************************************

@end
