// ************************************************************************************************
//  WXDSAudioRingBuffer
//  Created by Paul Webb on Sun Jan 09 2005.
// ************************************************************************************************

#import "WXDSAudioRingBuffer.h"


@implementation WXDSAudioRingBuffer


// ************************************************************************************************
-(id)		init
{
if(self=[super init])
	{
	mBuffers=NULL; 
	mNumberChannels=0;
	mCapacityFrames=0; 
	mCapacityBytes=0;
	}
return self;
}

// ************************************************************************************************
-(UInt32) NextPowerOfTwo:(UInt32)value
{
UInt32 result = 1;
while (result < value) result <<= 1;
return result;
}
// ************************************************************************************************
-(void) ZeroRange:(Byte**)buffers nchannel:(int)nchannels offset:(int)offset nbytes:(int)nbytes
{
while (--nchannels >= 0) {
	memset(*buffers + offset, 0, nbytes);
	++buffers;
	}
}
// ************************************************************************************************
-(void) StoreABL:(Byte**)buffers destOffset:(int)destOffset abl:(AudioBufferList*)abl srcOffset:(int)srcOffset nbytes:(int)nbytes
{
int nchannels = abl->mNumberBuffers;
const AudioBuffer *src = abl->mBuffers;
while (--nchannels >= 0) {
	memcpy(*buffers + destOffset, (Byte *)src->mData + srcOffset, nbytes);
	++buffers;
	++src;
	}
}

// ************************************************************************************************
-(void)  FetchABL:(AudioBufferList*)abl destOffset:(int)destOffset buffers:(Byte**)buffers srcOffset:(int)srcOffset nbytes:(int)nbytes
{
int nchannels = abl->mNumberBuffers;
const AudioBuffer *dest = abl->mBuffers;
while (--nchannels >= 0) {
	memcpy((Byte *)dest->mData + destOffset, *buffers + srcOffset, nbytes);
	++buffers;
	++dest;
	}
}
// ************************************************************************************************
-(void)						Allocate:(int)nChannels bytesPerFrame:(UInt32)bytesPerFrame capacityFrames:(UInt32)capacityFrames
{
	[self Deallocate];
	UInt32 i;
	capacityFrames = [self NextPowerOfTwo:capacityFrames];
	
	mNumberChannels = nChannels;
	mBytesPerFrame = bytesPerFrame;
	mCapacityFrames = capacityFrames;
	mCapacityFramesMask = capacityFrames - 1;
	mCapacityBytes = bytesPerFrame * capacityFrames;

	// put everything in one memory allocation, first the pointers, then the deinterleaved channels
	Byte *p = (Byte *)malloc((mCapacityBytes + sizeof(Byte *)) * nChannels);
	mBuffers = (Byte **)p;
	p += nChannels * sizeof(Byte *);
	for (i = 0; i < nChannels; ++i) {
		mBuffers[i] = p;
		p += mCapacityBytes;
	}
	
	for (i = 0; i<kTimeBoundsQueueSize; ++i)
	{
		mTimeBoundsQueue[i].mStartTime=0;
		mTimeBoundsQueue[i].mEndTime=0;
		mTimeBoundsQueue[i].mUpdateCounter=0;
	}
	mTimeBoundsQueuePtr = 0;
}
// ************************************************************************************************
-(void)						Deallocate
{
if (mBuffers) {
	free(mBuffers);
	mBuffers = NULL;
}
mNumberChannels = 0;
mCapacityBytes = 0;
mCapacityFrames = 0;
}

// ************************************************************************************************
-(AudioRingBufferError)		Store:(AudioBufferList*)abl nFrames:(UInt32)framesToWrite frameNumber:(SampleTime)startWrite
{
if (framesToWrite > mCapacityFrames)
	return kAudioRingBufferError_TooMuch;		// too big!

SampleTime endWrite = startWrite + framesToWrite;
	
if (startWrite < [self EndTime]) {
		// going backwards, throw everything out
		[self SetTimeBounds:startWrite endTime:startWrite];
	} else if (endWrite - [self StartTime] <= mCapacityFrames) {
		// the buffer has not yet wrapped and will not need to
	} else {
		// advance the start time past the region we are about to overwrite
		SampleTime newStart = endWrite - mCapacityFrames;	// one buffer of time behind where we're writing
		SampleTime newEnd;// = std::max(newStart, [self EndTime]);
		newEnd=[self EndTime];
		if(newStart>newEnd) newEnd=newStart;
		[self SetTimeBounds:newStart endTime:newEnd];
	}
	
	// write the new frames
	Byte **buffers = mBuffers;
	int nchannels = mNumberChannels;
	int offset0, offset1, nbytes;
	SampleTime curEnd = [self EndTime];
	
	if (startWrite > curEnd) {
		// we are skipping some samples, so zero the range we are skipping
		offset0 = [self FrameOffset:curEnd];
		offset1 = [self FrameOffset:startWrite];
		if (offset0 < offset1)
			[self ZeroRange:buffers nchannel:nchannels offset:offset0 nbytes:offset1 - offset0];
		else {
			[self ZeroRange:buffers nchannel:nchannels offset:offset0 nbytes: mCapacityBytes - offset0];
			[self ZeroRange:buffers nchannel:nchannels offset:0 nbytes:offset1];
		}
		offset0 = offset1;
	} else {
		offset0 = [self FrameOffset:startWrite];
	}

	offset1 = [self FrameOffset:endWrite];
	if (offset0 < offset1)
		[self StoreABL:buffers destOffset:offset0 abl:abl srcOffset:0 nbytes:offset1 - offset0];
	else {
		nbytes = mCapacityBytes - offset0;
		[self StoreABL:buffers destOffset:offset0  abl:abl srcOffset:0 nbytes:nbytes];
		[self StoreABL:buffers destOffset:0 abl:abl srcOffset:nbytes nbytes:offset1];
	}
	
	// now update the end time
	[self SetTimeBounds:[self StartTime] endTime:endWrite];
	return true;	// success


}
// ************************************************************************************************
-(AudioRingBufferError)		Fetch:(AudioBufferList*)abl nFrames:(UInt32)nFrames frameNumber:(SampleTime)startRead
{
SampleTime endRead = startRead + nFrames;
AudioRingBufferError err;
	
err = [self CheckTimeBounds:startRead endRead:endRead];
if (err) return err;
	
Byte **buffers = mBuffers;
int offset0 = [self FrameOffset:startRead];
int offset1 = [self FrameOffset:endRead];
	
if (offset0 < offset1)
	[self FetchABL:abl destOffset:0 buffers:buffers srcOffset:offset0 nbytes:offset1 - offset0];
else {
	int nbytes = mCapacityBytes - offset0;
	[self FetchABL:abl destOffset:0 buffers:buffers srcOffset:offset0 nbytes:nbytes];
	[self FetchABL:abl destOffset:nbytes buffers:buffers srcOffset:0 nbytes:offset1];
}
return [self CheckTimeBounds:startRead endRead:endRead];
}
// ************************************************************************************************
-(AudioRingBufferError)		GetTimeBounds:(SampleTime*)startTime endTime:(SampleTime*)endTime
{
int i;
for (i=0; i<8; ++i) // fail after a few tries.
	{
	UInt32 curPtr = mTimeBoundsQueuePtr;
	UInt32 index = curPtr & kTimeBoundsQueueMask;
	TimeBounds* bounds = mTimeBoundsQueue + index;
		
	startTime = bounds->mStartTime;
	endTime = bounds->mEndTime;
	UInt32 newPtr = bounds->mUpdateCounter;
		
	if (newPtr == curPtr) 
			return kAudioRingBufferError_OK;
	}
return kAudioRingBufferError_CPUOverload;
}
// ************************************************************************************************
-(int)						FrameOffset:(SampleTime)frameNumber
{ 
return (frameNumber & mCapacityFramesMask) * mBytesPerFrame; 
}
// ************************************************************************************************
-(AudioRingBufferError)		CheckTimeBounds:(SampleTime)startRead endRead:(SampleTime)endRead
{
	SampleTime startTime, endTime;
	
	AudioRingBufferError err = [self GetTimeBounds:startTime endTime:endTime];
	if (err) return err;

	if (startRead < startTime)
	{
		if (endRead > endTime)
			return kAudioRingBufferError_TooMuch;
	
		if (endRead < startTime)
			return kAudioRingBufferError_WayBehind;
		else
			return kAudioRingBufferError_SlightlyBehind;
	}
	
	if (endRead > endTime)
	{
		if (startRead > endTime)
			return kAudioRingBufferError_WayAhead;
		else
			return kAudioRingBufferError_SlightlyAhead;
	}
	
	return kAudioRingBufferError_OK;	// success
}
// ************************************************************************************************
-(SampleTime)				StartTime
{
return mTimeBoundsQueue[mTimeBoundsQueuePtr & kTimeBoundsQueueMask].mStartTime;
}
// ************************************************************************************************
-(SampleTime)				EndTime
{ 
return mTimeBoundsQueue[mTimeBoundsQueuePtr & kTimeBoundsQueueMask].mEndTime; 
}
// ************************************************************************************************
-(void)						SetTimeBounds:(SampleTime)startTime endTime:(SampleTime)endTime
{
	UInt32 nextPtr = mTimeBoundsQueuePtr + 1;
	UInt32 index = nextPtr & kTimeBoundsQueueMask;
	
	mTimeBoundsQueue[index].mStartTime = startTime;
	mTimeBoundsQueue[index].mEndTime = endTime;
	mTimeBoundsQueue[index].mUpdateCounter = nextPtr;
	
	CompareAndSwap(mTimeBoundsQueuePtr, mTimeBoundsQueuePtr + 1, &mTimeBoundsQueuePtr);
}
// ************************************************************************************************



@end
