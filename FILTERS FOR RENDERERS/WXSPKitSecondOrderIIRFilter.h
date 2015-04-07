// ******************************************************************************************
//  WXSPKitSecondOrderIIRFilter.h
//  Created by Paul Webb on Mon Jan 10 2005.
// ******************************************************************************************
#import <Foundation/Foundation.h>
#import "WXFilterBase.h"
// ******************************************************************************************

@interface WXSPKitSecondOrderIIRFilter : WXFilterBase {

float C;
float D;
float a0, a1, a2;
float b1, b2;

float x[2];
float y[2];
}


-(void)		filterChunk:(float*)ioData frame:(UInt32)inNumFrames;
-(float)	filter:(float)inputSample;
-(void)		clear;


@end
