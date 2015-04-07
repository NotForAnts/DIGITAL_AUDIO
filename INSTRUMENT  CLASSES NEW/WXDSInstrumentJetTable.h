// ******************************************************************************************
//  WXDSInstrumentJetTable
//  Created by Paul Webb on Thu Aug 18 2005.
// ******************************************************************************************
//  This class implements a flue jet non-linear
//  function, computed by a polynomial calculation.
//  Contrary to the name, this is not a "table".
//  Consult Fletcher and Rossing, Karjalainen,
//  Cook, and others for more information.
// ******************************************************************************************
#import <Foundation/Foundation.h>

// ******************************************************************************************

@interface WXDSInstrumentJetTable : NSObject {

float lastOutput;
}

-(float) lastOut;
-(float) tick:(float)input;

@end
