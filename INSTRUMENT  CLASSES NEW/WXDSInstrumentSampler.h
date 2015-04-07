// ***************************************************************************************
//  WXDSInstrumentSampler
//  Created by Paul Webb on Mon Aug 15 2005.
// ***************************************************************************************

#import <Foundation/Foundation.h>
#import "WXDSInstrumentObjectBasic.h"
#import "WXFilterOnePole.h"
#import "WXDSWaveTable.h"

// ***************************************************************************************
@interface WXDSInstrumentSampler : WXDSInstrumentObjectBasic {


WXDSInstrumentEnvelopeBase		*adsr; 
WXDSWaveTable					*attacks[5];
WXDSWaveTable					*loops[5];
WXFilterOnePole					*filter;
float baseFrequency;
float attackRatios[5];
float loopRatios[5];
float attackGain;
float loopGain;
float lastOutput;
int whichOne;
}



@end
