// ***************************************************************************************
//  WXDSGrain
//  Created by Paul Webb on Thu Dec 30 2004.
// ***************************************************************************************
#import <Foundation/Foundation.h>
#import "WXUsefullCode.h"

// ***************************************************************************************
@interface WXDSGrain : NSObject {

float   *wavePointer;
float   *envelopePointer;
int		waveType,envelopeType,index,grainWaveModulas;
float   waveIncrement,frequency,waveIndex;
float   envelopeIndex,envelopeIncrement,gain,leftSample,rightSample,panPosition,sample;
int		grainDuration,tickCountDown,startSampleTime;

WXDSGrain*  nextGrain;
WXDSGrain*  prevGrain;
}

-(void)			initGrain:(float)freq gain:(float)g pan:(float)pan dur:(int)dur wave:(float*)wp env:(float*)ep index:(int)i;
-(void)			setGrainWaveModulas:(int)mod;
-(void)			setStartTime:(int)sampleTime;
-(void)			tick;
-(void)			getLeftRight:(float*)ls right:(float*)rs;
-(float)		getLeftSample;
-(float)		getRightSample;
-(int)			getCountDown;
-(int)			getIndex;
-(void)			removeSelfFromGrainList;
-(void)			setNext:(WXDSGrain*)grain;
-(void)			setPrev:(WXDSGrain*)grain;
-(void)			setPrevAndNext:(WXDSGrain*)prev next:(WXDSGrain*)next;
-(WXDSGrain*)   getNext;
-(WXDSGrain*)   getPrev;

// ***************************************************************************************

@end
