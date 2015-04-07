// ***************************************************************************************
//  WXDSInstrumentObjectBasic
//  Created by Paul Webb on Sat Aug 13 2005.
// ***************************************************************************************

#import "WXDSInstrumentObjectBasic.h"


@implementation WXDSInstrumentObjectBasic

// ************************************************************************************************
-(id)		init
{
if(self=[super init])
	{
	adsrGain=0.0;
	noteFrequency=220.0;
	delta1=noteFrequency*2.0*3.1415926535898/44100.0;
	masterGain=.3;
	midiFreqConverter=[WXMusicMidiToFrequency sharedInstance];
	envelope=[[WXDSInstrumentEnvelopeBase alloc]init];
	}
return self;
}
// ************************************************************************************************
-(void)		dealloc
{
[envelope release];
[midiFreqConverter release];
[super dealloc];
}
// ************************************************************************************************
-(void)		setFrequency:(float)freq
{
}
// ************************************************************************************************
-(void)		doKeyOnExtra:(float)freq
{
}
// ************************************************************************************************
-(void)		keyOnWithGainFrequencyDuration:(float)freq gain:(float)gain duration:(float)duration
{
noteFrequency=freq;
[self setFrequency:noteFrequency];
[envelope keyOnWithGainAndDuration:gain dur:duration];
[self doKeyOnExtra:freq];
}
// ************************************************************************************************
-(void)		keyONWithReGainAndFrequency:(float)freq gain:(float)gain
{
noteFrequency=freq;
[self setFrequency:noteFrequency];
[envelope keyOnWithReGain:gain];
[self doKeyOnExtra:freq];
}
// ************************************************************************************************
-(void) keyONWithFreqGain:(float)freq gain:(float)gain
{
noteFrequency=freq;
[self setFrequency:noteFrequency];
[envelope keyOnWithGain:gain];
[self doKeyOnExtra:freq];
}
// ************************************************************************************************
-(void) keyOFF
{
[envelope keyOff];
}
// ************************************************************************************************
-(OSStatus)		audioCallbackOnDevice:(AudioBufferList*)ioData bus:(UInt32)bus frame:(UInt32)inNumFrames time:(AudioTimeStamp*)timeStamp
{
if(!isActive) return [self RenderBlank:ioData bus:bus frame:inNumFrames];
UInt32 i;
float* out1 =(float*) ioData->mBuffers[0].mData;
float* out2 =(float*) ioData->mBuffers[1].mData;

for (i=0; i<inNumFrames; ++i) 
	{
	adsrGain=[envelope tick];
	
	leftSample=sin(degree1);
	*out1++ = leftSample*masterGain*panRight*adsrGain;
	*out2++ = leftSample*masterGain*panLeft*adsrGain;
	degree1+=delta1;
	}
	
return noErr;
}
// ************************************************************************************************



@end
