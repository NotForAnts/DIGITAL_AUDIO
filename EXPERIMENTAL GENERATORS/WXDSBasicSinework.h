// ************************************************************************************************
//  WXDSBasicSinework
//  Created by Paul Webb on Mon Jul 25 2005.
// ************************************************************************************************
//  work out based on increments of delta1,delta2,delta3
//  and random timed shifts of delta2,delta3 and some other things
//
// ************************************************************************************************



#import <Foundation/Foundation.h>
#import "WXDSRenderBase.h"

// ************************************************************************************************


@interface WXDSBasicSinework : WXDSRenderBase {

int typeCount,flipChance1,flipChance2;

double  delta2,delta3;
}


-(id)		initWithFreq:(double)r;

@end
