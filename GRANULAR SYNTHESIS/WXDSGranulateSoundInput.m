// ***************************************************************************************
//  WXDSGranulateSoundInput
//  Created by Paul Webb on Tue Jan 11 2005.
// ***************************************************************************************
#import "WXDSGranulateSoundInput.h"

@implementation WXDSGranulateSoundInput

// ***************************************************************************************
-(id)		init
{
if(self=[super init])
	{
	bufferSegments=(4.0*44100.0)/512;
	bufferSegments=(bufferSegments+1);
	printf("segments %d\n",bufferSegments);
	
	bufferSize=bufferSegments*512;
	bufferRecordLeft=malloc(bufferSize*sizeof(float));
	bufferRecordRight=malloc(bufferSize*sizeof(float));
	bufferPosition=0;
	}
return self;
}
// ***************************************************************************************
-(void) dealloc
{
free(bufferRecordLeft);
free(bufferRecordRight);
[super dealloc];
}
// ***************************************************************************************
-(void) initialiseParameters
{
[self setGrainsPerSecondRange:10 r2:315];
[self setGrainFrequencyRange:0.25 f2:1.3];
[self setGrainDurationAsSamples:100 r2:6500];
[self setGrainGainRange:0.2 r2:0.4];
[self setGrainPanRange:0.1 r2:0.9];
[self setGrainWaveRange:0 r2:0];
[self setGrainEnvelopeRange:0 r2:3];
}
// ************************************************************************************************
-(void)		connectToSoundInput:(WXDSSoundInputSystem*)sis		
{   
mySoundInputPointer=sis;	
mInputBuffer=[mySoundInputPointer getBuffer];
theRingBuffer=[mySoundInputPointer getRingBuffer];
mInputDevice=[mySoundInputPointer getInputDevice];
mOutputDevice=[mySoundInputPointer getOutputDevice];
}
// ***************************************************************************************
-(void)		initialiseGrains
{
int t;
for(t=0;t<WXDSGranularBasicMaxGrains;t++)
	{
	freeIndexStore[t]=t;	
	grains[t]=[[WXDSInputGrain alloc]init];
	[grains[t] setInputBuffers:bufferRecordLeft right:bufferRecordRight size:bufferSize];
	[grains[t] setPositions:0 pos2:bufferSize/4]; // 4 is minimum for safe side
	grainAddIndex++;
	}
freePlace=0;	
activeGrainFirst=0;
activeGrainLast=0;
}
// ***************************************************************************************
-(void)		addGrainProcess
{
if(counter!=nextGrainAtCounter)		return;
nextGrainAtCounter+=WXURandomInteger(GPS2,GPS1); 
int i=[self getFreeIndexAndUpdateGrainList];
if(i<0) return;

//[grains[i] initGrain:
[grains[i] initGrain:
WXUFloatRandomBetween(grainFreq1,grainFreq2)
gain:WXUFloatRandomBetween(gain1,gain2)
pan:WXUFloatRandomBetween(pan1,pan2)
dur:WXURandomInteger(duration1,duration2)
wave:grainWaves[WXURandomInteger(wave1,wave2)]
env:grainEnvelope[WXURandomInteger(envelope1,envelope2)]
index:i];

[grains[i] setBufferPosition:cFrame+bufferFrame channel:0];
}
// ***************************************************************************************
-(OSStatus)		audioCallbackOnDevice:(AudioBufferList*)ioData bus:(UInt32)bus frame:(UInt32)inNumFrames time:(AudioTimeStamp*)timeStamp
{
if(!isActive) return [self RenderBlank:ioData bus:bus frame:inNumFrames];

UInt32 i;
float* out1 =(float*) ioData->mBuffers[0].mData;
float* out2 =(float*) ioData->mBuffers[1].mData;

// store input into buffer
bufferFrame=512*bufferPosition;
memcpy(bufferRecordLeft+bufferFrame,mInputBuffer->mBuffers[0].mData, inNumFrames*4);	

bufferPosition++;
if(bufferPosition>=bufferSegments)  bufferPosition=0;


for (i=0; i<inNumFrames; ++i) 
	{
	cFrame=i;
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
// ******************************************************************************************

@end
