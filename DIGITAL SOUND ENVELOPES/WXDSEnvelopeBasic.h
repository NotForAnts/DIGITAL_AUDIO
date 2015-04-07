// ***************************************************************************************
//  WXDSEnvelopeBasic
//  Created by Paul Webb on Fri Jul 22 2005.
// ***************************************************************************************
//
//  ENVELOPE OBJECTS FOR DIGITAL SOUND OBJECTS
//  - have first created these for use by WXDSWavemixSynthesisObject
//  - these envelopes can either be algorithmic, formulae or from wave-tables
//  - am using a polymorphic approach here
//
//
//  shared properties for an envelope (mostly) are
//  - envelope duration measured in samples at 44100 samples per second
//
//
//  this base class is a simple attack, sustain, release envelope
//  and is calculated using a algorithm
// ***************************************************************************************

#import <Foundation/Foundation.h>
#import "WXUsefullCode.h"
#import "AudioToolBox/AUGraph.h"
// ***************************************************************************************

@interface WXDSEnvelopeBasic : NSObject {

int		evelopeDuration,counter;

//		for this one
int		attackTime, releaseTime,releaseStart;
BOOL	done;
}

-(id)		initEvelope:(int)duration attack:(int)attack release:(int)release;
-(int)		evelopeDuration;
-(void)		setDuration:(int)duration;
-(void)		setDurationExtra;
-(void)		setAttack:(int)attack;
-(void)		setRelease:(int)release;
-(void)		reset;
-(BOOL)		done;

-(float)	tick;
-(void)		renderEnvelopeOnto:(AudioBufferList*)ioData frame:(UInt32)inNumFrames skipSize:(int)skipSize;
-(void)		renderEnvelopeForPanOnto:(AudioBufferList*)ioData frame:(UInt32)inNumFrames skipSize:(int)skipSize;


@end
