// ***************************************************************************************
//  WXDSInstrumentElectroBassOne
//  Created by Paul Webb on Sat Aug 13 2005.
// ***************************************************************************************
// electronic bass need some input which is a bit of a pulse
// at low frequency going through some band pass filter (variate in time)
// and reverb is always nice to add.
// and perhaps some other filters like a comb (variate) and chorus
//
// the envelope is important
// fast attack / decay / release the attack->decay should be a major shift to create the
// initial impulse which goes through the filter series.
//
// ***************************************************************************************


#import <Foundation/Foundation.h>
#import "WXDSInstrumentObjectBasic.h"
#import "WXDSFilterSeries.h"
#import "WXDSEnvelopeTableMaker.h"

#import "WXSPKitBWBandPassFilter.h"
#import "WXFilterJohnChowningReverb.h"
#import "WXCombFilterFeedBack.h"

// ***************************************************************************************

@interface WXDSInstrumentElectroBassOne : WXDSInstrumentObjectBasic {

float					*theWave;
WXDSFilterSeries		*filterSeries;
WXDSEnvelopeTableMaker  *waveMaker;

double		waveIndex,waveIncrement,waveLength,waveLengthEndIndex;		
	
float		centre1,centre2;
float		width1,width2;
float		feedback1,feedback2;
float		delay1,delay2;
float		pan1,pan2;
int			panTick;

WXSPKitBWBandPassFilter					*bandPass;
WXFilterJohnChowningReverb				*reverb;		
WXCombFilterFeedBack					*comb1;
}

-(id)		initWithType:(short)type;
-(void)		setFrequency:(float)freq;
-(void)		setCentreVariation:(float)v1 v2:(float)v2;
-(void)		setWidthVariation:(float)v1 v2:(float)v2;
-(void)		setFeedVariation:(float)v1 v2:(float)v2;
-(void)		setDelayVariation:(float)v1 v2:(float)v2;
-(void)		setPanvariation:(float)v1 v2:(float)v2;
// ***************************************************************************************

@end
