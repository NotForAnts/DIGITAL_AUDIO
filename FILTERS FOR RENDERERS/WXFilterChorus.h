// ******************************************************************************************
//  WXFilterChorus
//  Created by Paul Webb on Wed Dec 29 2004.
//
//  chorus in which can set delay1,delay2 range which gets oscilated to make the chorus
//  and the freq
//
// ******************************************************************************************
#import <Foundation/Foundation.h>
#import "WXFilterBase.h"
// ******************************************************************************************

@interface WXFilterChorus : WXFilterBase {

float*		tap;
double		strength,LFO,LFOphase,LFOdelta;
UInt32		delay,delay1,delay2,delayMid,delayRange,count,msize;
}

-(id)		initChorus:(UInt32)ms;
	
-(void)		setFreq:(float)freq;
-(void)		setDelay1:(int)d1;
-(void)		setDelay2:(int)d2;
-(void)		setChorus:(int)d1 d2:(int)d2 freq:(float)freq;
-(void)		setFreqNSO:(id)freq;
-(void)		setDelay1NSO:(id)d1;
-(void)		setDelay2NSO:(id)d2;

-(float)	filter:(float)input;

@end
