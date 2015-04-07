// ***************************************************************************************
//  WXDSInstrumentBellOne
//  Created by Paul Webb on Sun Aug 14 2005.
// ***************************************************************************************

#import <Foundation/Foundation.h>
#import "WXDSInstrumentObjectBasic.h"
#import "WXDSFilterSeries.h"
#import "WXDSEnvelopeTableMaker.h"

#import "WXSPKitResonator.h"
#import "WXFilterJohnChowningReverb.h"
#import "WXSPKitBWBandPassFilter.h"
// ***************************************************************************************

@interface WXDSInstrumentBellOne : WXDSInstrumentObjectBasic {

float					*theWave;
WXDSFilterSeries		*filterSeries;
WXDSEnvelopeTableMaker  *waveMaker;

double		waveIndex,waveIncrement,waveLength,waveLengthEndIndex;	
float		noise;

WXSPKitResonator			*resonator;
WXFilterJohnChowningReverb  *reverb;

float		centre1,centre2;
float		width1,width2;
}

@end
