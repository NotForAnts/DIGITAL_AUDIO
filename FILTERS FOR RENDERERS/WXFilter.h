// ************************************************************************************************
//  WXFilter.h
//  Created by Paul Webb on Wed Dec 29 2004.
// ************************************************************************************************
// THIS IS A BASIC GENERAL FILTER THAT CAN BE A FIR OR A IIR
// for a FIR don't use the B coefficients
//
// FIR =  ouput(t) = a0*input(t) + a1*input(t-1) + a2*input(t-2)
//
//
// IIR =  output(t) =   a0*input(t) + a1*input(t-1) + a2*input(t-2)
//                    + b1*output(t-1) + b2*output(t-2) + b3*output(t-3)
// ************************************************************************************************
//  TO USE THIS
//
//  float A[2] = {1.0, -0.9}, B[2] = {1.0, -0.9};
//  filter=[[WXFilter alloc] initFilter:2 bc:B na:2 ac:A];
//
//
//
// ************************************************************************************************
#import <Foundation/Foundation.h>
#import "WXFilterBase.h"

#define TWO_PI  2.0 * 3.14159265359
// ************************************************************************************************
@interface WXFilter : WXFilterBase {

int		nB,nA;
float   gain;
float   *a,*b;
float   *outputs,*inputs;
}

-(id)		initFilter:(int)nb bc:(float*)bCoefficients na:(int)na ac:(float*)aCoefficients;
-(void)		clear;
-(void)		setCoefficients:(int)nb bc:(float*)bCoefficients na:(int)na ac:(float*)aCoefficients;
-(void)		setNumerator:(int)nb  bc:(float*)bCoefficients;
-(void)		setDenominator:(int)na  ac:(float*)aCoefficients;
	
-(void)		setGain:(float)theGain;
-(float)	getGain;
-(float)	lastOut;
-(float)	filter:(float)sample;


@end
