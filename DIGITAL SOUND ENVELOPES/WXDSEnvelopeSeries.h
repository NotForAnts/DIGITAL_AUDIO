// ***************************************************************************************
//  WXDSEnvelopeSeries
//  Created by Paul Webb on Sat Jul 23 2005.
// ***************************************************************************************


#import <Foundation/Foundation.h>
#import "WXDSEnvelopeBasic.h"

#import "WXDSEnvelopeSegmentLinear.h"
#import "WXDSEnvelopeSegmentExponential.h"
#import "WXDSEnvelopeSegmentLog.h"
#import "WXDSEnvelopeSegmentSine.h"
#import "WXDSEnvelopeSegmentGaussian.h"
// ***************************************************************************************

@interface WXDSEnvelopeSeries : WXDSEnvelopeBasic {

NSMutableArray		*theSeries;
WXDSEnvelopeBasic   *currentEnvelope;
int numberSegments,currentSegment;
}


-(void)		addObject:(id)env;
-(void)		addObjectAndRelease:(id)env;

@end
