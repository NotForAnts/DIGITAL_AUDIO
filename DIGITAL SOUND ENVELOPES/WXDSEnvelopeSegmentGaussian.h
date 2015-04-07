// ***************************************************************************************
//  WXDSEnvelopeSegmentGaussian
//  Created by Paul Webb on Sun Jul 24 2005.
// ***************************************************************************************

#import <Foundation/Foundation.h>
#import "WXDSEnvelopeBasic.h"

// ***************************************************************************************

@interface WXDSEnvelopeSegmentGaussian : WXDSEnvelopeBasic {

float   gain1,gain2;
float   maxMap,aValue;
int		halfDuration;
}


-(id)		initSegmentGaussian:(float)g1 g2:(float)g2;
-(void)		setDuration:(int)duration;

@end
