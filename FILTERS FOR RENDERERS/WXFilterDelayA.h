// ************************************************************************************************
//  WXFilterDelayA.h
//  Created by Paul Webb on Wed Dec 29 2004.
// ************************************************************************************************


#import <Foundation/Foundation.h>
#import "WXFilterDelay.h"

@interface WXFilterDelayA : WXFilterDelay {
	
float alpha;
float coeff;
float apInput;
float nextOutput;
BOOL doNextOut;
}

-(id)		initDelay:(long)theDelay md:(long) maxDelay;
-(void)		clear;
-(void)		setDelay:(long)theDelay;
-(void)		setDelayNSO:(long)theDelay;
-(float)	getDelay;
-(float)	nextOut;
-(float)	filter:(float)sample;

@end
