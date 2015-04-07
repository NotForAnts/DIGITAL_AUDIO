// ************************************************************************************************
//  WXDSInstrumentEnvelopeBase
//  Created by Paul Webb on Tue Aug 02 2005.
// ************************************************************************************************
// instrument envelopes are for use with instrument classes
// instrument digital sound objects have noteON and noteOFF
//
//  the note ON begin ATTACK portion of the envelope
//  the note OFF begins RELEASE portion of the envelope
//  inbetween is the sustain part
//
//  a basic example if ADSR
//
//  all ATTACK SUSTAIN RELEASE componants can be any kind of shape
//
// ************************************************************************************************

#import <Foundation/Foundation.h>


@interface WXDSInstrumentEnvelopeBase : NSObject {

short   state;
float   attackLevel,attackTime,gain;
float   decayLevel,decayTime;
float   releaseLevel,releaseTime,noteDuration,sustainTime,sustainCounter;
float   attackDelta,decayDelta,releaseDelta,value;
}

-(void)		setRate:(float)v;
-(void)		keyOnWithGainAndDuration:(float)g dur:(float)duration;
-(void)		keyOnWithGain:(float)g;
-(void)		keyOnWithReGain:(float)g;
-(void)		keyOff;
-(void)		setAttack:(float)l time:(float)t;
-(void)		setDecay:(float)l time:(float)t;
-(void)		setRelease:(float)l time:(float)t;
-(void)		setReleaseRate:(float)r;
-(void)		setAttackRate:(float)r;
-(void)		setAllTimes:(float)v1 v2:(float)v2 v3:(float)v3 v4:(float)v4;
-(BOOL)		hasFinished;
-(short)	getCurrentState;
-(float)	tick;
-(void)		calcRates;

// ************************************************************************************************


@end
