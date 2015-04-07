// ***************************************************************************************
//  WXDSControllerNOISEone.m
//  Created by Paul Webb on Mon Sep 19 2005.
// ***************************************************************************************
//  An example of an algorithmic controller for WXDSNOISEone
//
//
//
// ***************************************************************************************

#import <Foundation/Foundation.h>
#import "WXDSNOISEone.h"
#import "WXDSTragectoryManager.h"
#import "WXDSTragectoryPatternManager.h"

// ***************************************************************************************

@interface WXDSControllerNOISEone : NSObject {

WXDSNOISEone	*theNoise;

int		updateRate,updateCounter,mapRange2;

NSMutableString  *pattern;
int		patternLength,patternIndex,patternCount;

// for intense control
WXDSTragectoryManager   *trag1;
WXDSTragectoryManager   *trag2;
WXDSTragectoryManager   *trag3;
WXDSTragectoryManager   *trag4;

WXDSTragectoryPatternManager	*tragPatterns;
}



-(id)		initWithObject:(WXDSNOISEone*)n;
-(void)		doStart;
-(void)		setControlAsMap:(int)type value:(int)value;
-(void)		initParameterForControlPitchPatterns;
-(void)		doControlPitchPatterns;

-(void)		doNoiseIntenseOne;
-(void)		initParameterForNoiseIntenseOne;


@end
