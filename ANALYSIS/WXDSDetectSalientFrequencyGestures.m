// *********************************************************************************************
//  WXDSDetectSalientFrequencyGestures
//  Created by veronica ibarra on 04/10/2006.
// *********************************************************************************************

#import "WXDSDetectSalientFrequencyGestures.h"


@implementation WXDSDetectSalientFrequencyGestures
// *********************************************************************************************
-(id)   init
{
if(self=[super init])
	{
	spectrums=[[WXDSFastFourierTransform alloc]init];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(analiserUpdate:) name:@"Analised" object:nil];
	
	timeWindow=[[WXTimeWindowStore alloc]initWithTimeLength:100];
	[timeWindow reset];
	doRunningAverage=YES;
	theData=nil;
	
	currentFreqIndex=-1;
	gotGesture=NO;
	madeGesture=NO;
	checkingFFT=NO;
	failSalientCount=0;
	playIndex=0;
	
	maxSize=44100*16;
	
	
	gestureCollection=[[WXDSSalientGestureObjectCollection alloc]init];
	
	salientFreqArray=[[NSMutableArray alloc]init];
	salientLevelArray=[[NSMutableArray alloc]init];
	informObject=nil;
	
	[self initAnalysisInformation];
	
	[NSThread detachNewThreadSelector:@selector(backGroundThread) toTarget:self withObject:self];
	}
return self;
}
// ************************************************************************************************
-(void)		dealloc
{
[gestureCollection release];
[spectrums release];
[super dealloc];
}
// ************************************************************************************************
-(void)		connectToSoundInput:(WXDSSoundInputSystem*)sis		
{   
mySoundInputPointer=sis;	
[self setInputBufferPointer:[mySoundInputPointer getBuffer]];
}
// ************************************************************************************************
-(void)		setObjectToInform:(id)anObject selector:(SEL)selector
{
informObject=anObject;
informSelector=selector;
}
// ************************************************************************************************
-(void)		setInputBufferPointer:(AudioBufferList*)inputBuffer {   mInputBuffer=inputBuffer;   }
// ************************************************************************************************
-(void)		initAnalysisInformation
{
int t,p;

quantize=1;	
runningAverage=0;
}
// ******************************************************************************************
-(void)		backGroundThread
{
NSAutoreleasePool *pool2;
pool2 = [[NSAutoreleasePool alloc] init];

wasUpdated=NO;
do{
	if(wasUpdated && !checkingFFT)
		{
		[self doCheckSalient];
		wasUpdated=NO;
		}
	

	[NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
	}while(YES);


[pool2 release];
}
// ******************************************************************************************
-(void)		analiserUpdate:(NSNotification*)notification
{
wasUpdated=YES;
theData=[[notification object]getReal];
}
// ******************************************************************************************
-(void)		doCheckSalient
{
if(theData==nil)	return;


checkingFFT=YES;
int		t,sindex=0,cindex;
float   v;
float   v1,v2,sum=0;


int		startPlot=10*2;
int		endPlot=startPlot+40*2;
float	diff=(endPlot-startPlot)/2;

int		numberSalient=0,maxSalientIndex=0,maxSalientLevel=0,ld,lu;
BOOL	gotSalient=NO;


for(t=startPlot;t<endPlot;t+=(quantize*2))
	{
	v1=theData[t];
	v2=theData[t+1];
	v=sqrt(v1*v1+v2*v2);
	theSpectrum[sindex]=v;
	
	sum+=v;
	if(runningAverage>10)
		{
		if(v>runningAverage && v>20) 
			{
			numberSalient++;
			if(v>maxSalientLevel)
				{
				maxSalientIndex=t;
				maxSalientLevel=v;
				}
			}
		}
	}

if(numberSalient>0 && numberSalient<7)
	{
	currentFreqIndex=maxSalientIndex;
	salientInRow++;
	failSalientCount=0;
	[salientFreqArray addObject:[NSNumber numberWithInt:maxSalientIndex]];
	[salientLevelArray addObject:[NSNumber numberWithInt:maxSalientLevel]];
	
	if(salientInRow>=2) gotGesture=YES;
	}
else
	{
	if(gotGesture)
		{
		if(currentFreqIndex>=4)
			{
			// follow freq or slide
			ld=theSpectrum[currentFreqIndex-1];
			lu=theSpectrum[currentFreqIndex+1];
			
			if(lu>theSpectrum[currentFreqIndex] && lu>ld) currentFreqIndex+=1; 
			if(ld>theSpectrum[currentFreqIndex] && ld>lu) currentFreqIndex-=1;
						
			[salientFreqArray addObject:[NSNumber numberWithInt:currentFreqIndex]];
			[salientLevelArray addObject:[NSNumber numberWithInt:theSpectrum[currentFreqIndex]]];
			if(theSpectrum[currentFreqIndex]<runningAverage*2 && runningAverage<10) failSalientCount++;
			}
		else
			{
			// add pause int gesture
			[salientFreqArray addObject:[NSNumber numberWithInt:0]];
			[salientLevelArray addObject:[NSNumber numberWithInt:0]];	
			failSalientCount++;
			}	
		}
	else
		failSalientCount=1000;
		
	// end or fail	
	if(failSalientCount>5 || [salientFreqArray count]>60)
		{
		if(salientInRow>0)	
			{
			if(gotGesture)
				{
				[gestureCollection addGestureUsing:salientFreqArray levels:salientLevelArray];
				if(informObject!=nil)
					[informObject performSelector:informSelector withObject:gestureCollection];

				[[NSNotificationCenter defaultCenter]   postNotificationName:@"GOTSALIENT" object:self];	
				}
				
			[salientFreqArray removeAllObjects];
			[salientLevelArray removeAllObjects];
			}
	
		currentFreqIndex=-1;
		gotGesture=NO;
		salientInRow=0;
		failSalientCount=0;
		}
	}

if(doRunningAverage)
	{
	long currentTime=AudioGetCurrentHostTime()/(AudioGetHostClockFrequency()/1000.0);
	[timeWindow bang:currentTime value:sum*100];
	[timeWindow doUpdate];

	runningSum=[timeWindow getAverage];;
	runningAverage=runningSum/diff;
	runningAverage=runningAverage/100.0;
	runningAverage=runningAverage*4.0;		
	}

checkingFFT=NO;
}
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

// remove this
/*
if(madeGesture)
	{
	float* out1 =(float*) ioData->mBuffers[0].mData;
	float* out2 =(float*) ioData->mBuffers[1].mData;
	for (i=0; i<inNumFrames; ++i) 
		{
		*out1++ = gestureSample[playIndex];	
		*out2++ = gestureSample[playIndex];	
		
		playIndex++;
		if(playIndex>=gestureSize) playIndex=0;
		}
	
	return noErr;
	}
	
	*/

[self RenderBlank:ioData bus:bus frame:inNumFrames];	
return noErr;

}

// *********************************************************************************************


@end
