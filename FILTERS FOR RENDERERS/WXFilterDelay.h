// ************************************************************************************************
//  WXFilterDelay
//  Created by Paul Webb on Wed Dec 29 2004.
// ************************************************************************************************

#import <Foundation/Foundation.h>
#import "WXFilter.h"

// ************************************************************************************************
@interface WXFilterDelay : WXFilter {

long inPoint;
long outPoint;
long length;
float delay;
}

-(id)   initDelay:(long)theDelay md:(long)maxDelay;

-(void)		clear;
-(void)		setDelay:(long)theDelay;
-(void)		setDelayNSO:(id)theDelay;
-(long)		getDelay;
-(float)	energy;
-(float)	contentsAt:(unsigned long)tapDelay;
-(float)	lastOut;
-(float)	nextOut;
-(float)	filter:(float)sample;


@end
