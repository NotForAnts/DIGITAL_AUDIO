// ******************************************************************************************
//  WXDSExpOne.h
//  Created by Paul Webb on Fri Aug 19 2005.
// ******************************************************************************************

#import <Foundation/Foundation.h>
#import "WXDSInstrumentObjectBasic.h"


#import "WXDSInstrumentEnvelopeBase.h"
#import "WXDSWaveTable.h"
#import "WXFilterPoleZero.h"
#import "WXFilterBiQuad.h"
#import "WXDSInstrumentJetTable.h"

#define __BOTTLE_RADIUS__ 0.999
// ******************************************************************************************
@interface WXDSExpOne : WXDSInstrumentObjectBasic {


WXDSInstrumentJetTable *jetTable;
WXFilterBiQuad *resonator;
WXFilterBiQuad *resonator2;
WXFilterBiQuad *resonator3;
WXFilterPoleZero *dcBlock;
WXDSInstrumentEnvelopeBase *adsr;
WXDSWaveTable *vibrato;
float maxPressure;
float noiseGain;
float vibratoGain;
float outputGain;
float lastOutput;

int counter;
}

@end
