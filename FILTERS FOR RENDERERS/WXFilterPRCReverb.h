// ************************************************************************************************
//  WXFilterPRCReverb
//  Created by Paul Webb on Thu Dec 30 2004.
// ************************************************************************************************
#import <Foundation/Foundation.h>
#import "WXFilterReverbBase.h" 
#import "WXFilterDelay.h" 
// ************************************************************************************************

@interface WXFilterPRCReverb : WXFilterReverbBase {

WXFilterDelay *allpassDelays[2];
WXFilterDelay *combDelays[2];
	
float allpassCoefficient;
float combCoefficient[2];
}

-(id)		initFilter:(float)T60;
-(void)		clear;
-(float)	filter:(float)input;


@end
