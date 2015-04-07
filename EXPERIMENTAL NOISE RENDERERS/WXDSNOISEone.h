// ***************************************************************************************
//  WXDSNOISEone
//  Created by Paul Webb on Mon Sep 19 2005.
// ***************************************************************************************
// AS PART OF A SERIES OF RENDERES THAT CAN MAKE NOISE SOUNDS
// I am experimenting with techniques which can make noise types that
// have parameters and maybe some semi-automatic self morphology of noise
//
// this one is based on sineWorkTwo - so a bit of a noise radiophonics thing
// and by controlling the rates and deltas can get a wide variation of noise and pulse beat noise
// types. Can either use gui to control it or algorithms
// see WXDSControllerNOISEone for some simple examples of controlling this
//
// ***************************************************************************************

#import <Foundation/Foundation.h>
#import "WXDSRenderBase.h"
#import "WXFilterJohnChowningReverb.h"
#import "WXFilterPRCReverb.h"
// ***************************************************************************************

@interface WXDSNOISEone : WXDSRenderBase {

int		combineType;
int		resetCount,resetEvery;
BOOL	doPanShift;

float   level,origPan,panShift;
double  degree2;
double  delta2,delta3,delta4,delta5;
double  deltaStart1,deltaStart2,deltaStart4;

int		maxRateEvery;
BOOL	mutateOneActive;
int		mutateOneRate,mutateOneCount;
float   mutateStrength;

WXFilterPRCReverb  *reverb;
}

-(void)			setCombineType:(int)t;
-(void)			setPanShiftActive:(BOOL)b;
-(void)			setMutateStrength:(float)v;
-(void)			setMutateRate:(int)v;
-(void)			setEveryCount:(int)v;
-(void)			setDeltaStart1:(float)v;
-(void)			setDeltaStart2:(float)v;
-(void)			setDeltaStart4:(float)v;
-(void)			setPanPosition:(float)v;

-(void)			setCombineTypeNSO:(id)t;
-(void)			setPanShiftActiveNSO:(id)b;
-(void)			setMutateStrengthNSO:(id)v;
-(void)			setMutateRateNSO:(id)v;
-(void)			setEveryCountNSO:(id)v;
-(void)			setDeltaStart1NSO:(id)v;
-(void)			setDeltaStart2NSO:(id)v;
-(void)			setDeltaStart4NSO:(id)v;
-(void)			setPanPositionNSO:(id)v;

-(void)			doMutate;

@end
