// ************************************************************************************************
//  WXDSInstrumentPlucked
//  Created by Paul Webb on Sun Aug 14 2005.
// ************************************************************************************************
//    This class implements a simple plucked string
//    physical model based on the Karplus-Strong
//    algorithm.
// ************************************************************************************************

#import <Foundation/Foundation.h>
#import "WXDSInstrumentObjectBasic.h"
#import "WXFilterDelayA.h"
#import "WXFilterOneZero.h"
#import "WXFilterOnePole.h"
// ************************************************************************************************

@interface WXDSInstrumentPlucked : WXDSInstrumentObjectBasic {


WXFilterDelayA  *delayLine;
WXFilterOneZero *loopFilter;
WXFilterOnePole *pickFilter;

long length;
float loopGain;
float   lastOutput;
}

-(id)   initPlucked:(float)lowestFrequency;
-(void) clear;

@end
