// ***************************************************************************************
//  WXDSInstrumentMoog
//  Created by Paul Webb on Mon Aug 15 2005.
// ***************************************************************************************
#import <Foundation/Foundation.h>
#import "WXDSInstrumentSampler.h"
#import "WXFilterSweepableFormant.h"

// ***************************************************************************************
@interface WXDSInstrumentMoog : WXDSInstrumentSampler {


WXFilterSweepableFormant *filters[2];
float modDepth;
float filterQ;
float filterRate;
}



// ************************************************************************************************

@end
