// ***************************************************************************************
//  WSDSInputPitchShifted
//  Created by Paul Webb on Tue Nov 29 2005.
// ***************************************************************************************

#import "WSDSInputPitchShifted.h"


@implementation WSDSInputPitchShifted

// ************************************************************************************************
-(id)		init
{
if(self=[super init])
	{
	theRingBuffer=0;
	mInputBuffer=0;
	mFirstInputTime=0;
	
	spectrums=[[WXDSFastFourierTransform alloc]init];
	
	r1=[[WXFilterJohnChowningReverb alloc]initFilter:1.0];
	r2=[[WXFilterJohnChowningReverb alloc]initFilter:1.0];
	s1=[[WXPitchShift alloc]init];
	s2=[[WXPitchShift alloc]init];
	[s1 setShift:0.6];
	[s2 setShift:0.7];
	
	[r1 setEffectMix:0.5];
	[r2 setEffectMix:0.5];
	gothFilter=NO;
	ringBufferIndex=0;
	ringBufferSize=88200;
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
-(void)		doRepeatLast
{
if(repeatLastCount==0)
	repeatLastCount=1;
else
	repeatLastCount=0;
	
repeatRingIndex=ringBufferIndex;
//if(repeatLastCount==1) [[NSNotificationCenter defaultCenter]   postNotificationName:@"compactUp" object:self];
if(repeatLastCount==0) [[NSNotificationCenter defaultCenter]   postNotificationName:@"compactDown" object:self];
shiftState=1;
}
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
		
		if(gothFilter)
			{
			leftSample=[s1 filter:leftSample];
			leftSample=[r1 filter:leftSample];
			//rightSample=[s2 filter:rightSample];
			//rightSample=[r2 filter:rightSample];
			}
			
		rightSample=leftSample;	
		leftSample=leftSample*masterGain;	
		rightSample=rightSample*masterGain;
		
		if(repeatLastCount>0)
			{
			leftSample+=(ringBufferLeft[repeatRingIndex]*0.8);
			rightSample+=(ringBufferRight[repeatRingIndex]*0.5);
			repeatRingIndex++;
			if(repeatRingIndex>=ringBufferSize)
				{
				repeatRingIndex=0;
				if(shiftState==1)
					[[NSNotificationCenter defaultCenter]   postNotificationName:@"compactUp" object:self];
				else if(WXUPercentChance(50))
					[[NSNotificationCenter defaultCenter]   postNotificationName:@"compactDown" object:self];
				
			shiftState=1-shiftState;	
			}
		}	
	
	*out1++ =leftSample;
	*out2++ =rightSample;
	
	ringBufferLeft[ringBufferIndex]=leftSample;
	ringBufferRight[ringBufferIndex]=leftSample;
	ringBufferIndex++;
	if(ringBufferIndex>=ringBufferSize) 
		{
		ringBufferIndex=0;
		}
	
	//[spectrums filter:leftSample];
	}
		
return noErr;

}
// ************************************************************************************************

@end
