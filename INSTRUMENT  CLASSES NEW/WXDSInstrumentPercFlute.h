// ******************************************************************************************
//  WXDSInstrumentPercFlute
//  Created by Paul Webb on Mon Aug 15 2005.
// ******************************************************************************************
//  percussive flute FM synthesis instrument.
//
//    This class implements algorithm 4 of the TX81Z.
//
//    code
//   Algorithm 4 is :   4->3--
//                          2-- + -->1-->Out
//   endcode
// ******************************************************************************************

#import <Foundation/Foundation.h>
#import "WXDSInstrumentFM.h"

// ******************************************************************************************

@interface WXDSInstrumentPercFlute : WXDSInstrumentFM {

float lastOutput;
}

// ******************************************************************************************


@end
