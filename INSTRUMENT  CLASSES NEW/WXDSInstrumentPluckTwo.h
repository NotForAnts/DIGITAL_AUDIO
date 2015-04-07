// ***************************************************************************************
//  WXDSInstrumentPluckTwo
//  Created by Paul Webb on Sun Aug 14 2005.
// ***************************************************************************************
// enhanced plucked string model class.
//
//  This class implements an enhanced two-string,
//   plucked physical model, a la Jaffe-Smith,
//  Smith, and others.
//
//  PluckTwo is an abstract class, with no excitation
//  specified.  Therefore, it can't be directly
//  instantiated.
// ***************************************************************************************

#import <Foundation/Foundation.h>
#import "WXDSInstrumentObjectBasic.h"
#import "WXFilterDelayA.h"
#import "WXFilterDelayL.h"
#import "WXFilterOneZero.h"

// ***************************************************************************************

@interface WXDSInstrumentPluckTwo : WXDSInstrumentObjectBasic {

WXFilterDelayA *delayLine;
WXFilterDelayA *delayLine2;
WXFilterDelayL *combDelay;
WXFilterOneZero *filter;
WXFilterOneZero *filter2;
long length;
float loopGain;
float baseLoopGain;
float lastFrequency;
float lastLength;
float detuning;
float pluckAmplitude;
float pluckPosition;
}

-(id) initPluckTwo:(float)lowestFrequency;
-(void) clear;
-(void) setFrequency:(float)frequency;
-(void) setDetune:(float)detune;
-(void) setFreqAndDetune:(float)frequency detune:(float)detune;
-(void) setPluckPosition:(float)position;


// ***************************************************************************************


@end
