// ******************************************************************************************
//  WXFilterReverbBase
//  Created by Paul Webb on Thu Dec 30 2004.
// ******************************************************************************************
#import <Foundation/Foundation.h>
#import "WXFilterBase.h"
// ******************************************************************************************

@interface WXFilterReverbBase : WXFilterBase {

float lastOutput[2];
float effectMix;
}

-(void)		setEffectMix:(float)mix;
-(float)	lastOut;
-(float)	lastOutLeft;
-(float)	lastOutRight;
-(BOOL)		isPrime:(int)number;

@end
