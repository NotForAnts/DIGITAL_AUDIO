// ************************************************************************************************
//  WXDSBasicAdditiveSynthesis
//  Created by Paul Webb on Tue Aug 02 2005.
// ************************************************************************************************
// DOES THE FOLLOWING
//
//  initUsingWave: type
//		type 1..5 are... sine, pulse, square, triangle, ramp
//
// up to N partials of wavetype can be mixed
// each partial has current freq and gain level
// each partial can go from f1...f2 in N steps
// each partial can go from g1...g2 in N steps
//
// to use as an Instrument will use a the delegated renderer for the instrument class
// (which still needs to be written)
// ************************************************************************************************

#import <Foundation/Foundation.h>
#import "WXDSRenderBase.h"
#import "WXDSEnvelopeTableMaker.h"

#define WXDSBasicAdditiveSynthesisMAXPARTIALS 64
// ************************************************************************************************

@interface WXDSBasicAdditiveSynthesis : WXDSRenderBase {

WXDSEnvelopeTableMaker  *waveTableMaker;
float		*waveTable;
float		waveTableSize;

int			numberPartials,waveTableSizeAsInteger;
int			tableIndex[WXDSBasicAdditiveSynthesisMAXPARTIALS];
int			tableIncrement[WXDSBasicAdditiveSynthesisMAXPARTIALS];
float		partialGain[WXDSBasicAdditiveSynthesisMAXPARTIALS];
float		partialFreq[WXDSBasicAdditiveSynthesisMAXPARTIALS];

float		partialFreqDelta[WXDSBasicAdditiveSynthesisMAXPARTIALS];
int			partialFreqCountDown[WXDSBasicAdditiveSynthesisMAXPARTIALS];
float		partialGainDelta[WXDSBasicAdditiveSynthesisMAXPARTIALS];
float		partialGainCountDown[WXDSBasicAdditiveSynthesisMAXPARTIALS];
}


-(id)		initUsingWave:(int)type;
-(void)		addPartial:(float)freq gain:(float)gain;
-(void)		setGainChange:(int)partial gain:(float)gain steps:(int)steps;
-(void)		setFreqChange:(int)partial freq:(float)freq steps:(int)steps;

// ************************************************************************************************

@end
