// ******************************************************************************************
//  WXDSFFTView
//  Created by Paul Webb on Fri Jan 07 2005.
// ******************************************************************************************
#import <Cocoa/Cocoa.h>
#import "WXUsefullCode.h"
#import "AudioToolBox/AUGraph.h"
#import "WXTimeWindowStore.h"
// ******************************************************************************************
@interface WXDSFFTView : NSView
{
BOOL	isActive,doRunningAverage;
float*  theData;
int		counter,plots,quantize,xgap;
float   xsize,ysize;
float	runningAverage,runningSum;
float   peaks[1000];
int		peakCount[1000];
int		resetPeakCount;

AudioBufferList *mInputBuffer;

WXTimeWindowStore		*timeWindow;
}

-(void)		analiserUpdate:(NSNotification *)notification;
-(void)		setActive:(BOOL)state;

// ******************************************************************************************

@end
