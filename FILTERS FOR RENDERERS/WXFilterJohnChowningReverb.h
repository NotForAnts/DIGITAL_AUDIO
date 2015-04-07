// ************************************************************************************************
//  WXFilterJohnChowningReverb
//  Created by Paul Webb on Wed Dec 29 2004.
// ************************************************************************************************
#import <Foundation/Foundation.h>
#import "WXFilterReverbBase.h"
#import "WXFilterDelay.h" 
// ************************************************************************************************
@interface WXFilterJohnChowningReverb : WXFilterReverbBase {

WXFilterDelay *allpassDelays[3];
WXFilterDelay *combDelays[4];
WXFilterDelay *outLeftDelay;
WXFilterDelay *outRightDelay;
float allpassCoefficient;
float combCoefficient[4];
}

-(id)		initFilter:(float)T60;  // T60 decay time argument.
-(void)		clear;
-(float)	filter:(float)input;


@end
