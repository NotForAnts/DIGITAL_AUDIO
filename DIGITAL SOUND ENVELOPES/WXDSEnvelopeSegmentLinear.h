// ***************************************************************************************
//  WXDSEnvelopeSegmentLinear
//  Created by Paul Webb on Sat Jul 23 2005.
// ***************************************************************************************

#import <Foundation/Foundation.h>
#import "WXDSEnvelopeBasic.h"

// ***************************************************************************************


@interface WXDSEnvelopeSegmentLinear : WXDSEnvelopeBasic {

float   gain1,gain2;

}

-(id)		initSegmentLinear:(float)g1 g2:(float)g2;

@end
