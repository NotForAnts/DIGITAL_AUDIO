// ************************************************************************************************
//  WXFilterTwoZero.h
//  Created by Paul Webb on Thu Dec 30 2004.
// ************************************************************************************************
#import <Foundation/Foundation.h>
#import "WXFilter.h"
// ************************************************************************************************


@interface WXFilterTwoZero : WXFilter {

float   notchFreq,notchRadius;
}

-(void) clear;
-(void) setB0:(float)b0;
-(void) setB1:(float)b1;
-(void) setB2:(float)b2;
-(void) setNotchFreq:(float)frequency;
-(void) setNotchRadius:(float)radius;	
-(void) setNotch:(float)frequency radius:(float)radius;
-(void) setGain:(float)theGain;


-(void) setB0NSO:(id)b0;
-(void) setB1NSO:(id)b1;
-(void) setB2NSO:(id)b2;
-(void) setNotchFreqNSO:(id)frequency;
-(void) setNotchRadiusNSO:(id)radius;	
-(void) setGainNSO:(id)theGain;



-(float) getGain;
-(float) lastOut;
-(float) filter:(float)sample;


@end
