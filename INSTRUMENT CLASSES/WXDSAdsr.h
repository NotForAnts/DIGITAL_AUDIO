// ************************************************************************************************
//  WXDSAdsr
//  Created by Paul Webb on Wed Jan 12 2005.
// ************************************************************************************************
#import <Foundation/Foundation.h>

// ************************************************************************************************
@interface WXDSAdsr : NSObject {
	
short   state;
float   attackLevel,attackTime,gain;
float   decayLevel,decayTime;
float   releaseLevel,releaseTime,noteDuration,sustainTime,sustainCounter;
float   attackDelta,decayDelta,releaseDelta,value;
}

-(void)		keyOnWithGainAndDuration:(float)g dur:(float)duration;
-(void)		keyOnWithGain:(float)g;
-(void)		keyOnWithReGain:(float)g;
-(void)		keyOff;
-(void)		setAttack:(float)l time:(float)t;
-(void)		setDecay:(float)l time:(float)t;
-(void)		setRelease:(float)l time:(float)t;
-(BOOL)		hasFinished;
-(short)	getCurrentState;
-(float)	tick;
-(void)		calcRates;

// ************************************************************************************************

@end
