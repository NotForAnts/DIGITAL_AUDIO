// ************************************************************************************************
//  WXFilterNReverb
//  Created by Paul Webb on Thu Dec 30 2004.
// ************************************************************************************************
#import <Foundation/Foundation.h>
#include "WXFilterReverbBase.h" 
#include "WXFilterDelay.h" 

// ************************************************************************************************
@interface WXFilterNReverb : WXFilterReverbBase {

WXFilterDelay *allpassDelays[8];
WXFilterDelay *combDelays[6];
	
float allpassCoefficient;
float combCoefficient[6];
float lowpassState;
}

-(id)		initFilter:(float)T60;
-(void)		clear;
-(float)	filter:(float)input;


@end
