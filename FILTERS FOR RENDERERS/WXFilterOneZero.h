// ******************************************************************************************
//  WXFilterOneZero
//  Created by Paul Webb on Thu Dec 30 2004.
// ******************************************************************************************
#import <Foundation/Foundation.h>
#import "WXFilter.h"


@interface WXFilterOneZero : WXFilter {

}

-(id)   initFilter:(float)theZero;
-(void) clear;
-(void) setB0:(float)b0;
-(void) setB1:(float)b1;
-(void) setZero:(float)theZero;
-(void) setGain:(float)theGain;
-(void) setB0NSO:(id)b0;
-(void) setB1NSO:(id)b1;
-(void) setZeroNSO:(id)theZero;
-(void) setGainNSO:(id)theGain;
-(float) getGain;
-(float) lastOut;
-(float) filter:(float)sample;

@end
