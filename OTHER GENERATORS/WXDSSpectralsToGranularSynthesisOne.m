// ***************************************************************************************
//  WXDSSpectralsToGranularSynthesisOne
//  Created by Paul Webb on Mon Aug 01 2005.
// ***************************************************************************************

#import "WXDSSpectralsToGranularSynthesisOne.h"


@implementation WXDSSpectralsToGranularSynthesisOne


// ************************************************************************************************
-(id)		init
{
if(self=[super init])
	{
	spectrums=[[WXDSFastFourierTransform alloc]init];
	
	[self initialiseGrains];
	[self initialiseWaveTables];
	[self setRenderActive:YES];
	maxPeak=20.0;
	int t;
	for(t=0;t<512;t++)
		{
		freqValues[t]=WXULogNormalise(t,0,511,60,8000,50.0);;
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
// ***************************************************************************************
-(void) initialiseParameters
{
[self setGrainsPerSecondRange:1200 r2:1200];
[self setGrainFrequencyRange:50 f2:1110];
[self setGrainDurationAsSamples:300 r2:300];
[self setGrainGainRange:0.05 r2:0.5];
[self setGrainPanRange:0.0 r2:1.0];
[self setGrainWaveRange:0 r2:0];
[self setGrainEnvelopeRange:1 r2:1];
}
// ***************************************************************************************
-(void)		addGrainProcess
{
if(counter!=nextGrainAtCounter)		return;
nextGrainAtCounter+=WXURandomInteger(GPS2,GPS1); 


int freq,tries=0;

do
	{
	freq=WXURandomInteger(0,511);
	tries++;
	} while(tries<20 && peakLevels[freq]<1.0);

if(tries>=20)   return;

if(peakLevels[freq]>maxPeak)
	{
	maxPeak=peakLevels[freq];
	printf("freq %d %f\n",freq,peakLevels[freq]);
	}

//printf("freq %d %f\n",freq,peakLevels[freq]);

//useGain=peakLevels[freq]*peakLevels[freq];
//useGain=useGain/1000.0;

useDuration=250+peakLevels[freq]*30;
if(useDuration>500) useDuration=500;
useGain=peakLevels[freq];
useGain=useGain*useGain*useGain;
useGain=useGain/100000.0;

if(useGain>0.8) useGain=0.8;

int i=[self getFreeIndexAndUpdateGrainList];
if(i<0) return;
[grains[i] initGrain:freqValues[freq]
gain:useGain
pan:WXUFloatRandomBetween(pan1,pan2)
dur:useDuration
wave:grainWaves[WXURandomInteger(wave1,wave2)]
env:grainEnvelope[WXURandomInteger(envelope1,envelope2)]
index:i];

}
// ***************************************************************************************
-(OSStatus)		audioCallbackOnDevice:(AudioBufferList*)ioData bus:(UInt32)bus frame:(UInt32)inNumFrames time:(AudioTimeStamp*)timeStamp
{
if(!isActive) return [self RenderBlank:ioData bus:bus frame:inNumFrames];
if(mInputBuffer==0)  return [self RenderBlank:ioData bus:bus frame:inNumFrames];

UInt32 i;
float* out1 =(float*) ioData->mBuffers[0].mData;
float* out2 =(float*) ioData->mBuffers[1].mData;

[spectrums filterChunk:mInputBuffer->mBuffers[0].mData frame:inNumFrames];
peakLevels=[spectrums calculateBands];


for (i=0; i<inNumFrames; ++i) 
	{
	[self addGrainProcess];
	leftSample=0;
	rightSample=0;
	cGrain=activeGrainFirst;
	while(cGrain!=0)
		{
		[cGrain tick];
		[cGrain getLeftRight:&leftGrainSample right:&rightGrainSample];
		leftSample+=leftGrainSample;
		rightSample+=rightGrainSample;
		
		if([cGrain getCountDown]<1)
			{
			if(activeGrainFirst==cGrain) activeGrainFirst=[cGrain getNext];
			if(activeGrainLast==cGrain)  activeGrainLast=[cGrain getPrev];
			[cGrain removeSelfFromGrainList];
			if(freePlace>1)
				{
				freePlace--;
				freeIndexStore[freePlace]=[cGrain getIndex];
				}
			}
			
		cGrain=[cGrain getNext];
		}
	
	if(useFilter)
		{
		leftSample=[leftFilterSeries filter:leftSample];
		rightSample=[rightFilterSeries filter:rightSample];
		}
	
	*out1++ = leftSample*masterGain;
	*out2++ = rightSample*masterGain;
	counter++;
	}
	
	
return noErr;
}

// ***************************************************************************************

@end
