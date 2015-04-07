// ******************************************************************************************
//  WXDSAudioDevice
//  Created by Paul Webb on Sun Jan 09 2005.
// ******************************************************************************************

#import "WXDSAudioDevice.h"

// ******************************************************************************************
@implementation WXDSAudioDevice


// ******************************************************************************************
-(id)		init
{
if(self=[super init])
	{
	mID=kAudioDeviceUnknown;
	}
return self;
}
// ******************************************************************************************
-(id)		initAudioDevice:(AudioDeviceID)devid isInput:(BOOL)isInput
{
if(self=[super init])
	{
	[self doInit:devid isInput:isInput];
	}
return self;
}
// ******************************************************************************************
-(void)		doInit:(AudioDeviceID)devid isInput:(BOOL)isInput
{
mID = devid;
mIsInput = isInput;
if (mID == kAudioDeviceUnknown) return;
	
UInt32 propsize;
propsize = sizeof(UInt32);
verify_noerr(AudioDeviceGetProperty(mID, 0, mIsInput, kAudioDevicePropertySafetyOffset, &propsize, &mSafetyOffset));
	
propsize = sizeof(UInt32);
verify_noerr(AudioDeviceGetProperty(mID, 0, mIsInput, kAudioDevicePropertyBufferFrameSize, &propsize, &mBufferSizeFrames));
	
propsize = sizeof(AudioStreamBasicDescription);
verify_noerr(AudioDeviceGetProperty(mID, 0, mIsInput, kAudioDevicePropertyStreamFormat, &propsize, &mFormat));
}
// ******************************************************************************************
-(BOOL)		valid
{
return mID != kAudioDeviceUnknown; 
}
// ******************************************************************************************
-(void)		SetBufferSize:(UInt32)size
{
UInt32 propsize = sizeof(UInt32);
verify_noerr(AudioDeviceSetProperty(mID, NULL, 0, mIsInput, kAudioDevicePropertyBufferFrameSize, propsize, &size));

propsize = sizeof(UInt32);
verify_noerr(AudioDeviceGetProperty(mID, 0, mIsInput, kAudioDevicePropertyBufferFrameSize, &propsize, &mBufferSizeFrames));
}
// ******************************************************************************************
-(int)		CountChannels
{
OSStatus err;
UInt32 propSize,i;
int result = 0;
	
err = AudioDeviceGetPropertyInfo(mID, 0, mIsInput, kAudioDevicePropertyStreamConfiguration, &propSize, NULL);
if (err) return 0;

AudioBufferList *buflist = (AudioBufferList *)malloc(propSize);
err = AudioDeviceGetProperty(mID, 0, mIsInput, kAudioDevicePropertyStreamConfiguration, &propSize, buflist);
if (!err) {
	for (i = 0; i < buflist->mNumberBuffers; ++i) {
		result += buflist->mBuffers[i].mNumberChannels;
	}
}
free(buflist);
return result;
}
// ******************************************************************************************
-(UInt32)   mSafetyOffset		{		return mSafetyOffset;		}
-(UInt32)   mBufferSizeFrames   {		return mBufferSizeFrames;   }
// ******************************************************************************************
-(char*)	GetName:(char*)buf maxlen:(UInt32)maxlen;
{
verify_noerr(AudioDeviceGetProperty(mID, 0, mIsInput, kAudioDevicePropertyDeviceName, &maxlen, buf));
return buf;
}
// ******************************************************************************************
-(AudioDeviceID*)	getmIDPointer
{
return &mID;
}
// ******************************************************************************************
@end
