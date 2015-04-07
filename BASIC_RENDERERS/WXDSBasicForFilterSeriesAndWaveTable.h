// ***************************************************************************************
//  WXDSBasicForFilterSeriesAndWaveTable.h
//  Created by Paul Webb on Wed Apr 13 2005.
// ***************************************************************************************
// This is the basic series.
//
// this are some 
//		waveTable->WXDSFilterSeries->out
//  or can override the audioCallbackOnDevice for non wave form one
//
// the generator control are controlled via this class.
// the filter params via the filters that when into the WXDSFilterSeries

#import <Foundation/Foundation.h>
#import "WXDSRenderBase.h"
#import "WXDSFilterSeries.h"
#import "WXDSEnvelopeTableMaker.h"
// ***************************************************************************************
@interface WXDSBasicForFilterSeriesAndWaveTable : WXDSRenderBase {

float					*theWave;
WXDSFilterSeries		*filterSeries;
WXDSEnvelopeTableMaker  *waveMaker;


double					waveIndex,waveIncrement,waveLength,waveLengthEndIndex;					
}



-(void)		setFilterSeries:(WXDSFilterSeries*)fs;
-(WXDSFilterSeries*)	filterSeries;



// ***************************************************************************************


@end
