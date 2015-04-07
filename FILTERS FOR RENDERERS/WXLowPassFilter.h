// ******************************************************************************************
//  WXLowPassFilter.h
//  Created by Paul Webb on Thu Dec 30 2004.
//
// THIS IS NOT A VERY GOOD VERSION AS IT WAS AN EARLY ONE BEFORE
// MY STUDYING - USE THE OTHER ONE
// ******************************************************************************************
#import <Foundation/Foundation.h>
#import "WXFilterBase.h"
// ******************************************************************************************
@interface WXLowPassFilter : WXFilterBase {

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

-(float)   filter:(float)sample;
-(float)   filterFB:(float)sample;
@end
