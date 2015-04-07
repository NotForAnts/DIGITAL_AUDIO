// ***************************************************************************************
//  WXDSSpectralsToAdditiveSynthesis
//  Created by Paul Webb on Sun Jul 31 2005.
// ***************************************************************************************
//  this used the sound inputter into spectrum analiser then
//  creates additive synthesis based on values of the spectrum
//
// the WXDSSoundInputSystem is created outside this object (same place as augraph)
// so that it can be used by other objects that need sound input.
// the spectrum analiser is created by this object although if was using lots of similar
// objects it would be better to use one spectrum analiser
//
// ***************************************************************************************


#import <Foundation/Foundation.h>
#import "WXDSRenderBase.h"
#import "WXDSSoundInputSystem.h"
#import "WXDSFastFourierTransform.h"
#import "WXDSEnvelopeTableMaker.h"

// ***************************************************************************************
#define		KMAXPARTIALS 40

// ***************************************************************************************

@interface WXDSSpectralsToAdditiveSynthesis : WXDSRenderBase {

WXDSSoundInputSystem*		mySoundInputPointer;
AudioBufferList				*mInputBuffer;
WXDSFastFourierTransform	*spectrums;
float   *peakLevels;


//  for additive synthesis
WXDSEnvelopeTableMaker  *waveTableMaker;
float   *sineWave;

float   currentSineLevel[KMAXPARTIALS],peakLevel[KMAXPARTIALS];
int		tableIndex[KMAXPARTIALS], tableIncrement[KMAXPARTIALS];
}


-(void)		connectToSoundInput:(WXDSSoundInputSystem*)sis;

		

@end
