// ***************************************************************************************
//  WXDSSpectralsToGranularSynthesisOne
//  Created by Paul Webb on Mon Aug 01 2005.
// ***************************************************************************************

#import <Foundation/Foundation.h>
#import "WXDSGranularBasic.h"
#import "WXDSSoundInputSystem.h"
#import "WXDSFastFourierTransform.h"
#import "WXDSEnvelopeTableMaker.h"


// ***************************************************************************************

@interface WXDSSpectralsToGranularSynthesisOne : WXDSGranularBasic {

WXDSSoundInputSystem*		mySoundInputPointer;
AudioBufferList				*mInputBuffer;
WXDSFastFourierTransform	*spectrums;

int		useDuration;
float   *peakLevels;
float   freqValues[512];
float   maxPeak,useGain;
}


-(void)		connectToSoundInput:(WXDSSoundInputSystem*)sis;

@end
