// ************************************************************************************************
//  WXDSAudioRingBuffer
//  Created by Paul Webb on Sun Jan 09 2005.
// ************************************************************************************************
#import <Foundation/Foundation.h>
#import <CoreAudio/CoreAudioTypes.h>
// ************************************************************************************************
#ifndef __WXDSAudioRingBuffer___
#define __WXDSAudioRingBuffer___

enum {
	kAudioRingBufferError_WayBehind = -2, // both fetch times are earlier than buffer start time
	kAudioRingBufferError_SlightlyBehind = -1, // fetch start time is earlier than buffer start time (fetch end time OK)
	kAudioRingBufferError_OK = 0,
	kAudioRingBufferError_SlightlyAhead = 1, // fetch end time is later than buffer end time (fetch start time OK)
	kAudioRingBufferError_WayAhead = 2, // both fetch times are later than buffer end time
	kAudioRingBufferError_TooMuch = 3, // fetch start time is earlier than buffer start time and fetch end time is later than buffer end time
	kAudioRingBufferError_CPUOverload = 4 // the reader is unable to get enough CPU cycles to capture a consistent snapshot of the time bounds
};


typedef SInt32 AudioRingBufferError;
#define  kTimeBoundsQueueSize 32
#define  kTimeBoundsQueueMask kTimeBoundsQueueSize - 1

//typedef SInt64 SampleTime;

typedef struct {
	volatile SInt64		mStartTime;
	volatile SInt64		mEndTime;
	volatile UInt32		mUpdateCounter;
} TimeBounds;	



#define  SampleTime SInt64


#endif

// make as kTimeBoundsQueueSize - 1;
// ************************************************************************************************


@interface WXDSAudioRingBuffer : NSObject {


Byte **		mBuffers;				// allocated in one chunk of memory
int			mNumberChannels;
UInt32		mBytesPerFrame;			// within one deinterleaved channel
UInt32		mCapacityFrames;		// per channel, must be a power of 2
UInt32		mCapacityFramesMask;
UInt32		mCapacityBytes;			// per channel
	
// range of valid sample time in the buffer
//typedef struct {
//	volatile SampleTime		mStartTime;
//	volatile SampleTime		mEndTime;
//	volatile UInt32			mUpdateCounter;
//} TimeBounds;	


TimeBounds mTimeBoundsQueue[kTimeBoundsQueueSize];

// paul says i have separated out this struct
//volatile SampleTime mTimeBoundsQueue_mStartTime[kTimeBoundsQueueSize];
//volatile SampleTime mTimeBoundsQueue_mEndTime[kTimeBoundsQueueSize];
//volatile UInt32		mTimeBoundsQueue_mUpdateCounter[kTimeBoundsQueueSize];

UInt32 mTimeBoundsQueuePtr;

}

-(UInt32)   NextPowerOfTwo:(UInt32)value;
-(void)		ZeroRange:(Byte**)buffers nchannel:(int)nchannels offset:(int)offset nbytes:(int)nbytes;
-(void)		StoreABL:(Byte**)buffers destOffset:(int)destOffset abl:(AudioBufferList*)abl srcOffset:(int)srcOffset nbytes:(int)nbytes;

-(void)						Allocate:(int)nChannels bytesPerFrame:(UInt32)bytesPerFrame capacityFrames:(UInt32)capacityFrames;
							// capacityFrames will be rounded up to a power of 2
-(void)						Deallocate;

-(AudioRingBufferError)		Store:(AudioBufferList*)abl nFrames:(UInt32)framesToWrite frameNumber:(SampleTime)startWrite;
							// Copy nFrames of data into the ring buffer at the specified sample time.
							// The sample time should normally increase sequentially, though gaps
							// are filled with zeroes. A sufficiently large gap effectively empties
							// the buffer before storing the new data. 
							
							// If frameNumber is less than the previous frame number, the behavior is undefined.
							
							// Return false for failure (buffer not large enough).
				
-(AudioRingBufferError)		Fetch:(AudioBufferList*)abl nFrames:(UInt32)nFrames frameNumber:(SampleTime)frameNumber;
		
-(AudioRingBufferError)		GetTimeBounds:(SampleTime*)startTime endTime:(SampleTime*)endTime;

//protected
-(int)						FrameOffset:(SampleTime)frameNumber;// { return (frameNumber & mCapacityFramesMask) * mBytesPerFrame; }
-(AudioRingBufferError)		CheckTimeBounds:(SampleTime)startRead endRead:(SampleTime)endRead;
	
// these should only be called from Store.
-(SampleTime)				StartTime;// const { return mTimeBoundsQueue[mTimeBoundsQueuePtr & kTimeBoundsQueueMask].mStartTime; }
-(SampleTime)				EndTime;//  const { return mTimeBoundsQueue[mTimeBoundsQueuePtr & kTimeBoundsQueueMask].mEndTime; }
-(void)						SetTimeBounds:(SampleTime)startTime endTime:(SampleTime)endTime;

@end
