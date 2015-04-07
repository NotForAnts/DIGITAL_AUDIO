// ******************************************************************************************
//  WXFilterIIR.h
//  Created by Paul Webb on Thu Dec 30 2004.
// ******************************************************************************************
// THIS ISNT ACTUALLY A GENERAL IIR FILTER as not general enough
//
// ******************************************************************************************
#import <Foundation/Foundation.h>
#import "WXFilterBase.h"
#import "WXUsefullCode.h"
// ******************************************************************************************
@interface WXFilterIIR : WXFilterBase {

float*		tap;
float		s1,s2,gain;
UInt32		theDelay,count,msize;
}


-(id)		initFilter:(UInt32)d s1:(float)fs1 s2:(float)fs2;
-(void)		setDelay:(long)delay;
-(void)		setFStrengths:(float)v1 s2:(float)v2;
-(void)		setStrengthOne:(float)v;
-(void)		setStrengthTwo:(float)v;
-(void)		setGain:(float)g;
-(void)		setDelayNSO:(id)delay;
-(void)		setStrengthOneNSO:(id)v;
-(void)		setStrengthTwoNSO:(id)v;
-(void)		setGainNSO:(id)g;

-(float)    filter:(float)sample;
@end
