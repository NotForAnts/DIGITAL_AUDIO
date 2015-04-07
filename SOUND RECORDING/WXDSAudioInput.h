// ***************************************************************************************
//  WXDSAudioInput
//  Created by Paul Webb on Sat Jan 08 2005.
// ***************************************************************************************
// this is an example renderer of mine that can takes the audio data from the input (MIC)
// and then can render it out to the rest of the graph.
// it checks the data from the mInputBuffer which has the channels
// I am not doing in my quick memcpy version and checks for whether they have same number of
// frames by at moment the tests are working fine
//
// this example also shows how can put into through my own filter internally
// and get it to go into my spectrum analiser.
//
// USE THIS TO SUBCLASS IF WANT TO DO RT PROCESSING ON INPUT
// ***************************************************************************************
#import <Foundation/Foundation.h>
#import "WXDSRenderBase.h"
#import "WXDSAudioRingBuffer.h"
#import "WXDSAudioDevice.h"
#import "WXDSSoundInputSystem.h"
// ***************************************************************************************
@interface WXDSAudioInput : WXDSRenderBase {

WXDSSoundInputSystem*		mySoundInputPointer;

AudioBufferList *mInputBuffer;
WXDSAudioRingBuffer *theRingBuffer;
WXDSAudioDevice *mInputDevice,*mOutputDevice;

//Buffer sample info
Float64 mFirstInputTime;
Float64 mFirstOutputTime;
Float64 mInToOutSampleOffset;

}

-(void)		connectToSoundInput:(WXDSSoundInputSystem*)sis;
-(void)		setInputBufferPointer:(AudioBufferList*)inputBuffer;
-(void)		setRingBufferPointer:(WXDSAudioRingBuffer*)ring;
-(void)		setInputDevice:(WXDSAudioDevice*)d;
-(void)		setOutDevice:(WXDSAudioDevice*)d;
// ***************************************************************************************

@end
