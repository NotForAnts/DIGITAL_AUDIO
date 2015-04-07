// ***************************************************************************************
//  WXDSIntrumentBase
//  Created by Paul Webb on Wed Jan 12 2005.
// ***************************************************************************************
#import "WXDSIntrumentBase.h"


@implementation WXDSIntrumentBase
// ************************************************************************************************
-(id)		init
{
if(self=[super init])
	{
	int t;
	noteFrequency=220.0;
	delta1=noteFrequency*2.0*3.1415926535898/44100.0;
	masterGain=.3;
	currentFree=0;
	midiFreqConverter=[WXMusicMidiToFrequency sharedInstance];
	
	for(t=0;t<kMAXINSTRUMENTPOLY;t++)
		{
		freeIndexStore[t]=t;
		freePoly[t]=YES;
		theADSR[t]=[[WXDSAdsr alloc]init];
		}
	freePlace=0;
	}
return self;
}
// ************************************************************************************************
-(void)		dealloc
{
[theADSR[0] release];
[super dealloc];
}
// ************************************************************************************************
-(void)		keyOnWithGain:(float)gain
{
if((newChannel=[self getFreePoly])==-1) return;
[theADSR[newChannel] keyOnWithGain:gain/kMAXINSTRUMENTPOLY];
freePoly[newChannel]=NO;
}
// ************************************************************************************************
-(void)		keyOnWithReGainAndFrequency:(float)gain freq:(float)freq
{
if((newChannel=[self getFreePoly])==-1) return;
noteFrequency=freq;
[self doKeyOnExtra:newChannel freq:freq];
[theADSR[newChannel] keyOnWithReGain:gain/kMAXINSTRUMENTPOLY];
freePoly[newChannel]=NO;
printf("freq %f chan=%d\n",freq,newChannel);
}
// ************************************************************************************************
-(void)		keyOnWithGainAndFrequency:(float)gain freq:(float)freq
{
if((newChannel=[self getFreePoly])==-1) return;
noteFrequency=freq;
[self doKeyOnExtra:newChannel freq:freq];
[theADSR[newChannel] keyOnWithGain:gain/kMAXINSTRUMENTPOLY];
freePoly[newChannel]=NO;
printf("freq %f chan=%d\n",freq,newChannel);
}
// ************************************************************************************************
-(void)		keyOnWithGainFrequencyDuration:(float)gain freq:(float)freq dur:(float)duration
{
if((newChannel=[self getFreePoly])==-1) return;
noteFrequency=freq;
noteDuration=duration;
[self doKeyOnExtra:newChannel freq:freq];
[theADSR[newChannel] keyOnWithGainAndDuration:gain/kMAXINSTRUMENTPOLY dur:duration];
freePoly[newChannel]=NO;
}
// ************************************************************************************************
-(void)		keyOffForFreq:(float)freq
{
short t;
for(t=0;t<kMAXINSTRUMENTPOLY;t++)
	if(polyFreq[t]==freq)
		{
		[theADSR[t] keyOff];
		return;
		}
}
// ************************************************************************************************
-(void)		keyOnWithReGainMidi:(float)gain  midi:(short)midi
{
[self keyOnWithReGainAndFrequency:gain freq:[midiFreqConverter getMidiAsFreq:midi]];
}
// ************************************************************************************************
-(void)		keyOnWithGainMidi:(float)gain midi:(short)midi
{
[self keyOnWithGainAndFrequency:gain freq:[midiFreqConverter getMidiAsFreq:midi]];
}
// ************************************************************************************************
-(void)		keyOnWithGainMidiDuration:(float)gain midi:(short)midi dur:(float)duration
{
[self keyOnWithGainFrequencyDuration:gain freq:[midiFreqConverter getMidiAsFreq:midi] dur:duration];
}
// ************************************************************************************************
-(void)		keyOffForMidi:(short)midi
{
[self keyOffForFreq:[midiFreqConverter getMidiAsFreq:midi]];
}
// ************************************************************************************************
-(void)		keyOffAll
{
short t;
for(t=0;t<kMAXINSTRUMENTPOLY;t++)
	[theADSR[t] keyOff];
}
// ************************************************************************************************
-(void)		keyOffChannel:(short)channel
{
[theADSR[channel] keyOff];
}
// ************************************************************************************************
-(void)		keyOff
{
[theADSR[0] keyOff];
}
// ************************************************************************************************
// assuming all will use same adsr
// ************************************************************************************************
-(void)		setADSR:(float)alevel at:(float)atime dl:(float)dlevel dt:(float)dtime rl:(float)rlevel rt:(float)rtime
{
short t;
for(t=0;t<kMAXINSTRUMENTPOLY;t++)
	{
	[theADSR[t] setAttack:alevel time:atime];
	[theADSR[t] setDecay:dlevel time:dtime];
	[theADSR[t] setRelease:rlevel time:rtime];
	}
}
// ************************************************************************************************
-(short)	getFreePoly
{
currentFree++;
if(currentFree>=kMAXINSTRUMENTPOLY) currentFree=0;
freePoly[currentFree]=NO;
return currentFree;

int t;
for(t=0;t<kMAXINSTRUMENTPOLY;t++)
	if(freePoly[t])
		{
		return t;
		}
return -1;

short i;
if(freePlace>=kMAXINSTRUMENTPOLY) return -1;
i=freeIndexStore[freePlace];
freePlace++;
return i;
}
// ************************************************************************************************
-(void)		doKeyOffExtra:(short)channel
{
}
// ************************************************************************************************
-(void)		doKeyOnExtra:(short)channel freq:(float)freq
{
delta1=freq*2.0*3.1415926535898/44100.0;
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
	adsrGain=[theADSR[0] tick];
	leftSample=sin(degree1);
	*out1++ = leftSample*masterGain*adsrGain;
	*out2++ = leftSample*masterGain*adsrGain;
	degree1+=delta1;
	}
	
return noErr;
}
// ************************************************************************************************


@end
