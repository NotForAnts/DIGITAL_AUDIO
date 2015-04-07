// ******************************************************************************************
//  WXLowPass2
//  Created by Paul Webb on Thu Dec 30 2004.
// ******************************************************************************************
#import <Foundation/Foundation.h>
#import "WXFilterBase.h"
// ******************************************************************************************
@interface WXLowPass2 : WXFilterBase {

float*		tap;
float		s1,s2,xlast,ylast,output;
UInt32		delay,count,msize;
}


-(id)		initFilter:(UInt32)d a0:(float)a0 b1:(float)b1;
-(float)	filter:(float)input;
-(float)	filterFB:(float)input;

@end
