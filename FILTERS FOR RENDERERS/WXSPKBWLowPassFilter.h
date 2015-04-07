// ******************************************************************************************
//  WXSPKBWLowPassFilter
//  Created by Paul Webb on Mon Jan 10 2005.
//
// LOW PASS conversion from SPKitBWLowPassFilter / bwlowpas.cc
// ******************************************************************************************
#import <Foundation/Foundation.h>
#import "WXSPKitSecondOrderIIRFilter.h"
// ******************************************************************************************
@interface WXSPKBWLowPassFilter : WXSPKitSecondOrderIIRFilter {

float   cutOffFreq;
}

-(void)		setCutOffFreq:(float)freq;
-(void)		setCutOffFreqNSO:(id)freq;

@end
