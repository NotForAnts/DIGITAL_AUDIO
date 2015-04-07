// ******************************************************************************************
//  WXDSInstrumentReedTable
//  Created by Paul Webb on Thu Aug 18 2005.
// ******************************************************************************************


#import <Foundation/Foundation.h>


@interface WXDSInstrumentReedTable : NSObject {

float offSet;
float slope;
float lastOutput;
}

-(id)   initReedTable;
-(void) setOffset:(float)aValue;
-(void) setSlope:(float)aValue;
-(float) lastOut;
-(float) tick:(float)input;

@end
