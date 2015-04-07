// ***************************************************************************************
//  WXDSDigitalPatternsOne
//  Created by Paul Webb on Sun Sep 18 2005.
// ***************************************************************************************


#import <Foundation/Foundation.h>
#import "WXDSRenderBase.h"

// ***************************************************************************************

@interface WXDSDigitalPatternsOne : WXDSRenderBase {

int		patternCount;
int		resetCount,resetEvery;
BOOL	doPanShift;

float   level,origPan,panShift;
double  degree2;
double  delta2,delta3,delta4,delta5;
double  deltaStart1,deltaStart2,deltaStart4;
float   gainLevel,patternMasterGain;

float   settings[20][10];

NSMutableString		*patterns[20];
NSMutableString		*accents[20];
int patternLength,currentPattern,patternIndex,patternSpeedRate;
}

-(void)		initPatterns;
-(void)		initParams;
-(void)		selectSound:(int)index gain:(float)gain;
-(void)		setDeltas:(float)d1 d2:(float)d2 d3:(float)d3 d4:(float)d4 d5:(float)d5 every:(int)every;

-(void)		setPatternGain:(float)g;
-(void)		setPatternSpeed:(int)v;
// ***************************************************************************************


@end
