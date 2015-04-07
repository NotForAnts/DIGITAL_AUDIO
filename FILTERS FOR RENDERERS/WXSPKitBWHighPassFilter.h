// ******************************************************************************************
//  WXSPKitBWHighPassFilter.h
//  Created by Paul Webb on Mon Jan 10 2005.
// ******************************************************************************************


#import <Foundation/Foundation.h>
#import "WXSPKitSecondOrderIIRFilter.h"
// ******************************************************************************************
@interface WXSPKitBWHighPassFilter : WXSPKitSecondOrderIIRFilter {

float   cutOffFreq;
}

-(void)		setCutOffFreq:(float)freq;
-(void)		setCutOffFreqNSO:(id)freq;

@end
