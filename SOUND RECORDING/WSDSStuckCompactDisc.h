// ***************************************************************************************
//  WSDSStuckCompactDisc
//  Created by Paul Webb on Tue Nov 29 2005.
// ***************************************************************************************


#import <Foundation/Foundation.h>
#import "WXDSRenderBase.h"
#import "WXDSAudioRingBuffer.h"
#import "WXDSAudioDevice.h"
#import "WXDSSoundInputSystem.h"
#import "WXFastCalcMExp.h"
#import "WXFastCalcExp.h"
#import "WXCoreMidiPlayer.h"
// ***************************************************************************************

@interface WSDSStuckCompactDisc : WXDSRenderBase {

WXDSSoundInputSystem*		mySoundInputPointer;

AudioBufferList *mInputBuffer;
WXDSAudioRingBuffer *theRingBuffer;
WXDSAudioDevice *mInputDevice,*mOutputDevice;

BOOL		pitchShiftingActive;
BOOL		canGoUp;
BOOL		canGoDown,lockCompact;
BOOL		beAffected;
float		dataCompact[2][88200];
float		dataIndex,increment,compactGain,calcGain;
int			writeIndex,compactSize,useCompact,repeatCount,changeChance;


WXFastCalcMExp		*calcOne;
WXFastCalcExp		*calcTwo;
WXCoreMidiPlayer			*midiPlayer;
}

-(id)		initCompact:(int)size;
-(void)		connectToSoundInput:(WXDSSoundInputSystem*)sis;
-(void)		setInputBufferPointer:(AudioBufferList*)inputBuffer;
-(void)		setRingBufferPointer:(WXDSAudioRingBuffer*)ring;
-(void)		setInputDevice:(WXDSAudioDevice*)d;
-(void)		setOutDevice:(WXDSAudioDevice*)d;

-(void)		goShiftDown:(NSNotification*)notification;
-(void)		goShiftUp:(NSNotification*)notification;
-(void)		setCanShift:(BOOL)b;
-(void)		setChangeChance:(int)c;
-(void)		setLockCompact:(BOOL)b;
-(void)		setBeAffected:(BOOL)b;

// ***************************************************************************************


@end
