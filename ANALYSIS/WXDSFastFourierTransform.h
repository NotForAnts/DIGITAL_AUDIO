// *********************************************************************************************
//  WXDSFastFourierTransform.m
//  Created by Paul Webb on Thu Jan 06 2005.
//
//  got this converted from
//
//  http://www.dsptutor.freeuk.com/analyser/SpectrumAnalyser.html
// *********************************************************************************************
//
//  Now trying (Jan 2005) to use apples on vDSP lib
//  And place a cocoa wrapper around it and also make as a filter type
//  get input and analise as going along with window functions
//
// *********************************************************************************************
#import <Foundation/Foundation.h>
#include <Accelerate/Accelerate.h>
#include <sys/param.h>
#include <sys/sysctl.h>
// *********************************************************************************************
@interface WXDSFastFourierTransform : NSObject {

float*		sampleWindow1;
float*		sampleWindow2;

int			numberFreqs,index1,index2,counter,sampleSize;
int			number,nu;

float*		HAMMING;
float*		BARTLETT;
float*		HANNING;
float*		BLACKMAN;


COMPLEX_SPLIT A;
FFTSetup	setupReal;
UInt32		log2n;
UInt32		nSize, nOver2;
SInt32		stride;
float		*obtainedReal;
float		scale;
float		theBands[512];
}


-(void)		setWindowCurves;
-(float*)   calculateBands;
-(OSStatus) filterChunk:(float*)ioData frame:(UInt32)inNumFrames;
-(float*)   filter:(float)input;
-(float*)   analise:(float*)originalReal;
-(int)		numberFreqsChecked;
-(float*)   getReal;

@end
