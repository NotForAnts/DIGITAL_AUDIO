// ************************************************************************************************
//  WXFilterDelayL
//  Created by Paul Webb on Wed Dec 29 2004.
// ************************************************************************************************
#import <Foundation/Foundation.h>
#import "WXFilterDelay.h"
// ************************************************************************************************

@interface WXFilterDelayL : WXFilterDelay {

float alpha;
float omAlpha;
float nextOutput;
BOOL doNextOut;
}


-(id)		initDelay:(long) theDelay md:(long)maxDelay;

-(void)		setDelay:(long)theDelay;
-(void)		setDelayNSO:(long)theDelay;
-(float)	getDelay;
-(float)	nextOut;
-(float)	filter:(float)sample;


@end
