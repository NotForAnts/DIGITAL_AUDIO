// ***************************************************************************************
//  WXDSInstrumentObjectBasic
//  Created by Paul Webb on Sat Aug 13 2005.
// ***************************************************************************************
//  the all new basic instrument class
//
//  instrument classes are based on NOTE ON, NOTE OFF MESSAGE CALLS
//
//
// ***************************************************************************************

#import <Foundation/Foundation.h>
#import "WXDSInstrumentEnvelopeBase.h"
#import "WXDSRenderBase.h"
#import "WXMusicMidiToFrequency.h"


// ***************************************************************************************
@interface WXDSInstrumentObjectBasic : WXDSRenderBase {

WXMusicMidiToFrequency		*midiFreqConverter;
WXDSInstrumentEnvelopeBase  *envelope;

float		noteFrequency;
float		adsrGain;
}

-(void) setFrequency:(float)freq;
-(void) keyOnWithGainFrequencyDuration:(float)freq gain:(float)gain duration:(float)duration;
-(void) keyONWithReGainAndFrequency:(float)freq gain:(float)gain;
-(void) keyONWithFreqGain:(float)freq gain:(float)gain;
-(void) keyOFF;
-(void) doKeyOnExtra:(float)freq;

// ***************************************************************************************

@end
