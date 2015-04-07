// ***************************************************************************************
//  WXDSGrainSlide
//  Created by Paul Webb on Thu Dec 30 2004.
// ***************************************************************************************
#import <Foundation/Foundation.h>
#import "WXDSGrain.h"
// ***************************************************************************************

@interface WXDSGrainSlide : WXDSGrain {

float   grainFreq1,grainFreq2,deltaFreq,waveIncrementFinal;
}


-(void)			initSlideGrain:(float)freq freq2:(float)freq2 gain:(float)g pan:(float)pan dur:(int)dur wave:(float*)wp env:(float*)ep index:(int)i;



@end
