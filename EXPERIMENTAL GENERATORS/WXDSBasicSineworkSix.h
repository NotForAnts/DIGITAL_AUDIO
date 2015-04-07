// ************************************************************************************************
//  WXDSBasicSineworkSix
//  Created by Paul Webb on Thu Jul 28 2005.
// ************************************************************************************************


#import <Foundation/Foundation.h>
#import "WXDSRenderBase.h"
#import "WXFilterJohnChowningReverb.h"
#import "WXFilterPRCReverb.h"
// ************************************************************************************************

@interface WXDSBasicSineworkSix : WXDSRenderBase {

float   useValue;
double   origPan,panShift;
double freq;

double  delta2,delta3,addDelta;
double  delta1Orig,delta2Orig;

int		pulseLength,pulseCount;

WXFilterPRCReverb  *reverb;
}

-(void)		setParameters;

// ************************************************************************************************



@end
