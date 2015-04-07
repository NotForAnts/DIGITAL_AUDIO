// ***************************************************************************************
//  WXDSInstrumentBowed
//  Created by Paul Webb on Mon Aug 15 2005.
// ***************************************************************************************

#import <Foundation/Foundation.h>
#import "WXDSInstrumentObjectBasic.h"
#import "WXDSInstrumentBowTable.h"
#import "WXFilterDelayL.h"
#import "WXFilterOnePole.h"
#import "WXFilterBiQuad.h"
#import "WXDSWaveTable.h"
#import "WXDSInstrumentEnvelopeBase.h"
// ***************************************************************************************
@interface WXDSInstrumentBowed : WXDSInstrumentObjectBasic {

WXFilterDelayL				*neckDelay;
WXFilterDelayL				*bridgeDelay;
WXDSInstrumentBowTable		*bowTable;
WXFilterOnePole				*stringFilter;
WXFilterBiQuad				*bodyFilter;
WXDSWaveTable				*vibrato;
WXDSInstrumentEnvelopeBase  *adsr;

float maxVelocity;
float baseDelay;
float vibratoGain;
float betaRatio;
float lastOutput;
}

-(id)   initInstrumentBowed:(float)lowestFrequency;

@end
