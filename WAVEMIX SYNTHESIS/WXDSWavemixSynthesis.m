// ******************************************************************************************
//  WXDSWavemixSynthesis
//  Created by Paul Webb on Thu Jul 21 2005.
// ******************************************************************************************

#import "WXDSWavemixSynthesis.h"


@implementation WXDSWavemixSynthesis

// ************************************************************************************************
-(id)		init
{
if(self=[super init])
	{
	timerFrameCounter=0;
	theWaves=[[NSMutableArray alloc]init];
	waveSize=512;
	
	waveMaker=[[WXDSEnvelopeTableMaker alloc]init];
	envelope=[waveMaker makeGaussianEnvelope:44100 r1:0.0 r2:1.0];
	
	bufferRight=malloc(waveSize*sizeof(float));
	bufferLeft=malloc(waveSize*sizeof(float));
	
	[self addSomeWavesOverride];
	
	
	filterSeriesRight=nil;
	filterSeriesLeft=nil;
	}
return self;
}

// ************************************************************************************************
-(void)		dealloc
{
if(filterSeriesRight!=nil)   [filterSeriesRight release];
if(filterSeriesLeft!=nil)   [filterSeriesLeft release];
[theWaves release];
[super dealloc];
}
// ************************************************************************************************
-(void)		setFilterSeriesRight:(WXDSFilterSeries*)fs		{	filterSeriesRight=fs;		}
-(void)		setFilterSeriesLeft:(WXDSFilterSeries*)fs		{	filterSeriesLeft=fs;		}
// ************************************************************************************************
-(void)			removeOldObjects
{
int t;
// .....................	
// remove finished ones
t=0;
while(t<[theWaves count])
	if([[theWaves objectAtIndex:t]done])
		[theWaves removeObjectAtIndex:t];   else t++;
}
// ************************************************************************************************
-(void)			removeAllWaves
{
[theWaves removeAllObjects];
}
// ************************************************************************************************
-(void)			addSomeWavesOverride2
{	
}
// ************************************************************************************************
-(void)			addSomeWavesOverride
{
int t,duration;
WXDSWavemixSynthesisObject  *newWave;
WXDSRenderBase				*newRenderer;
WXDSEnvelopeBasic			*newEnvelope;
WXDSEnvelopeBasic			*panEnvelope;

[self removeOldObjects];
BOOL	usePan=YES;;

if([theWaves count]>7)		return;
if(WXUPercentChance(20))	return;



duration=10000+WXURandomInteger(0,10000*12);
if(WXUPercentChance(30)) duration=44100+WXURandomInteger(0,44100*8);
if(WXUPercentChance(30)) duration=44100+WXURandomInteger(0,44100*16);

for(t=0;t<1;t++)
	{
	newWave=[[WXDSWavemixSynthesisObject alloc]initFromTime:timerFrameCounter];
	
	
	
	[newWave setStartAndDuration:timerFrameCounter+44100+WXURandomInteger(0,44100*8) dur:duration];
	
	switch(WXURandomInteger(1,15))
		{
		case 1:		newRenderer=[[WXDSBasicSinework alloc]initWithFreq:WXURandomInteger(20,1000)];		break;
		case 2:		newRenderer=[[WXDSRenderBase alloc]initWithFreq:WXURandomInteger(20,1000)];		break;
		case 3:		newRenderer=[[WXDSRenderBase alloc]initWithFreq:WXURandomInteger(120,4000)];	break;
		case 4:		newRenderer=[[WXDSRenderBase alloc]initWithFreq:WXURandomInteger(20,1000)];		break;
		case 5:		newRenderer=[[WXDSBasicWhiteNoiseWave alloc]init];								
					[newRenderer setResolution:WXURandomInteger(1,64)];
					break;
					
		case 6:		newRenderer=[[WXDSBasicBrownNoiseWave alloc]init];									break;
		case 7:		newRenderer=[[WXDSBasicSineworkTwo alloc]initWithFreq:WXURandomInteger(20,1000)];		
					usePan=NO;
					
		case 8:		newRenderer=[[WXDSBasicSineworkTwo alloc]initWithFreq:WXURandomInteger(20,12000)];		
					usePan=NO;			
					break;
		
		case 9:		newRenderer=[[WXDSBasicSineworkTwo alloc]initWithFreq:WXURandomInteger(7000,18000)];		
					usePan=NO;			
					break;	
					
					
		case 10:	newRenderer=[[WXDSBasicSineworkThree alloc]initWithFreq:WXURandomInteger(7000,18000)];	
					usePan=NO;	
					break;	
					
		case 11:	newRenderer=[[WXDSBasicSineworkFour alloc]initWithFreq:WXURandomInteger(200,2900)];	
					usePan=NO;	
					break;	
					
		case 12:	newRenderer=[[WXDSBasicSineworkFour alloc]initWithFreq:WXURandomInteger(2000,12900)];	
					usePan=NO;	
					break;	
					
		case 13:	newRenderer=[[WXDSBasicSineworkFour alloc]initWithFreq:WXURandomInteger(100,300)];	
					usePan=NO;	
					break;	
					
		case 14:	newRenderer=[[WXDSBasicSineworkFive alloc]initWithFreq:WXURandomInteger(2110,2150)];	
					usePan=NO;	
					break;						

		case 15:	newRenderer=[[WXDSBasicSineworkSix alloc]initWithFreq:WXURandomInteger(2000,5000)];	
					usePan=NO;	
					break;	
		}
	
	
	
	
	[newRenderer setMasterGain:WXUFloatRandomBetween(0.01,0.3)];
	
	//[newRenderer setMasterGain:0.4];
	[newRenderer setMasterPan:0.5];
	[newWave setRenderer:newRenderer];
	
	// PAN GESTURE
	if(usePan)
		{
		panEnvelope=[[WXDSEnvelopeSegmentSine alloc]initSegmentLinear:0.0 g2:1.0];
		[panEnvelope setDegree:0 d2:360*WXURandomInteger(1,32)];
		[panEnvelope setDuration:duration];
		[newWave setPanEnvelope:panEnvelope];
		}
	// ENVELOPE
	switch(WXURandomInteger(1,1))
		{
		case 1: newEnvelope=[[WXDSEnvelopeSeries alloc]init];   
				[newEnvelope test:duration];
				break;
				
		case 2: newEnvelope=[[WXDSEnvelopeSegmentExponential alloc]init];   
				[newEnvelope setDuration:duration];	
				break;
				
		case 3: newEnvelope=[[WXDSEnvelopeSegmentSine alloc]init];   
				[newEnvelope setDuration:duration];	
				break;
		}
		
	
	
	[newWave setSoundEnvelope:newEnvelope];
	
	[theWaves addObject:newWave];
	[newWave release];
	}
	
//printf("done added\n");	
}

// ************************************************************************************************
-(OSStatus)		audioCallbackOnDevice:(AudioBufferList*)ioData bus:(UInt32)bus frame:(UInt32)inNumFrames time:(AudioTimeStamp*)timeStamp
{
if(!isActive) return [self RenderBlank:ioData bus:bus frame:inNumFrames];
UInt32 i;


float   sum;
float*  out1 =(float*) ioData->mBuffers[0].mData;
float*  out2 =(float*) ioData->mBuffers[1].mData;

int t,size=[theWaves count];
//[self RenderBlank:ioData bus:bus frame:inNumFrames];

memset(bufferRight,0,waveSize*4);	
memset(bufferLeft,0,waveSize*4);	


for(t=0;t<size;t++)
	{
	[[theWaves objectAtIndex:t] doRenderWave:timerFrameCounter ioData:ioData bus:bus frame:inNumFrames time:timeStamp];
	
	out1 =(float*) ioData->mBuffers[0].mData;
	out2 =(float*) ioData->mBuffers[1].mData;
	for (i=0; i<inNumFrames; ++i) 
		{
		bufferRight[i]+=*out1++;
		bufferLeft[i]+=*out2++;
		}
	}


out1 =(float*) ioData->mBuffers[0].mData;
out2 =(float*) ioData->mBuffers[1].mData;
memcpy(out1,bufferRight,waveSize*4);
memcpy(out2,bufferLeft,waveSize*4);

timerFrameCounter+=waveSize;

if(filterSeriesRight!=nil)		[filterSeriesRight filterChunk:(float*) ioData->mBuffers[0].mData frame:inNumFrames];
if(filterSeriesLeft!=nil)		[filterSeriesLeft filterChunk:(float*) ioData->mBuffers[1].mData frame:inNumFrames];
	
return noErr;
}
// ************************************************************************************************


@end
