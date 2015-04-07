// ******************************************************************************************
//  WXDSInstrumentFM
//  Created by Paul Webb on Sun Aug 14 2005.
// ******************************************************************************************
//
//  this is based on perry cooks FM class
//
//
// ******************************************************************************************

#import <Foundation/Foundation.h>
#import "WXDSInstrumentObjectBasic.h"
#import "WXDSEnvelopeTableMaker.h"
#import "WXFilterTwoZero.h"
#import "WXDSWaveTable.h"
// ******************************************************************************************

@interface WXDSInstrumentFM : WXDSInstrumentObjectBasic {

WXDSInstrumentEnvelopeBase  *adsr[20];
WXDSWaveTable				*waves[20];
WXDSWaveTable				*vibrato;
WXFilterTwoZero				*twozero;
WXDSEnvelopeTableMaker		*waveMaker;
  
int nOperators;
float baseFrequency;
float ratios[20];
float gains[20];  
float modDepth;
float control1;
float control2;
float __FM_gains[100];
float __FM_susLevels[16];
float __FM_attTimes[32];
}

-(id)   initInstrumentFM:(short)nopss;
-(void) setRatio:(int)waveIndex ratio:(float)ratio;

@end
