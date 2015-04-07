// ******************************************************************************************
//  WXFilterSweepableFormant
//  Created by Paul Webb on Thu Dec 30 2004.
// ******************************************************************************************
#import <Foundation/Foundation.h>
#import "WXFilterBiQuad.h"
// ******************************************************************************************
@interface WXFilterSweepableFormant : WXFilterBiQuad {

BOOL dirty;
float frequency;
float radius;
float startFrequency;
float startRadius;
float startGain;
float targetFrequency;
float targetRadius;
float targetGain;
float deltaFrequency;
float deltaRadius;
float deltaGain;
float sweepState;
float sweepRate;
}

-(void) setResonance:(float)aFrequency aRadius:(float)aRadius;
-(void) setStates:(float)aFrequency  aRadius:(float)aRadius aGain:(float)aGain;
-(void) setTargets:(float)aFrequency aRadius:(float)aRadius aGain:(float)aGain;
-(void) setSweepRate:(float)aRate;    
-(void) setSweepTime:(float)aTime; 
-(float) filter:(float)sample;

@end
