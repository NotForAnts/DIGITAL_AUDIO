// ******************************************************************************************
//  WXSPKitResonator
//  Created by Paul Webb on Mon Jan 10 2005.
// ******************************************************************************************
#import <Foundation/Foundation.h>
#import "WXFilterBase.h"
// ******************************************************************************************
@interface WXSPKitResonator : WXFilterBase {

float centerFreq;
float bandwidth;

float C;
float a0;
float b1;
float b2;
float y1;
float y2;
}


-(float)	filter:(float)inputSample;
-(void)		clear;
-(void)		setCenterFreq:(float)f;
-(void)		setBandWidth:(float)bw;
-(void)		setCenterFreqAndBW:(float)f width:(float)bw;

@end
