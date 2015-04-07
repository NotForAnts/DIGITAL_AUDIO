// ***************************************************************************************
//  WXDSTragectoryManager
//  Created by Paul Webb on Mon Jul 18 2005.
// ***************************************************************************************
// WHAT IT DOES AND IS FOR
// a set of tragectories (calculator from v1...v2 in time t1...t2) can be placed together
// in series of over the top...The values are worked out by combining the values if several
// tragectory points collide (like in DRONE MACHINE)
//
// used for controlling parameters of things ... eg sound, sysex, graphics
//
// IT IS MOSTLY DESIGNED TO CONTINUALLY ADDED TRAGECTORIES IN REAL TIME
// as the processes are running
//
// but you can make up by adding trags before....just do a
// [trag setStartTimePointInterval:[NSDate timeIntervalSinceReferenceDate]];
//
// ALSO SEE WXDSTragectoryPatternManager - for making repeated patterns of simple to complex tragectories
//
// ***************************************************************************************
// INCLUDE THE CALCULATORS IN PROJECT !!
// to use
// trag1=[[WXDSTragectoryManager alloc]init];
//
//  then add tragectories someplace (Realtime) - add relative to current time (i.e d1,d2 are delay times)
//		[trag1 addRandom:20 v1:220 v2:400 d1:1 d2:20.0];
//
//  then in a fast all loop
//  if([trag1 update])  [generator setSomeParameter:[trag1 currentValue]];
//
//
//  adding is value and delay time relative to now and are in seconds
//  use [trag1 isEmpty] to see if its finished so can add more trags
//
//  if wish to do trag which follow from last value to new value use
//  [trag1 addLine:20 v1:[trag1 lastAddedValue] v2:destValue d1:1 d2:20.0];
//  [trag1 addLine:20 v1:[trag1  endValue] v2:destValue d1:1 d2:20.0];
//
//  endValue should be the very last value and is based on maintaining a
//  endTimeInterval - by adjust-comparing last interval added with this
// ***************************************************************************************

#import <Foundation/Foundation.h>
#import "WXDSTragectoryObject.h"
#import "WXUsefullCode.h"

// ***************************************************************************************
#import "WXCalculatorExponential.h"
#import "WXCalculatorExponentialMirror.h"
#import "WXCalculatorLog.h"
#import "WXCalculatorLogMirror.h"
#import "WXCalculatorRandomWalk.h"
#import "WXCalculatorSawWave.h"
#import "WXCalculatorSineWave.h"
#import "WXCalculatorSmoothSine.h"
#import "WXCalculatorSpikes.h"
#import "WXCalculatorsPINKNOISE.h"
#import "WXCalculatorSquareWave.h"
#import "WXCalculatorVariedSaw.h"
#import "WXCalculatorVariedTriangleWave.h"
#import "WXCalculatorRandomPeaks.h"
// ***************************************************************************************

@interface WXDSTragectoryManager : NSObject {

NSMutableArray  *tragectories;
float			currentValue;
float			lastAddedValue;
float			endValue;
float			lastAddedTime;
BOOL			wasUpdate;

NSTimeInterval  endTimeInterval;
NSTimeInterval  lastTimeInterval;
NSTimeInterval  startUpTimeInterval;
NSTimeInterval  createTimeInterval;

// for quick curve adds
WXDSTragectoryObject	*tragObject;
NSTimeInterval  interval,totalInterval;
float   value;

// calculator for it
WXCalculatorExponential					*expCalc;
WXCalculatorExponentialMirror			*expMCalc;
WXCalculatorLog							*logCalc;
WXCalculatorLogMirror					*logMCalc;
WXCalculatorRandomWalk					*rwCalc;
WXCalculatorSawWave						*sawCalc;
WXCalculatorSineWave					*sineCalc;
WXCalculatorSmoothSine					*smoothCalc;
WXCalculatorSpikes						*spikeCalc;
WXCalculatorsPINKNOISE					*pinkCalc;
WXCalculatorSquareWave					*squareCalc;
WXCalculatorVariedSaw					*vsawCalc;
WXCalculatorVariedTriangleWave			*vtriCalc;
WXCalculatorRandomPeaks					*rpeakCalc;
}

-(void)				setStartIsNow;
-(id)				currentValueNSO;
-(float)			currentValue;
-(float)			endValue;
-(void)				setEndValue:(float)v;
-(NSTimeInterval)   endTimeInterval;	
-(float)			lastAddedValue;
-(NSTimeInterval)   lastTimeInterval;
-(int)				getNumberTrags;	
-(BOOL)				isEmpty;	
-(BOOL)				isLess:(int)n;
-(BOOL)				doUpdate;
-(BOOL)				wasUpdateCP;
-(void)				makeCopyInto:(WXDSTragectoryManager*)dest;
-(NSTimeInterval)   findFirstTimeInterval;
-(void)				setTimeScale:(float)scale;
-(void)				setStartTimePointInterval:(NSTimeInterval)startTime;
-(void)				removeAllObjects;
-(void)				addObject:(id)anObject;
-(WXDSTragectoryObject*)	objectAtIndex:(unsigned)index;

-(void)		addLine:(int)number v1:(float)v1 v2:(float)v2 d1:(float)d1 d2:(float)d2;
-(void)		addFromCalc:(WXCalculatorBasic*)calc number:(int)number d1:(float)d1 d2:(float)d2;
-(void)		addRandom:(int)number v1:(float)v1 v2:(float)v2 d1:(float)d1 d2:(float)d2;
-(void)		addExp:(int)number v1:(float)v1 v2:(float)v2 d1:(float)d1 d2:(float)d2;
-(void)		addExpMirror:(int)number v1:(float)v1 v2:(float)v2 d1:(float)d1 d2:(float)d2;
-(void)		addLog:(int)number v1:(float)v1 v2:(float)v2 d1:(float)d1 d2:(float)d2;
-(void)		addLogMirror:(int)number v1:(float)v1 v2:(float)v2 d1:(float)d1 d2:(float)d2;
-(void)		addWalk:(int)number v1:(float)v1 v2:(float)v2 d1:(float)d1 d2:(float)d2;
-(void)		addSaw:(int)number v1:(float)v1 v2:(float)v2 d1:(float)d1 d2:(float)d2;
-(void)		addSine:(int)number v1:(float)v1 v2:(float)v2 d1:(float)d1 d2:(float)d2 deg1:(float)deg1 deg2:(float)deg2;
-(void)		addSmoothSine:(int)number v1:(float)v1 v2:(float)v2 d1:(float)d1 d2:(float)d2;
-(void)		addPink:(int)number v1:(float)v1 v2:(float)v2 d1:(float)d1 d2:(float)d2;
-(void)		addSquare:(int)number v1:(float)v1 v2:(float)v2 d1:(float)d1 d2:(float)d2;
-(void)		addPeak:(int)number v1:(float)v1 v2:(float)v2 d1:(float)d1 d2:(float)d2;

@end
