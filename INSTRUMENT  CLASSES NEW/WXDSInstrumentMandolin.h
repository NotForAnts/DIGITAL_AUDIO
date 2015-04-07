// ***************************************************************************************
//  WXDSInstrumentMandolin
//  Created by Paul Webb on Sun Aug 14 2005.
// ***************************************************************************************

#import <Foundation/Foundation.h>
#import "WXDSInstrumentPluckTwo.h"
#import "WXDSWaveTable.h"
// ***************************************************************************************

@interface WXDSInstrumentMandolin : WXDSInstrumentPluckTwo {

WXDSWaveTable *soundfile[12];
float directBody;
int mic;
long dampTime;
bool waveDone;
float   lastOutput;
}

-(id)   initMandolin:(float)lowestFrequency;
-(void) pluck:(float)amplitude;
-(void) pluck:(float)amplitude  position:(float)position;
-(void) setBodySize:(float)size;
-(void) controlChange:(int)number value:(float)value;

@end
