// ***************************************************************************************
//  WSDSInputLoudnessMonitor
//  Created by Paul Webb on Sun Jan 08 2006.
// ***************************************************************************************


#import <Foundation/Foundation.h>
#import "WXDSRenderBase.h"
#import "WXDSAudioRingBuffer.h"
#import "WXDSAudioDevice.h"
#import "WXDSSoundInputSystem.h"

// ***************************************************************************************

@interface WSDSInputLoudnessMonitor : WXDSRenderBase {

WXDSSoundInputSystem*		mySoundInputPointer;
AudioBufferList				*mInputBuffer;
WXDSAudioRingBuffer			*theRingBuffer;
WXDSAudioDevice				*mInputDevice,*mOutputDevice;

float		sumStore[100];
int			sumIndex,maxIndex;
float		currentTotal;
BOOL		storeFull;
BOOL		useMONO;

}

-(void)		connectToSoundInput:(WXDSSoundInputSystem*)sis;
-(void)		setInputBufferPointer:(AudioBufferList*)inputBuffer;
-(void)		setRingBufferPointer:(WXDSAudioRingBuffer*)ring;
-(void)		setInputDevice:(WXDSAudioDevice*)d;
-(void)		setOutDevice:(WXDSAudioDevice*)d;

-(float)	currentTotal;	

// ***************************************************************************************


@end
