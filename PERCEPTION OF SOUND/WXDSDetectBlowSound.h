// *********************************************************************************************
//  WXDSDetectBlowSound
//  Created by Paul Webb on Thu Jan 12 2006.
// *********************************************************************************************


#import <Foundation/Foundation.h>
#import "WXDSRenderBase.h"
#import "WXDSSoundInputSystem.h"
#import "WXDSFastFourierTransform.h"
// *********************************************************************************************

@interface WXDSDetectBlowSound : WXDSRenderBase {

WXDSSoundInputSystem*		mySoundInputPointer;
AudioBufferList				*mInputBuffer;

//  spectrums
WXDSFastFourierTransform	*spectrums;
float						*theData;
float						theSpectrum[1000];
int							plots,quantize;

// loudness
float		sumStore[100];
int			loudIndex,maxLoudIndex;
float		currentTotal,meanFreq;
BOOL		storeFull,isWorking;

// blow analysis
float		currentSum[1000];
float		spectrumLevel[1000][20];
int			sumIndex[1000],maxIndex;
BOOL		sumLoop[1000];
float		blowSum;
float		blowLevel[20];
int			blowIndex;
BOOL		blowLoop;

id			plotterView;
id			loudPlotter;
}


-(void)		initAnalysisInformation;
-(void)		connectToSoundInput:(WXDSSoundInputSystem*)sis;
-(void)		setInputBufferPointer:(AudioBufferList*)inputBuffer;
-(void)		setConfidencePlot:(id)v;
-(void)		setLoudPlotter:(id)p;
-(float)	currentTotal;
-(float)	blowSum;
-(BOOL)		isWorking;

// *********************************************************************************************

@end
