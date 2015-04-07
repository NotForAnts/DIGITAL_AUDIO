// ***************************************************************************************
//  WXDSInstrumentElectroBassTwo
//  Created by Paul Webb on Sun Aug 14 2005.
// ***************************************************************************************

#import <Foundation/Foundation.h>
#import "WXDSInstrumentObjectBasic.h"
#import "WXDSFilterSeries.h"
#import "WXDSEnvelopeTableMaker.h"

#import "WXSPKitBWBandPassFilter.h"
#import "WXFilterPRCReverb.h"
// ***************************************************************************************

@interface WXDSInstrumentElectroBassTwo : WXDSInstrumentObjectBasic {

float					*theWave;
WXDSFilterSeries		*filterSeries;
WXDSEnvelopeTableMaker  *waveMaker;

double		waveIndex,waveIncrement,waveLength,waveLengthEndIndex;

WXSPKitBWBandPassFilter					*bandPass;
WXFilterPRCReverb						*reverb;


float		centre1,centre2;
float		width1,width2;
float		feedback1,feedback2;
float		delay1,delay2;
float		pan1,pan2;
int			panTick;
}


-(id)   initWithType:(short)type;
-(void)		setCentreVariation:(float)v1 v2:(float)v2;
-(void)		setWidthVariation:(float)v1 v2:(float)v2;	
// ***************************************************************************************

@end
