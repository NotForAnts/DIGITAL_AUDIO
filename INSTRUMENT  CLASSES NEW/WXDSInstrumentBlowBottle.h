// ******************************************************************************************
//  WXDSInstrumentBlowBottle
//  Created by Paul Webb on Mon Aug 15 2005.
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
@interface WXDSInstrumentBlowBottle : WXDSInstrumentObjectBasic {


WXDSInstrumentJetTable *jetTable;
WXFilterBiQuad *resonator;
WXFilterPoleZero *dcBlock;
WXDSInstrumentEnvelopeBase *adsr;
WXDSWaveTable *vibrato;
float maxPressure;
float noiseGain;
float vibratoGain;
float outputGain;
float lastOutput;
}

-(void) startBlowing:(float)amplitude rate:(float)rate;
-(void) stopBlowing:(float)rate;

// ******************************************************************************************

@end
