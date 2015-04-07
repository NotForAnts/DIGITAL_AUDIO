// ************************************************************************************************
//  WXFilterPoleZero
//  Created by Paul Webb on Thu Aug 18 2005.
// ************************************************************************************************


#import <Foundation/Foundation.h>
#import "WXFilter.h"
// ************************************************************************************************



@interface WXFilterPoleZero : WXFilter {

}

-(void) clear;
-(void) setB0:(float)b0;
-(void) setB1:(float)b1;
-(void) setA1:(float)a1;
-(void) setAllpass:(float)coefficient;
-(void) setBlockZeroDef;
-(void) setBlockZero:(float)thePole; // = 0.99);
-(void) setGain:(float)theGain;

-(void) setB0NSO:(id)b0;
-(void) setB1NSO:(id)b1;
-(void) setA1NSO:(id)a1;
-(void) setAllpassNSO:(id)coefficient;
-(void) setBlockZeroNSO:(id)thePole; // = 0.99);
-(void) setGainNSO:(id)theGain;

-(float) getGain;
-(float) lastOut;
-(float) filter:(float)sample;
//-(void) filterChunk(float *vector, unsigned int vectorSize);


// ************************************************************************************************


@end
