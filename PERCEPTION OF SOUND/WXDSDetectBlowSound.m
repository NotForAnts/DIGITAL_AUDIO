// *********************************************************************************************
//  WXDSDetectBlowSound
//  Created by Paul Webb on Thu Jan 12 2006.
// *********************************************************************************************

#import "WXDSDetectBlowSound.h"


@implementation WXDSDetectBlowSound


// *********************************************************************************************
-(id)   init
{
if(self=[super init])
	{
	theData=nil;
	maxIndex=5;
	
	spectrums=[[WXDSFastFourierTransform alloc]init];
	[self initAnalysisInformation];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(analiserUpdate:) name:@"Analised" object:nil];
	
	plotterView=nil;
	isWorking=NO;
	}
return self;
}
// ************************************************************************************************
-(BOOL)		isWorking
{
return isWorking;
}
// ************************************************************************************************
-(void)		setConfidencePlot:(id)v		{   plotterView=v;			}
-(void)		setLoudPlotter:(id)p		{   loudPlotter=p;			}
-(float)	currentTotal				{   return currentTotal;	}
-(float)	blowSum						{	return	blowSum;		}
// ************************************************************************************************
-(void)		initAnalysisInformation
{
int t,p;
for(t=0;t<1000;t++)
	{
	currentSum[t]=0;
	sumIndex[t]=0;
	sumLoop[t]=NO;
	for(p=0;p<20;p++)
		spectrumLevel[t][p]=0;
		
	}

for(t=0;t<20;t++)
	blowLevel[t]=0;
	
blowIndex=0;
blowLoop=NO;	
blowSum=0;
	
loudIndex=0;
currentTotal=0;
maxLoudIndex=20;
storeFull=NO;	
	
	
quantize=1;	
}
// ******************************************************************************************
-(void)		analiserUpdate:(NSNotification *)notification
{
int		t,sindex=0,cindex;
float   v,vtotal=0;
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
	vtotal=vtotal+v;
	theSpectrum[sindex]=v;

	cindex=sumIndex[sindex];
	
	if(sumLoop[sindex]) currentSum[sindex]=currentSum[sindex]-spectrumLevel[sindex][cindex];
	spectrumLevel[sindex][cindex]=v;
	currentSum[sindex]=currentSum[sindex]+v;
	cindex++;
	if(cindex>=maxIndex) 
		{
		cindex=0;
		sumLoop[sindex]=YES;
		}
	sumIndex[sindex]=cindex;
	sindex++;
	}		
	
sindex=0;	
float   bvalue=currentSum[0];
float   confidence=0;
float   error=100;

if(bvalue<500) bvalue=500;
for(t=0;t<plots;t+=(quantize*2))
	{
	if(currentSum[sindex]>=bvalue)  confidence=confidence+1; else confidence=confidence-error;
	bvalue=bvalue*0.93; 
	error=error*0.95;
	if(bvalue<30) bvalue=30;
	sindex++;
	}

if(confidence<0) confidence=0;

if(blowLoop) blowSum=blowSum-blowLevel[blowIndex];
blowSum=blowSum+confidence;
blowLevel[blowIndex]=confidence;
blowIndex++;
if(blowIndex>10)
	{
	blowIndex=0;
	blowLoop=YES;
	}

//printf("done analysis %d bs=%f quan=%d\n",plots,blowSum,quantize);
//if(plotterView!=nil)		[plotterView addFloatData:blowSum/5.0];

}
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

// the SA works like a filter
// and every N samples call analise, which sends notification
[spectrums filterChunk:in1 frame:inNumFrames];


// this is to calc the average LEVEL
// the analysis call checks if its like a blow gesture
in1 =(float*)	mInputBuffer->mBuffers[0].mData;
float   sum=0;

for (i=0; i<inNumFrames; ++i) 
	{
	leftSample=*in1++;
	if(leftSample<0) leftSample*=-1;
	sum=sum+leftSample;
	}

if(blowSum<6) sum=0;	
currentTotal=currentTotal+sum;
if(storeFull)   currentTotal=currentTotal-sumStore[loudIndex];
sumStore[loudIndex]=sum;
loudIndex++;

if(loudIndex>=maxLoudIndex) 
	{
	storeFull=YES;
	loudIndex=0;
	}
	

//if(loudPlotter!=nil)	[loudPlotter addFloatData:currentTotal/100.0];
[self RenderBlank:ioData bus:bus frame:inNumFrames];	

//printf("ct = %f sum=%f blowSum=%f \n",currentTotal,sum,blowSum);
		
return noErr;

}

// *********************************************************************************************



@end
