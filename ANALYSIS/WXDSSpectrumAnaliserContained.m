// *********************************************************************************************
//  WXDSSpectrumAnaliserContained
//  Created by Paul Webb on Wed Jan 11 2006.
// *********************************************************************************************

#import "WXDSSpectrumAnaliserContained.h"


@implementation WXDSSpectrumAnaliserContained

// *********************************************************************************************
-(id)   init
{
if(self=[super init])
	{
	freqPlotter=nil;
	loudPlotter=nil;
	testModulas=4;
	pitchCounter=0;
	sumIndex=0;
	currentTotal=0;
	maxIndex=2;
	storeFull=NO;
	playThru=NO;
	pitchMeanTest=NO;
	calculateDynamic=NO;
	
	spectrums=[[WXDSFastFourierTransform alloc]init];
	[self initAnalysisInformation];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(analiserUpdate:) name:@"Analised" object:nil];
	
	}
return self;
}
// ************************************************************************************************
-(float)	currentTotal			{   return currentTotal;	}
-(float)	meanFreq				{   return meanFreq;		}
-(void)		setFreqPlotter:(id)p	{   freqPlotter=p;			}
-(void)		setLoudPlotter:(id)p	{   loudPlotter=p;			}
// ************************************************************************************************
-(void)		initAnalysisInformation
{
int t;
for(t=0;t<1000;t++) 
	spectrumSums[t]=0;
	
quantize=1;	
}
// ******************************************************************************************
-(void)		analiserUpdate:(NSNotification *)notification
{

int		t,sindex=0;
float   v;
float   v1,v2;

theData=[[notification object]getReal];
plots=[[notification object]numberFreqsChecked];
// default plots is 512

plots=120;

for(t=0;t<plots;t+=(quantize*2))
	{
	v1=theData[t];
	v2=theData[t+1];
	v=sqrt(v1*v1+v2*v2);
	theSpectrum[sindex]=v;
	sindex++;
	}		

if(pitchMeanTest)   [self doMeanPitchTesting];
}
// ************************************************************************************************
-(void)		doMeanPitchTesting
{
int		index,t,sindex=0;
float   max=50;
float   freq=20,foundFreq;

plots=120;
for(t=0;t<plots;t+=(quantize*2))
	{
	spectrumSums[sindex]+=theSpectrum[sindex];
	sindex++;
	}

sindex=0;
if(pitchCounter % testModulas==0)
	{
	foundFreq=0;
	for(t=0;t<plots && freq<2000;t+=(quantize*2))
		{
		freq=((sindex)*40.2);
		
		//freq=1 << sindex;
		if(spectrumSums[sindex]>max)
			{
			index=sindex;
			max=spectrumSums[sindex];
			foundFreq=freq;
			}
		spectrumSums[sindex]=0;	
		sindex++;
		}
	
	meanFreq=foundFreq;
	printf("%f\n",foundFreq);	
	
	if(freqPlotter!=nil)	[freqPlotter addFloatData:meanFreq/3];
	}
	
pitchCounter++;	
}

// ************************************************************************************************

// ************************************************************************************************
-(void)		connectToSoundInput:(WXDSSoundInputSystem*)sis		
{   
mySoundInputPointer=sis;	
[self setInputBufferPointer:[mySoundInputPointer getBuffer]];
}
// ************************************************************************************************
-(void)		setInputBufferPointer:(AudioBufferList*)inputBuffer {   mInputBuffer=inputBuffer;   }
// ************************************************************************************************
// my version is basically copying the data
// ************************************************************************************************

-(OSStatus)		audioCallbackOnDevice:(AudioBufferList*)ioData bus:(UInt32)bus frame:(UInt32)inNumFrames time:(AudioTimeStamp*)timeStamp
{
if(!isActive) return [self RenderBlank:ioData bus:bus frame:inNumFrames];
if(mInputBuffer==0)  return [self RenderBlank:ioData bus:bus frame:inNumFrames];
UInt32 i;

float* in1 =(float*)	mInputBuffer->mBuffers[0].mData;

[spectrums filterChunk:in1 frame:inNumFrames];

if(!calculateDynamic)   return [self RenderBlank:ioData bus:bus frame:inNumFrames];

in1 =(float*)	mInputBuffer->mBuffers[0].mData;
float   sum=0;

for (i=0; i<inNumFrames; ++i) 
	{
	leftSample=*in1++;
	if(leftSample<0) leftSample*=-1;
	sum=sum+leftSample;
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

if(loudPlotter!=nil)	[loudPlotter addFloatData:currentTotal];

[self RenderBlank:ioData bus:bus frame:inNumFrames];	
		
return noErr;
}

// *********************************************************************************************

@end
