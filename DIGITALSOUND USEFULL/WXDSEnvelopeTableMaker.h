// ******************************************************************************************
//  WXDSEnvelopeTableMaker
//  Created by Paul Webb on Mon Nov 29 2004.
// ******************************************************************************************
//  ENVELOPES OR WAVEFORMS SAME THINGS REALLY
//  makes a float array with some sets of shaped values
//
//  NOTE CAN ALSO USE CALCULATORS INSTEAD OF THIS
//		float   *wave=[sineCalc makeTable:44100 r1:0 r2:1.0];
// ******************************************************************************************

#import <Foundation/Foundation.h>
#import "WXUsefullCode.h"
// ******************************************************************************************

@interface WXDSEnvelopeTableMaker : NSObject {

}


-(float*)   makeRampTable:(int)size freq:(NSString*)freq amp:(NSString*)amp r1:(float)r1 r2:(float)r2;
-(float*)   makeSineWaveTable:(int)size r1:(float)r1 r2:(float)r2 freq:(float)freq;
-(float*)   makePartialSineTable:(int)size freq:(NSString*)freq amp:(NSString*)amp r1:(float)r1 r2:(float)r2;
-(float*)   makeDecaySineWaveTable:(int)size r1:(float)r1 r2:(float)r2 freq:(float)freq;
-(float*)   makePulseTable:(int)size r1:(float)r1 r2:(float)r2 freq:(float)freq pulsePercent:(int)pulsePercent;
-(float*)   makeSincPulseWaveTable:(int)size r1:(float)r1 r2:(float)r2 freq:(float)freq phases:(float)phases;
-(float*)   makeNoisePulseWave:(int)size r1:(float)r1 r2:(float)r2 freq:(float)freq pulsePercent:(int)pulsePercent;

-(float*)   makeSmoothSineEnvelope:(int)size r1:(float)r1 r2:(float)r2;
-(float*)	makeTriangleEnvelope:(int)size r1:(float)r1 r2:(float)r2;
-(float*)   makeThreeStageTriangleEnvelope:(int)size r1:(float)r1 r2:(float)r2 flat:(int)flat;
-(float*)	makeGaussianEnvelope:(int)size r1:(float)r1 r2:(float)r2;
-(float*)	makeQuasiGaussianEnvelope:(int)size flat:(int)flat r1:(float)r1 r2:(float)r2;
-(float*)	makeShiftedGaussianEnvelope:(int)size p1:(int)p1 p2:(int)p2 r1:(float)r1 r2:(float)r2;
-(float*)	makeStraightEnvelope:(int)size r1:(float)r1 r2:(float)r2;	
-(float*)	makeRexpodecEnvelope:(int)size r1:(float)r1 r2:(float)r2 e1:(float)e1 e2:(float)e2;
-(float*)	makeExpodecEnvelope:(int)size r1:(float)r1 r2:(float)r2;
-(float*)	makeExpodecEnvelope:(int)size r1:(float)r1 r2:(float)r2 e1:(float)e1 e2:(float)e2;
-(float*)	makeShiftedHalfSineEnvelope:(int)size p1:(int)p1 p2:(int)p2 r1:(float)r1 r2:(float)r2;
-(float*)	makeSincEnvelope:(int)size r1:(float)r1 r2:(float)r2 phases:(float)phases;
-(float*)   makeADSREnvelope:(int)size v1:(float)v1 t1:(int)t1 v2:(float)v2 t2:(int)t2 v3:(float)v3 t3:(int)t3;



@end
