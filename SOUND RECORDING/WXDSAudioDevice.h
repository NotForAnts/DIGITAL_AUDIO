// ******************************************************************************************
//  WXDSAudioDevice
//  Created by Paul Webb on Sun Jan 09 2005.
// ******************************************************************************************
#import <Foundation/Foundation.h>
#import <CoreServices/CoreServices.h>
#import <CoreAudio/CoreAudio.h>
// ******************************************************************************************
@interface WXDSAudioDevice : NSObject {


AudioDeviceID					mID;
BOOL							mIsInput;
UInt32							mSafetyOffset;
UInt32							mBufferSizeFrames;
AudioStreamBasicDescription		mFormat;	
}


-(id)		initAudioDevice:(AudioDeviceID)devid isInput:(BOOL)isInput; 
-(void)		doInit:(AudioDeviceID)devid isInput:(BOOL)isInput; 
-(BOOL)		valid;
-(void)		SetBufferSize:(UInt32)size;
-(int)		CountChannels;
-(char*)	GetName:(char*)buf maxlen:(UInt32)maxlen;
-(AudioDeviceID*)	getmIDPointer;

-(UInt32)   mSafetyOffset;
-(UInt32)   mBufferSizeFrames;

@end
