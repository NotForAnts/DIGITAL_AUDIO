// ***************************************************************************************
//  WSDSStuckCompactDisc
//  Created by Paul Webb on Tue Nov 29 2005.
// ***************************************************************************************

#import "WSDSStuckCompactDisc.h"


@implementation WSDSStuckCompactDisc


// ************************************************************************************************
-(id)		initCompact:(int)size
{
if(self=[super init])
	{
	theRingBuffer=0;
	mInputBuffer=0;
	beAffected=NO;
	lockCompact=NO;
	isActive=NO;
	dataIndex=0;
	writeIndex=0;
	compactSize=size;
	useCompact=0;
	increment=0.5;
	repeatCount=0;
	masterGain=1.0;
	pitchShiftingActive=YES;
	changeChance=60;
	
	calcOne=[[WXFastCalcMExp alloc]initWave:5.0 loop:44100*WXURandomInteger(4,10)];		[calcOne setRanges:0.5 range2:1.0];
	calcTwo=[[WXFastCalcExp alloc]initWave:5.0 loop:44100*WXURandomInteger(1,4)];		[calcTwo setRanges:0.5 range2:1.0];
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goShiftDown:) name:@"compactDown" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goShiftUp:) name:@"compactUp" object:nil];
	}
return self;
}
// ************************************************************************************************
-(void)		setMidiPlayer:(WXCoreMidiPlayer*)player
{
midiPlayer=player;
}
// ************************************************************************************************ 
-(void)			goShiftUp:(NSNotification*)notification
 {
  if(!beAffected)	return;
 printf("go up\n");
 if(repeatCount<55) repeatCount=51;
 pitchShiftingActive=YES;
 canGoUp=YES;
 }
// ************************************************************************************************
-(void)			goShiftDown:(NSNotification*)notification
 {
 if(!beAffected)	return;
 printf("go down\n");
 repeatCount=101;
 pitchShiftingActive=YES;
 canGoDown=YES;
 }
// ************************************************************************************************
-(void)		setCanShift:(BOOL)b			{			pitchShiftingActive=b;			}
-(void)		setChangeChance:(int)c		{			changeChance=c;					}
-(void)		setLockCompact:(BOOL)b		{			lockCompact=b;					}
-(void)		setBeAffected:(BOOL)b		{			beAffected=b;					}
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

if(WXURandomInteger(0,10000)<changeChance && !lockCompact) writeIndex=0;
leftSample=0;

for (i=0; i<inNumFrames; ++i) 
	{
	if(writeIndex<compactSize)
		{
		dataCompact[1-useCompact][writeIndex]=*in1++;
		writeIndex++;
		if(writeIndex>=compactSize) 
			{
			useCompact=1-useCompact;
			increment=1.0;
			repeatCount=0;
			dataIndex=0;
			compactGain=0.5;//WXUFloatRandomBetween(0.1,0.6);
			pitchShiftingActive=NO;
			canGoDown=NO;
			canGoUp=NO;
			}
		}
	
	leftSample=dataCompact[useCompact][(int)dataIndex];
	dataIndex=dataIndex+increment;
	if(dataIndex>=compactSize-1) 
		{
		dataIndex=0;
		repeatCount++;
		if(pitchShiftingActive)
			{
			if(repeatCount>50 && repeatCount<100 && canGoUp) increment=increment*1.04;
			if(repeatCount>100 && canGoDown)  increment=increment*0.97;
			if(repeatCount>130 && !canGoDown) increment=increment*WXUFloatRandomBetween(0.998,1.02);
			}
		[midiPlayer midiNote:0 pitch:40 volume:127 duration:4000];		
		[midiPlayer midiNote:0 pitch:43 volume:127 duration:4000];	
		[midiPlayer midiNote:0 pitch:32 volume:127 duration:4000];		
		}

	leftSample*=masterGain;
	leftSample*=compactGain;
	

	
	*out1++ =leftSample;
	*out2++ =leftSample;
	}
		
return noErr;
}
// ************************************************************************************************

@end
