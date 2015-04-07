// *********************************************************************************************
//  WXDSDetectSalientFrequencyGestures
//  Created by veronica ibarra on 04/10/2006.
// *********************************************************************************************


#import <Cocoa/Cocoa.h>
#import "WXDSRenderBase.h"
#import "WXDSSoundInputSystem.h"
#import "WXDSFastFourierTransform.h"
#import "WXTimeWindowStore.h"
#import "TBMakeSalientTweet.h"
#import "WXDSSalientGestureObjectCollection.h"
// *********************************************************************************************

@interface WXDSDetectSalientFrequencyGestures : WXDSRenderBase {


WXDSSalientGestureObjectCollection	*gestureCollection;

NSMutableArray				*salientFreqArray;
NSMutableArray				*salientLevelArray;

WXDSSoundInputSystem*		mySoundInputPointer;
AudioBufferList				*mInputBuffer;
WXTimeWindowStore			*timeWindow;

// inform
id	informObject;
SEL	informSelector;


//  spectrums
WXDSFastFourierTransform	*spectrums;
float						*theData;
float						theSpectrum[1000];
int							plots,quantize,maxSize,gestureSize;


// salient spotting
int		salientInRow,failSalientCount,playIndex,currentFreqIndex,currentLevel;
BOOL	gotGesture,madeGesture,checkingFFT;

float						runningAverage,runningSum;
BOOL						doRunningAverage,wasUpdated;
}


-(void)		connectToSoundInput:(WXDSSoundInputSystem*)sis;
-(void)		setInputBufferPointer:(AudioBufferList*)inputBuffer;
-(void)		setObjectToInform:(id)anObject selector:(SEL)selector;
-(void)		backGroundThread;
-(void)		doCheckSalient;
-(void)		initAnalysisInformation;
-(void)		analiserUpdate:(NSNotification *)notification;

// *********************************************************************************************

@end
