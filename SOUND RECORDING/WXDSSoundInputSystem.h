// ******************************************************************************************
//  WXDSSoundInputSystem.h
//  Created by Paul Webb on Sun Jan 09 2005.
//
// sound recording is done by having a HAL outside the main augraph and sharing the data
// to another unit via things like RingBuffers or just the ioData pointer
//
// HOW THIS WORKS IS IT MAKES A SEPARATE AUHAL which is used for the sound input
// and this has its own callback which renders the sound input
//
// and to get to another renderer of mine (eg WXDSAudioInput ) in my WXDSAUGraph do a
// eg render2 whats to use the audio in
//
// [render2 setInputBufferPointer:[soundInputter getBuffer]];
// [render2 setRingBufferPointer:[soundInputter getRingBuffer]];
// [render2 setInputDevice:[soundInputter getInputDevice]];
// [render2 setOutDevice:[soundInputter getOutputDevice]];
//
// THE WXDSAudioRingBuffer does not work yet
//
// ******************************************************************************************
#import <Foundation/Foundation.h>
#import "AudioToolBox/AUGraph.h"
#import "WXDSAudioDevice.h"
#import "WXDSAudioRingBuffer.h"
// ******************************************************************************************

@interface WXDSSoundInputSystem : NSObject {

//  for the input from device such as MIC 
AudioUnit mInputUnit;
WXDSAudioDevice *mInputDevice, *mOutputDevice;
WXDSAudioRingBuffer *mBuffer;
AudioBufferList *mInputBuffer;

//Buffer sample info
Float64 mFirstInputTime;
Float64 mFirstOutputTime;
Float64 mInToOutSampleOffset;
BOOL	sendPlotter;
}

-(void)		start;
-(void)		stop;
-(void)		setPlotterNotify:(BOOL)state;

-(AudioBufferList*)		getBuffer;
-(WXDSAudioRingBuffer*) getRingBuffer;
-(WXDSAudioDevice*)		getInputDevice;
-(WXDSAudioDevice*)		getOutputDevice;


-(OSStatus) SetupAUHAL:(AudioDeviceID)inputDevice;
-(OSErr)	doRenderAudioIn:(AudioUnitRenderActionFlags*)ioActionFlags
										p2:(AudioTimeStamp*)inTimeStamp
										p3:(UInt32) inBusNumber
										p4:(UInt32) inNumFrames
										p5:(AudioBufferList*)ioData;


@end
