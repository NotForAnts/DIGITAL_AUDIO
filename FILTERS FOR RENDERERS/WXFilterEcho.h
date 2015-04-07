// ************************************************************************************************
//  WXFilterEcho
//  Created by Paul Webb on Wed Dec 29 2004.
// ************************************************************************************************

#import <Foundation/Foundation.h>
#import "WXFilterDelay.h" 
#import "WXFilterBase.h"
// ************************************************************************************************
@interface WXFilterEcho : WXFilterBase {

WXFilterDelay *delayLine;
long length;
float lastOutput;
float effectMix;
}

-(id)   initEcho:(float)longestDelay;

-(void) clear;

-(void) setDelayAndMix:(float)delay mix:(float)mix;
-(void) setDelay:(long)delay;
-(void) setEffectMix:(float)mix;
-(void) setDelayNSO:(id)delay;
-(void) setEffectMixNSO:(id)mix;
-(float) lastOut;
-(float) filter:(float)input;


@end
