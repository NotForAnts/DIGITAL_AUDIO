// ******************************************************************************************
//  WXReverbComb
//  Created by Paul Webb on Thu Dec 30 2004.
//
//  REVERB WITH upto 10 delays
//
// as the sound quality depends on the mix of delay lengths and strengths I need to find
// them manually and have options for set type
// ******************************************************************************************
#import <Foundation/Foundation.h>
#import "WXFilterBase.h"
// ******************************************************************************************
@interface WXReverbComb : WXFilterBase {

float*		tap;
float		output,strength[10],reverbtotal;
UInt32		delay[10],count,msize;
}


-(float)	filter:(float)input;
-(void)		setType1;

@end
