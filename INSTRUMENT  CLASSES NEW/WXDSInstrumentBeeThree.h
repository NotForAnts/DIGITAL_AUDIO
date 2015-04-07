// ******************************************************************************************
//  WXDSInstrumentBeeThree
//  Created by Paul Webb on Mon Aug 15 2005.
// ******************************************************************************************
//Hammond-oid organ FM synthesis instrument.
//
//    This class implements a simple 4 operator
//    topology, also referred to as algorithm 8 of
//    the TX81Z.
// ******************************************************************************************

#import <Foundation/Foundation.h>
#import "WXDSInstrumentFM.h"


// ******************************************************************************************

@interface WXDSInstrumentBeeThree : WXDSInstrumentFM {

float lastOutput;
}

@end
