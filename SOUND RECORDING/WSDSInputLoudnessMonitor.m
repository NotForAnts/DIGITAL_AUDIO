// ***************************************************************************************
//  WSDSInputLoudnessMonitor
//  Created by Paul Webb on Sun Jan 08 2006.
// ***************************************************************************************

#import "WSDSInputLoudnessMonitor.h"


@implementation WSDSInputLoudnessMonitor

// ************************************************************************************************
-(id)		init
{
if(self=[super init])
	{
	useMONO=YES;
	isActive=YES;
	theRingBuffer=0;
	mInputBuffer=0;
	//mFirstInputTime=0;
	
	sumIndex=0;
	currentTotal=0;
	maxIndex=100;
	storeFull=NO;
	}
return self;
}
// ************************************************************************************************
-(float)	currentTotal		{   return currentTotal/(((float)maxIndex));	}
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

float* in1 =(float*)	mInputBuffer->mBuffers[0].mData;
float* in2 =(float*)	mInputBuffer->mBuffers[1].mData;

// THIS IS USING INPUT 1

float   sum=0;
leftSample=0;
rightSample=0;

for (i=0; i<inNumFrames; ++i) 
	{
	if(!useMONO)
		{
		leftSample=*in1++;
		if(leftSample<0) leftSample*=-1;
		}
	
	rightSample=*in2++;
	if(rightSample<0) rightSample*=-1;
	
	sum=sum+leftSample+rightSample;
	}
	
currentTotal=currentTotal+sum;

if(storeFull)   currentTotal=currentTotal-sumStore[sumIndex];
sumStore[sumIndex]=sum;
sumIndex++;

if(sumIndex>=maxIndex) 
	{
	storeFull=YES;
	sumIndex=0;
	}

[self RenderBlank:ioData bus:bus frame:inNumFrames];	
		
return noErr;
}
// ************************************************************************************************

@end
