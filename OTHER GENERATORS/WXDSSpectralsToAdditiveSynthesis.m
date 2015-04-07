// ***************************************************************************************
//  WXDSSpectralsToAdditiveSynthesis
//  Created by Paul Webb on Sun Jul 31 2005.
// ***************************************************************************************
#import "WXDSSpectralsToAdditiveSynthesis.h"


@implementation WXDSSpectralsToAdditiveSynthesis


// ************************************************************************************************
-(id)		init
{
if(self=[super init])
	{
	spectrums=[[WXDSFastFourierTransform alloc]init];
	
	waveTableMaker=[[WXDSEnvelopeTableMaker alloc]init];
	sineWave=[waveTableMaker makeSineWaveTable:44100 r1:-1.0 r2:1.0 freq:1.0];
	sineWave=[waveTableMaker makePulseTable:44100 r1:-1.0 r2:1.0 freq:20.0 pulsePercent:15];
	
	int t;
	float   freq=20;
	for(t=0;t<KMAXPARTIALS;t++)
		{
		currentSineLevel[t]=0.0;
		tableIndex[t]=0;
		tableIncrement[t]=WXULogNormalise(t,0,KMAXPARTIALS-1,40,2000,50.0);
		
		tableIncrement[t]=WXULogNormalise(t,0,KMAXPARTIALS-1,30,500,50.0);;//(int)freq;

		
		freq=freq*1.165;
		}
	}
return self;
}


// ************************************************************************************************
-(void)		connectToSoundInput:(WXDSSoundInputSystem*)sis		
{   
mySoundInputPointer=sis;	
mInputBuffer=[mySoundInputPointer getBuffer];
}
// ************************************************************************************************
-(OSStatus)		audioCallbackOnDevice:(AudioBufferList*)ioData bus:(UInt32)bus frame:(UInt32)inNumFrames time:(AudioTimeStamp*)timeStamp
{
if(!isActive) return [self RenderBlank:ioData bus:bus frame:inNumFrames];
if(mInputBuffer==0)  return [self RenderBlank:ioData bus:bus frame:inNumFrames];
UInt32 i;

float* out1 =(float*)   ioData->mBuffers[0].mData;
float* out2 =(float*)   ioData->mBuffers[1].mData;

[spectrums filterChunk:mInputBuffer->mBuffers[0].mData frame:inNumFrames];
peakLevels=[spectrums calculateBands];

// do the additive synthesis based on the levels
out1 =(float*)   ioData->mBuffers[0].mData;
out2 =(float*)   ioData->mBuffers[1].mData;
float   current;
int t;
float   v1,v2;
for(t=0;t<KMAXPARTIALS;t++)
	{
	peakLevel[t]=peakLevels[t*2+40]*0.1;
	//if(peakLevel[t]>1.0) peakLevel[t]=1.0;
	}

for (i=0; i<inNumFrames; ++i) 
	{
	v1=0;
	current=*out1; 
	current=0;
	for(t=0;t<KMAXPARTIALS;t++)
		{
		if(currentSineLevel[t]<peakLevel[t]) 
			{
			currentSineLevel[t]+=0.001;
			if(currentSineLevel[t]>peakLevel[t]) currentSineLevel[t]=peakLevel[t];
			}
		if(currentSineLevel[t]>peakLevel[t]) 
			{
			currentSineLevel[t]-=0.001;
			if(currentSineLevel[t]<peakLevel[t]) currentSineLevel[t]=peakLevel[t];
			}
		
		v1=v1+sineWave[tableIndex[t]]*currentSineLevel[t];
		tableIndex[t]=tableIndex[t]+tableIncrement[t];
		tableIndex[t]=(tableIndex[t] % 44100);
		//if(tableIndex[t] >= 44100) tableIndex[t]=tableIndex[t]-44100;
		}
		
	v1=v1/KMAXPARTIALS;
		
	*out1++ =v1+current;
	*out2++ =v1+current;	
	}

				
return noErr;
}
// ************************************************************************************************





@end
