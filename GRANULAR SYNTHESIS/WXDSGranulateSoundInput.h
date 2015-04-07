// ***************************************************************************************
//  WXDSGranulateSoundInput
//  Created by Paul Webb on Tue Jan 11 2005.
// ***************************************************************************************
//  granular=[[BreatheGranularSynthesis alloc]init];
//  [granular initialiseWaveTables];
//  [granular initialiseGrains];
//  [granular connectToSoundInput:soundInputter];
// ***************************************************************************************

#import <Foundation/Foundation.h>
#import "WXDSGranularBasic.h"
#import "WXDSSoundInputSystem.h"
#import "WXDSInputGrain.h"
// ******************************************************************************************
@interface WXDSGranulateSoundInput : WXDSGranularBasic {

WXDSSoundInputSystem*		mySoundInputPointer;

AudioBufferList *mInputBuffer;
WXDSAudioRingBuffer *theRingBuffer;
WXDSAudioDevice *mInputDevice,*mOutputDevice;

//Buffer sample info
Float64 mFirstInputTime;
Float64 mFirstOutputTime;
Float64 mInToOutSampleOffset;

//input record buffers
float*  bufferRecordLeft,*bufferRecordRight;
int		bufferPosition,bufferSegments,bufferSize,cFrame,bufferFrame;
}

-(void)		connectToSoundInput:(WXDSSoundInputSystem*)sis;


// ******************************************************************************************

@end
