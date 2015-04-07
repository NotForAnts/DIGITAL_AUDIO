// ******************************************************************************************
//  WXDSInstrumentFlute
//  Created by Paul Webb on Mon Aug 15 2005.
// ******************************************************************************************
//  This class implements a simple flute
//  physical model, as discussed by Karjalainen,
//  Smith, Waryznyk, etc.  The jet model uses
//  a polynomial, a la Cook.
// ******************************************************************************************

#import <Foundation/Foundation.h>
#import "WXDSInstrumentObjectBasic.h"
#import "WXFilterOnePole.h"
#import "WXFilterDelayL.h"
#import "WXFilterPoleZero.h"
#import "WXDSWaveTable.h"
#import "WXDSInstrumentEnvelopeBase.h"
#import "WXDSInstrumentJetTable.h"
// ******************************************************************************************
@interface WXDSInstrumentFlute : WXDSInstrumentObjectBasic {


WXFilterDelayL					*jetDelay;
WXFilterDelayL					*boreDelay;
WXDSInstrumentJetTable			*jetTable;
WXFilterOnePole					*filter;
WXFilterPoleZero				*dcBlock;
WXDSInstrumentEnvelopeBase		*adsr;
WXDSWaveTable					*vibrato;

long length;
float lastFrequency;
float maxPressure;
float jetReflection;
float endReflection;
float noiseGain;
float vibratoGain;
float outputGain;
float jetRatio;
float lastOutput;
}


-(id)   initInstrumentFlute:(float)lowestFrequency;

-(void) clear;
-(void) setFrequency:(float)frequency;
-(void) startBlowing:(float)amplitude rate:(float)rate;
-(void) stopBlowing:(float)rate;
-(void) setJetReflection:(float)coefficient;
-(void) setEndReflection:(float)coefficient;
-(void) setJetDelay:(float)aRatio;

@end
