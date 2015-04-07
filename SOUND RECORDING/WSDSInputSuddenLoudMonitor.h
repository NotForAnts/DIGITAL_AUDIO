// ***************************************************************************************
//  WSDSInputSuddenLoudMonitor
//  Created by veronica ibarra on 04/10/2006.
// ***************************************************************************************


#import <Cocoa/Cocoa.h>
#import "WSDSInputLoudnessMonitor.h"
#import "WXTimeWindowStore.h"
// ***************************************************************************************

@interface WSDSInputSuddenLoudMonitor : WSDSInputLoudnessMonitor {

BOOL					isActive,doneFirstUpdate;
WXTimeWindowStore		*timeWindow;
long					currentTime;
float					currentAverage,gainConstant;
int						counter;
}


-(void)		startThread;
-(void)		backGroundThread;
-(void)		setLoudDangerLevel:(float)level;

// ***************************************************************************************


@end
