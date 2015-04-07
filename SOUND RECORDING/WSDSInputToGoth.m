// ***************************************************************************************
//  WSDSInputToGoth
//  Created by Paul Webb on Sat Jan 08 2005.
// ***************************************************************************************

#import "WSDSInputToGoth.h"


@implementation WSDSInputToGoth

// ************************************************************************************************
-(id)		init
{
if(self=[super init])
	{
	theRingBuffer=0;
	mInputBuffer=0;
	mFirstInputTime=0;
	
	spectrums=[[WXDSFastFourierTransform alloc]init];
	
	r1=[[WXFilterJohnChowningReverb alloc]initFilter:3.0];
	r2=[[WXFilterJohnChowningReverb alloc]initFilter:2.0];
	s1=[[WXPitchShift alloc]init];
	s2=[[WXPitchShift alloc]init];
	[s1 setShift:0.6];
	[s2 setShift:0.7];
	
	gothFilter=NO;
	}
return self;
}
// ************************************************************************************************
-(void)		pitchShift1:(float)v
{
[s1 setShift:v];
}
// ************************************************************************************************
-(void)		pitchShift2:(float)v
{
[s2 setShift:v];
}
// ************************************************************************************************
-(void)		filterActive:(BOOL)state;
{
gothFilter=state;
}
// ************************************************************************************************
-(void)		connectToSoundInput:(WXDSSoundInputSystem*)sis		
{   
mySoundInputPointer=sis;	
[self setInputBufferPointer:[mySoundInputPointer getBuffer]];
[self setRingBufferPointer:[mySoundInputPointer getRingBuffer]];
[self setInputDevice:[mySoundInputPointer getInputDevice]];
[self setOutDevice:[mySoundInputPointer getOutputDevice]];
}
// ************************************************************************************************
-(void)		setInputBufferPointer:(AudioBufferList*)inputBuffer {   mInputBuffer=inputBuffer;   }
-(void)		setRingBufferPointer:(WXDSAudioRingBuffer*)ring		{   theRingBuffer=ring;			}
-(void)		setInputDevice:(WXDSAudioDevice*)d					{   mInputDevice=d;				}
-(void)		setOutDevice:(WXDSAudioDevice*)d					{   mOutputDevice=d;			}
// ************************************************************************************************
// my version is basically copying the data
// ************************************************************************************************

-(OSStatus)		audioCallbackOnDevice:(AudioBufferList*)ioData bus:(UInt32)bus frame:(UInt32)inNumFrames time:(AudioTimeStamp*)timeStamp
{
if(!isActive) return [self RenderBlank:ioData bus:bus frame:inNumFrames];
if(mInputBuffer==0)  return [self RenderBlank:ioData bus:bus frame:inNumFrames];
UInt32 i;

if(NO)
	{
	//  quickway with memcpy
	memcpy(ioData->mBuffers[0].mData,mInputBuffer->mBuffers[0].mData, inNumFrames*4);	
	memcpy(ioData->mBuffers[1].mData,mInputBuffer->mBuffers[1].mData, inNumFrames*4);	
	return noErr;
	}
// ************************************************************************************************
// BYTE BY BYTE
// ************************************************************************************************
float* out1 =(float*)   ioData->mBuffers[0].mData;
float* out2 =(float*)   ioData->mBuffers[1].mData;
float* in1 =(float*)	mInputBuffer->mBuffers[0].mData;
float* in2 =(float*)	mInputBuffer->mBuffers[1].mData;


for (i=0; i<inNumFrames; ++i) 
	{
	leftSample=*in1++;
	rightSample=*in2++;
	
	
	
	if(gothFilter)
		{
	
		leftSample=[s1 filter:leftSample];
		leftSample=[r1 filter:leftSample];
	
		rightSample=[s2 filter:rightSample];
		rightSample=[r2 filter:rightSample];
		}
	
	*out1++ =leftSample;
	*out2++ =rightSample;
	
	//[spectrums filter:leftSample];
	}
		
return noErr;
// ************************************************************************************************
// FOR RING BUFFER - NOT USING THIS....OLD CODE
// ************************************************************************************************

if (mFirstInputTime < 0.) return -1;
//get Delta between the devices and add it to the offset
if (mFirstOutputTime < 0.) {
	mFirstOutputTime = timeStamp->mSampleTime;
	Float64 delta = (mFirstInputTime - mFirstOutputTime);
	
	mInToOutSampleOffset = (SInt32)([mInputDevice mSafetyOffset] +  [mInputDevice mBufferSizeFrames] +
						[mOutputDevice mSafetyOffset] + [mOutputDevice mBufferSizeFrames]);
	
	//changed: 3865519 11/10/04
	if (delta < 0.0)
		mInToOutSampleOffset -= delta;
	else
		mInToOutSampleOffset = -delta + mInToOutSampleOffset;
		
	return -1;
}

//copy the data from the buffer
[theRingBuffer Fetch:ioData nFrames:inNumFrames frameNumber:(SInt64)(timeStamp->mSampleTime - mInToOutSampleOffset)];	
return noErr;
}
// ************************************************************************************************

@end
