// ***************************************************************************************
//  WXDSInstrumentCustomExampleOne
//  Created by Paul Webb on Sat Aug 13 2005.
// ***************************************************************************************


#import <Foundation/Foundation.h>

#import "WXDSInstrumentObjectBasic.h"
#import "WXDSFilterSeries.h"
#import "WXDSEnvelopeTableMaker.h"

#import "WXSPKitBWBandPassFilter.h"
#import "WXFilterJohnChowningReverb.h"
#import "WXCombFilterFeedBack.h"
// ***************************************************************************************

@interface WXDSInstrumentCustomExampleOne : WXDSInstrumentObjectBasic {

float					*theWave;
WXDSFilterSeries		*filterSeries;
WXDSEnvelopeTableMaker  *waveMaker;

double					waveIndex,waveIncrement,waveLength,waveLengthEndIndex;		

int						stage;
WXSPKitBWBandPassFilter					*bandPass;
WXFilterJohnChowningReverb				*reverb;		
WXCombFilterFeedBack					*comb1;

WXDSInstrumentEnvelopeBase  *width;
}



-(void)		setFilterSeries:(WXDSFilterSeries*)fs;
-(WXDSFilterSeries*)	filterSeries;
-(void)		setFrequency:(float)freq;


// ***************************************************************************************
@end
