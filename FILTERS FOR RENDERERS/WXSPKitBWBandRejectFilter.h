// ******************************************************************************************
//  WXSPKitBWBandRejectFilter
//  Created by Paul Webb on Mon Jan 10 2005.
// ******************************************************************************************
#import <Foundation/Foundation.h>
#import "WXSPKitSecondOrderIIRFilter.h"
// ******************************************************************************************
@interface WXSPKitBWBandRejectFilter : WXSPKitSecondOrderIIRFilter {

float centerFreq;
float bandwidth;
}


-(void) setCenterFreq:(float)f;
-(void) setBandWidth:(float)bw;
-(void) setCenterFreqAndBW:(float)f width:(float)bw;

-(void) setCenterFreqNSO:(id)f;
-(void) setBandWidthNSO:(id)bw;

@end
