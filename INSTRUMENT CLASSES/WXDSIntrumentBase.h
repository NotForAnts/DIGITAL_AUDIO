// ***************************************************************************************
//  WXDSIntrumentBase
//  Created by Paul Webb on Wed Jan 12 2005.
// ***************************************************************************************
//  POLYPHONIC
//  NOTE duration in seconds - gain 0.0 to 1.0  (and then the master gain is separate)
//
// ***************************************************************************************
#import <Foundation/Foundation.h>
#import "WXDSRenderBase.h"
#import "WXDSAdsr.h"
#import "WXMusicMidiToFrequency.h"
// ***************************************************************************************
#define kMAXINSTRUMENTPOLY 8
// ***************************************************************************************
@interface WXDSIntrumentBase : WXDSRenderBase {

BOOL		freePoly[kMAXINSTRUMENTPOLY];
float		polyFreq[kMAXINSTRUMENTPOLY];
float		noteDuration,noteFrequency,adsrGain;
WXDSAdsr*   theADSR[kMAXINSTRUMENTPOLY];
int			newChannel,currentFree;
WXMusicMidiToFrequency*		midiFreqConverter;
//
int			freeIndexStore[kMAXINSTRUMENTPOLY],freePlace;
}

-(void)		keyOnWithGain:(float)gain;

//			ONS FOR FREQ
-(void)		keyOnWithReGainAndFrequency:(float)gain freq:(float)freq;
-(void)		keyOnWithGainAndFrequency:(float)gain freq:(float)freq;
-(void)		keyOnWithGainFrequencyDuration:(float)gain freq:(float)freq dur:(float)duration;
-(void)		keyOffForFreq:(float)freq;

//			ON FOR MIDI - i,e midi get converted to freq.
-(void)		keyOnWithReGainMidi:(float)gain  midi:(short)midi;
-(void)		keyOnWithGainMidi:(float)gain midi:(short)midi;
-(void)		keyOnWithGainMidiDuration:(float)gain midi:(short)midi dur:(float)duration;
-(void)		keyOffForMidi:(short)midi;

//			KEY OFF OTHER ONES
-(void)		keyOffAll;
-(void)		keyOffChannel:(short)channel;
-(void)		keyOff;

-(void)		setADSR:(float)alevel at:(float)atime dl:(float)dlevel dt:(float)dtime rl:(float)rlevel rt:(float)rtime;


//  private to override		- used for example to convert freq to deltas.
-(void)		doKeyOnExtra:(short)channel freq:(float)freq;
-(void)		doKeyOffExtra:(short)channel;
-(short)	getFreePoly;
@end
