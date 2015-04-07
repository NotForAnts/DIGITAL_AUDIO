// ******************************************************************************************
//  WXDSInstrumentBlowHole
//  Created by Paul Webb on Mon Aug 15 2005.
// ******************************************************************************************
//    This class is based on the clarinet model,
//    with the addition of a two-port register hole
//    and a three-port dynamic tonehole
//    implementation, as discussed by Scavone and
//    Cook (1998).

//   In this implementation, the distances between
//   the reed/register hole and tonehole/bell are
//   fixed.  As a result, both the tonehole and
//   register hole will have variable influence on
//   the playing frequency, which is dependent on
//   the length of the air column.  In addition,
//   the highest playing freqeuency is limited by
//   these fixed lengths.
// ******************************************************************************************

#import <Foundation/Foundation.h>
#import "WXDSInstrumentObjectBasic.h"
#import "WXFilterOneZero.h"
#import "WXFilterDelayL.h"
#import "WXFilterPoleZero.h"
#import "WXDSInstrumentEnvelopeRamp.h"
#import "WXDSWaveTable.h"
#import "WXDSInstrumentReedTable.h"
// ******************************************************************************************

@interface WXDSInstrumentBlowHole : WXDSInstrumentObjectBasic {

WXFilterDelayL *delays[3];
WXDSInstrumentReedTable *reedTable;
WXFilterOneZero *filter;
WXFilterPoleZero *tonehole;
WXFilterPoleZero *vent;
WXDSInstrumentEnvelopeRamp *blowEnvelope;
WXDSWaveTable *vibrato;
long length;
float scatter;
float th_coeff;
float r_th;
float rh_coeff;
float rh_gain;
float outputGain;
float noiseGain;
float vibratoGain;
float lastOutput;
}

-(id) initInstrumentBlowHole:(float)lowestFrequency;

-(void) setFrequency:(float)frequency;
-(void) setVent:(float)newValue;
-(void) setTonehole:(float)newValue;
-(void) startBlowing:(float)amplitude rate:(float)rate;
-(void) stopBlowing:(float)rate;


@end
