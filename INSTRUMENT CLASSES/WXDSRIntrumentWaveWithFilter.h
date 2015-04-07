// ***************************************************************************************
//  WXDSRIntrumentWaveWithFilter
//  Created by Paul Webb on Wed Jan 12 2005.
// ***************************************************************************************
#import <Foundation/Foundation.h>
#import "WXDSIntrumentBase.h"
#import "WXDSEnvelopeTableMaker.h"
#import "WXFilterJohnChowningReverb.h"
// ***************************************************************************************

@interface WXDSRIntrumentWaveWithFilter : WXDSIntrumentBase {


WXDSEnvelopeTableMaker  *waveTableMaker;
int						waveIndex[kMAXINSTRUMENTPOLY];;
int						waveIncrement[kMAXINSTRUMENTPOLY];
float*					soundWave;

WXFilterJohnChowningReverb*		reverb;


}

@end
