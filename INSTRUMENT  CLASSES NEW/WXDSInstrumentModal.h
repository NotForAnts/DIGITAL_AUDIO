// ***************************************************************************************
//  WXDSInstrumentModal
//  Created by Paul Webb on Sun Aug 14 2005.
// ***************************************************************************************

#import <Foundation/Foundation.h>
#import "WXDSInstrumentObjectBasic.h"
#import "WXDSWaveTable.h"
#import "WXFilterBiQuad.h"
#import "WXFilterOnePole.h"
#import "WXDSInstrumentEnvelopeRamp.h"
// ***************************************************************************************

@interface WXDSInstrumentModal : WXDSInstrumentObjectBasic {

WXDSInstrumentEnvelopeRamp *anEnvelope; 
WXDSWaveTable     *wave;
WXFilterBiQuad	*filters[10];
WXFilterOnePole   *onepole;
WXDSWaveTable		*vibrato;
int nModes;
float vibratoGain;
float aMasterGain;
float directGain;
float stickHardness;
float strikePosition;
float baseFrequency;
float ratios[10];
float radii[10];
}


-(id) initInstrumentModal:(short)modes;


-(void) clear;
-(void) setFrequency:(float)frequency;
-(void) setRatioAndRadius:(int)modeIndex ratio:(float)ratio radius:(float)radius;
-(void) setaMasterGain:(float)aGain;
-(void) setDirectGain:(float)aGain;
-(void) damp:(float)amplitude;
-(void)  setModeGain:(int)modeIndex gain:(float)gain;
-(void) strike:(float)amplitude;

@end
