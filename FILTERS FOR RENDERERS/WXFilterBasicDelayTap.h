// ******************************************************************************************
//  WXFilterBasicDelayTap
//  Created by Paul Webb on Wed Dec 29 2004.
// ******************************************************************************************
#import <Foundation/Foundation.h>
#import "WXFilterBase.h"
// ******************************************************************************************
@interface WXFilterBasicDelayTap : WXFilterBase {

float*		tap;
float		feedback;
UInt32		delaylength,count,msize;
}

-(id)		initFilter:(UInt32)delay fb:(float)fb;
-(id)		initFilter:(UInt32)size delay:(UInt32)delay fb:(float)fb;

-(void) 	setDelay:(long)delay;
-(void) 	setDelayNSO:(id)delay;
-(float)	filter:(float)input;
-(float)    filterFB:(float)input;


@end
