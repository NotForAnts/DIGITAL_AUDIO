// ***************************************************************************************
//  WSDSInputPitchShifted
//  Created by Paul Webb on Tue Nov 29 2005.
// ***************************************************************************************

// ***************************************************************************************
#import <Foundation/Foundation.h>
#import "WXDSRenderBase.h"
#import "WXDSAudioRingBuffer.h"
#import "WXDSAudioDevice.h"
#import "WXDSSoundInputSystem.h"
#import "WXFilterJohnChowningReverb.h"
#import "WXPitchShift.h"
#import "WXDSFastFourierTransform.h"

// ***************************************************************************************


@interface WSDSInputPitchShifted : WXDSRenderBase {

WXDSSoundInputSystem*		mySoundInputPointer;

AudioBufferList *mInputBuffer;
WXDSAudioRingBuffer *theRingBuffer;
WXDSAudioDevice *mInputDevice,*mOutputDevice;

//Buffer sample info
Float64 mFirstInputTime;
Float64 mFirstOutputTime;
Float64 mInToOutSampleOffset;

WXDSFastFourierTransform	*spectrums;


//filters
WXFilterJohnChowningReverb  *r1,*r2;
WXPitchShift *s1,*s2;

BOOL	gothFilter;

float   ringBufferLeft[88200];
float   ringBufferRight[88200];
int		ringBufferIndex,ringBufferSize,shiftState;
int		repeatRingIndex,repeatLastCount;
}

-(void)		doRepeatLast;
-(void)		filterActive:(BOOL)state;
-(void)		pitchShift1:(float)v;
-(void)		pitchShift2:(float)v;
-(void)		connectToSoundInput:(WXDSSoundInputSystem*)sis;
-(void)		setInputBufferPointer:(AudioBufferList*)inputBuffer;
-(void)		setRingBufferPointer:(WXDSAudioRingBuffer*)ring;
-(void)		setInputDevice:(WXDSAudioDevice*)d;
-(void)		setOutDevice:(WXDSAudioDevice*)d;

// ***************************************************************************************

@end
