// ***************************************************************************************
//  WXDSInstrumentBowTable
//  Created by Paul Webb on Mon Aug 15 2005.
// ***************************************************************************************
//    This class implements a simple bowed string
//    non-linear function, as described by Smith (1986).
// ***************************************************************************************


#import <Foundation/Foundation.h>


@interface WXDSInstrumentBowTable : NSObject {

float offSet;
float slope;
float lastOutput;
}


-(void) setOffset:(float)aValue;
-(void) setSlope:(float)aValue;
-(float) lastOut;
-(float) tick:(float)input;

@end
