// ***************************************************************************************
//  WXDSWavePlotter
//  Created by Paul Webb on Sun Jan 09 2005.
// ***************************************************************************************
#import <Cocoa/Cocoa.h>
#import "WXUsefullCode.h"
#import "AudioToolBox/AUGraph.h"
#import "WXDSSoundInputSystem.h"
// ******************************************************************************************
@interface WXDSWavePlotter : NSView
{
short   style;
int		counter,xgap,waveSize,theStep,theUpdateFreq;
float   xsize,ysize;
BOOL	showCentre,showGraph;

AudioBufferList *mInputBuffer;
}

// ******************************************************************************************
-(void)		doPlotter:(NSNotification *)notification;
-(void)		setStep:(int)v;
-(void)		setUpdateFreq:(int)v;
-(void)		setStyle:(short)v gap:(int)g;

@end
