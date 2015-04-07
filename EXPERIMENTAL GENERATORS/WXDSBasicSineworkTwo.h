// ************************************************************************************************
//  WXDSBasicSineworkTwo
//  Created by Paul Webb on Mon Jul 25 2005.
// ************************************************************************************************
//
//  repetitive sinewave work outs
//  that uses pulse waves based on sine value returned
//  the pulse length alters as does freq
//  also do repeated spatial effect which is quite nice too
// ************************************************************************************************

#import <Foundation/Foundation.h>
#import "WXDSRenderBase.h"
#import "WXFilterJohnChowningReverb.h"
#import "WXFilterPRCReverb.h"

// ************************************************************************************************
@interface WXDSBasicSineworkTwo : WXDSRenderBase {


int		resetCount,resetEvery;
BOOL	doPanShift;

float   level,origPan,panShift;
double  degree2;
double  delta2,delta3,delta4,delta5;
double  deltaStart1,deltaStart2,deltaStart4;

WXFilterJohnChowningReverb		*reverb;
}


-(void)		printParams;
-(void)		setPanShift:(BOOL)v start:(float)start shift:(float)shift;
-(void)		setEvery:(int)v;
-(void)		setDeltas:(float)d1 d2:(float)d2 d3:(float)d3 d4:(float)d4 d5:(float)d5;

@end
