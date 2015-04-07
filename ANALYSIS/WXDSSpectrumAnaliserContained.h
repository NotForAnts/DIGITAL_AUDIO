// *********************************************************************************************
//  WXDSSpectrumAnaliserContained
//  Created by Paul Webb on Wed Jan 11 2006.
// *********************************************************************************************


#import <Foundation/Foundation.h>
#import "WXDSRenderBase.h"
#import "WXDSSoundInputSystem.h"
#import "WXDSFastFourierTransform.h"
// *********************************************************************************************

@interface WXDSSpectrumAnaliserContained : WXDSRenderBase {

BOOL						calculateDynamic;
BOOL						pitchMeanTest;
BOOL						playThru;
WXDSSoundInputSystem*		mySoundInputPointer;
AudioBufferList				*mInputBuffer;

//  spectrums
WXDSFastFourierTransform	*spectrums;
float						*theData;
float						theSpectrum[1000];
int							plots,quantize;

//  mean pitch
float						spectrumSums[1000];
int							pitchCounter,testModulas;
id		freqPlotter;
id		loudPlotter;

// loudness
float		sumStore[100];
int			sumIndex,maxIndex;
float		currentTotal,meanFreq;
BOOL		storeFull;

}

-(void)		initAnalysisInformation;
-(void)		connectToSoundInput:(WXDSSoundInputSystem*)sis;
-(void)		setInputBufferPointer:(AudioBufferList*)inputBuffer;
-(float)	currentTotal;
-(float)	meanFreq;
-(void)		doMeanPitchTesting;	
-(void)		setFreqPlotter:(id)p;
-(void)		setLoudPlotter:(id)p;
// *********************************************************************************************


@end
