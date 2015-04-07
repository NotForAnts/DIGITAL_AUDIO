// ******************************************************************************************
//  WXCombFilterFeedBack
//  Created by Paul Webb on Wed Dec 29 2004.
// ******************************************************************************************
#import <Foundation/Foundation.h>
#import "WXFilterBase.h"
// ******************************************************************************************
@interface WXCombFilterFeedBack : WXFilterBase {

float*		tap;
float		strength;
UInt32		theDelay,count,msize;
}


-(id)		initComb:(UInt32)ms delay:(UInt32)d;
-(void)		setDelay:(long)delay;
-(void)		setFStrength:(float)s;	
-(void)		setDelayNSO:(id)delay;
-(void)		setFStrengthNSO:(id)s;
-(float)	filter:(float)input;
	


@end
