// ************************************************************************************************
//  WXPitchShift
//  Created by Paul Webb on Thu Dec 30 2004.
// ************************************************************************************************
#import <Foundation/Foundation.h>
#include "WXFilterBasicDelayTap.h"
#import "WXFilterBase.h"
// ************************************************************************************************

@interface WXPitchShift : WXFilterBase {

WXFilterBasicDelayTap*	delayline1;
WXFilterBasicDelayTap*	delayline2;
float					delay1,delay2,rate,env1,env2,lastOutput,mixLevel;
}


-(void)	setMix:(float)v;
-(void) setShift:(float)shift;
-(float) filter:(float)input;

@end
