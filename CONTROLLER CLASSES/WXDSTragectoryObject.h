// ***************************************************************************************
//  WXDSTragectoryObject
//  Created by Paul Webb on Mon Jul 18 2005.
// ***************************************************************************************
// WXDSTragectoryObject is used by the WXDSTragectoryManager to create time based point values
// that can be used to control DSP parameters. Similar to the sys-ex controllers.
// they are for example an exponential, triangle, sinewave curve of N values held in an array
// the controller hold many of these - added to it by the instrument controller. The manager
// then checks it current time against the timepoint of each trag-object to see if an update of
// values is ready
//
//
// The timepoints are relative to ZERO and a startUpTimeInterval (since timeIntervalSinceReferenceDate )
// is used as the starting time point in the checking
// The WXDSTragectoryManager sets this when it adds objects in RT
// ***************************************************************************************


#import <Foundation/Foundation.h>


@interface WXDSTragectoryObject : NSObject {

NSTimeInterval		startUpTimeInterval;
NSMutableArray		*timepoints;
NSMutableArray		*values;
int					currentIndex,size;
float				currentValue,timeScale;
BOOL				isDone;
}

-(id)		deepCopy;
-(void)		shiftByTime:(NSTimeInterval)shift;
-(NSTimeInterval) getStartTimeInterval;
-(void)		setStartTimePointInterval:(NSTimeInterval)interval;
-(BOOL)		checkUpdate:(NSDate*)timepoint;
-(void)		addValue:(float)value atTime:(NSDate*)timepoint;
-(void)		setTimeScale:(float)scale;
-(float)	currentValue;
-(BOOL)		isDone;
-(int)		size;

@end
