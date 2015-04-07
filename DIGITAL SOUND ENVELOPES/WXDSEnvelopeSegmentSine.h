// ***************************************************************************************
//  WXDSEnvelopeSegmentSine
//  Created by Paul Webb on Sat Jul 23 2005.
// ***************************************************************************************


#import <Foundation/Foundation.h>
#import "WXDSEnvelopeBasic.h"

// ***************************************************************************************

@interface WXDSEnvelopeSegmentSine : WXDSEnvelopeBasic {

float   gain1,gain2,degree1,degree2,degree;
float   radianValue,radianIncrement;
}



-(id)		initSegmentLinear:(float)g1 g2:(float)g2;
-(void)		setDegree:(float) d1 d2:(float)d2;

@end
