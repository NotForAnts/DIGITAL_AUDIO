// ***************************************************************************************
//  WXDSRIntrumentWaveWithFilter
//  Created by Paul Webb on Wed Jan 12 2005.
// ***************************************************************************************

#import "WXDSRIntrumentWaveWithFilter.h"


// ***************************************************************************************
@implementation WXDSRIntrumentWaveWithFilter


// ************************************************************************************************
-(id)		init
{
if(self=[super init])
	{
	noteFrequency=220.0;
	delta1=noteFrequency*2.0*3.1415926535898/44100.0;
	waveTableMaker=[[WXDSEnvelopeTableMaker alloc]init];
	
	//soundWave=[waveTableMaker makeRampTable:44100 freq:@"1,3" amp:@"1,1" r1:-1.0 r2:1.0];
	soundWave=[waveTableMaker makeSineWaveTable:44100 r1:-1.0 r2:1.0 freq:1.0];
	
	reverb=[[WXFilterJohnChowningReverb alloc]initFilter:11.0];
	
	[self setADSR:1.0 at:0.2 dl:0.9 dt:1.0 rl:0.0 rt:1.0];	
	}
return self;
}
// ************************************************************************************************
-(void)		dealloc
{
free(soundWave);
[waveTableMaker release];
[super dealloc];
}
// ************************************************************************************************
-(void)		doKeyOffExtra:(short)channel
{
}
// ************************************************************************************************
-(void)		doKeyOnExtra:(short)channel freq:(float)freq
{
waveIndex[channel]=0;
waveIncrement[channel]=freq;
}
// ************************************************************************************************
-(OSStatus)		audioCallbackOnDevice:(AudioBufferList*)ioData bus:(UInt32)bus frame:(UInt32)inNumFrames time:(AudioTimeStamp*)timeStamp
{

if(!isActive) return [self RenderBlank:ioData bus:bus frame:inNumFrames];
UInt32 i;
int t;
float* out1 =(float*) ioData->mBuffers[0].mData;
float* out2 =(float*) ioData->mBuffers[1].mData;
float v;

for (i=0; i<inNumFrames; ++i) 
	{
	leftSample=0;
	for(t=0;t<kMAXINSTRUMENTPOLY;t++)
		if(!freePoly[t])
			{
			v=soundWave[waveIndex[t]];
			adsrGain=[theADSR[t] tick];
			v*=adsrGain;
			leftSample+=v;
			waveIndex[t]+=waveIncrement[t];
			if(waveIndex[t]>=44100) waveIndex[t]=waveIndex[t]-44100;
			
			if([theADSR[t] hasFinished]) 
				{
				freePoly[t]=YES;
				}
			}
			
	leftSample=[reverb filter:leftSample];
	
	
	*out1++ = leftSample*masterGain;
	*out2++ = leftSample*masterGain;
	}
	
return noErr;
}
// ************************************************************************************************




@end
