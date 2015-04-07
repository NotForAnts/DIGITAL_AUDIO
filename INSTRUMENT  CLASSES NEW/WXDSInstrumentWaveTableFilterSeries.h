// ***************************************************************************************
//  WXDSInstrumentWaveTableFilterSeries
//  Created by Paul Webb on Sat Aug 13 2005.
// ***************************************************************************************

#import <Foundation/Foundation.h>
#import "WXDSInstrumentObjectBasic.h"
#import "WXDSFilterSeries.h"
#import "WXDSEnvelopeTableMaker.h"

// test
#import "WXSPKitBWBandPassFilter.h"
#import "WXFilterJohnChowningReverb.h"
// ***************************************************************************************
@interface WXDSInstrumentWaveTableFilterSeries : WXDSInstrumentObjectBasic {

float					*theWave;
WXDSFilterSeries		*filterSeries;
WXDSEnvelopeTableMaker  *waveMaker;

double					waveIndex,waveIncrement,waveLength,waveLengthEndIndex;		

// for testing
WXSPKitBWBandPassFilter					*bandPass;
WXFilterJohnChowningReverb				*reverb;			
}



-(void)		setFilterSeries:(WXDSFilterSeries*)fs;
-(WXDSFilterSeries*)	filterSeries;
-(void)		setFrequency:(float)freq;


// ***************************************************************************************


@end
