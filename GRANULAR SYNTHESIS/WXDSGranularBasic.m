// ***************************************************************************************
//  WXDSGranularBasic
//  Created by Paul Webb on Thu Dec 30 2004.
// ***************************************************************************************

#import "WXDSGranularBasic.h"

// ***************************************************************************************

@implementation WXDSGranularBasic

// ***************************************************************************************
-(id)   init
{
if(self=[super init])
	{
	grainAddIndex=0;
	masterGain=1.0;
	masterPan=0.5;
	nextGrainAtCounter=0;
	counter=0;
	useFilter=NO;
	isActive=YES;

	
	[self initialiseParameters];
	waveTableMaker=[[WXDSEnvelopeTableMaker alloc]init];
	
	}
return self;
}

// ***************************************************************************************
-(void) initialiseParameters
{
[self setGrainsPerSecondRange:5 r2:15];
[self setGrainFrequencyRange:50 f2:6560];
[self setGrainDurationAsSamples:100 r2:1000];
[self setGrainGainRange:0.05 r2:0.5];
[self setGrainPanRange:0.0 r2:1.0];
[self setGrainWaveRange:0 r2:6];
[self setGrainEnvelopeRange:0 r2:7];
}
// ***************************************************************************************
-(void)		dealloc
{
[super dealloc];
}
// ***************************************************************************************
// OVERRIDE THIS IF WISH TO OR CAN ADD THEM TO THIS EXTERNALLY
// ***************************************************************************************
-(void) initialiseWaveTables
{
[self setWaveTable:0 table:[waveTableMaker makeSineWaveTable:88200 r1:-1.0 r2:1.0 freq:1.0]];
[self setWaveTable:1 table:[waveTableMaker makePartialSineTable:88200 freq:@"1,3" amp:@"1,1" r1:-1.0 r2:1.0]];
[self setWaveTable:2 table:[waveTableMaker makePartialSineTable:88200 freq:@"1,2,4" amp:@"1,1,0.8" r1:-1.0 r2:1.0]];
[self setWaveTable:3 table:[waveTableMaker makeRampTable:88200 freq:@"1,3" amp:@"1,1" r1:-1.0 r2:1.0]];
[self setWaveTable:4 table:[waveTableMaker makeRampTable:88200 freq:@"1,2,4" amp:@"1,1,0.8" r1:-1.0 r2:1.0]];
[self setWaveTable:5 table:[waveTableMaker makeDecaySineWaveTable:88200 r1:-1.0 r2:1.0 freq:4]];
[self setWaveTable:6 table:[waveTableMaker makePulseTable:88200 r1:-1.0 r2:1.0 freq:220.0 pulsePercent:5]];


[self setEnvelopeTable:0 table:[waveTableMaker makeGaussianEnvelope:44100 r1:0.0 r2:1.0]];
[self setEnvelopeTable:1 table:[waveTableMaker makeQuasiGaussianEnvelope:44100 flat:10000 r1:0.0 r2:1.0]];
[self setEnvelopeTable:2 table:[waveTableMaker makeSmoothSineEnvelope:44100 r1:0.0 r2:1.0]];
[self setEnvelopeTable:3 table:[waveTableMaker makeShiftedHalfSineEnvelope:44100 p1:5000 p2:35100 r1:0.0 r2:1.0]];
[self setEnvelopeTable:4 table:[waveTableMaker makeThreeStageTriangleEnvelope:44100 r1:0.0 r2:1.0 flat:30000]];
[self setEnvelopeTable:5 table:[waveTableMaker makeTriangleEnvelope:44100 r1:0.0 r2:1.0]];
[self setEnvelopeTable:6 table:[waveTableMaker makeExpodecEnvelope:44100 r1:0.0 r2:1.0]];
[self setEnvelopeTable:7 table:[waveTableMaker makeRexpodecEnvelope:44100 r1:0.0 r2:1.0 e1:0 e2:5.0]];
[self setEnvelopeTable:8 table:[waveTableMaker makeSincEnvelope:44100 r1:0.0 r2:1.0 phases:5.0]];


printf("done init wavetables\n");
}
// ***************************************************************************************
-(int)  getMaxGrains
{
return WXDSGranularBasicMaxGrains;
}
// ***************************************************************************************
-(void)		addGrain:(WXDSGrain*)theGrain
{
if(grainAddIndex<WXDSGranularBasicMaxGrains)
	{
	[theGrain retain];
	grains[grainAddIndex]=theGrain;
	freeIndexStore[grainAddIndex]=grainAddIndex;
	grainAddIndex++;
	}
}
// ***************************************************************************************
// OVERRIDE THIS IF WANT SUBCLASS TO DEFINE DIFFERENT TYPES OF GRAINS 
// ***************************************************************************************
-(void)		initialiseGrains
{
int t;
for(t=0;t<WXDSGranularBasicMaxGrains;t++)
	{
	freeIndexStore[t]=t;	
	grains[t]=[[WXDSGrain alloc]init];
	grainAddIndex++;
	}
freePlace=0;	
activeGrainFirst=0;
activeGrainLast=0;
printf("done init grains\n");
}
// ***************************************************************************************
-(void)		setUseFilters:(BOOL)state
{
useFilter=state;
}
// ***************************************************************************************
-(void) setRightFilterSeries:(WXDSFilterSeries*)fP
{
leftFilterSeries=fP;
}
// ***************************************************************************************
-(void) setLeftFilterSeries:(WXDSFilterSeries*)fP
{
rightFilterSeries=fP;
}
// ***************************************************************************************
-(void)	setWaveTable:(int)index table:(float*)table
{
grainWaves[index]=table;
}
// ***************************************************************************************
-(void)	setEnvelopeTable:(int)index table:(float*)table
{
grainEnvelope[index]=table;
}
// ***************************************************************************************
-(void)	setGrainsPerSecond:(int)gps
{
grainPerSecondEveryCount=44100/gps;
}
// ***************************************************************************************
-(void)	setGrainsPerSecondRange1:(int)r1		{	GPS1=44100/r1;		}
-(void)	setGrainsPerSecondRange2:(int)r1		{	GPS2=44100/r1;		}
-(void)	setGrainFrequencyRange1:(float)f1		{	grainFreq1=f1;		}
-(void)	setGrainFrequencyRange2:(float)f1		{	grainFreq2=f1;		}
-(void) setGrainFrequencyGain1:(float)v			{	gain1=v;			}
-(void) setGrainFrequencyGain2:(float)v			{	gain2=v;			}
-(void) setGrainDurAsSamples1:(float)v			{	duration1=v;		}
-(void) setGrainDurAsSamples2:(float)v			{	duration2=v;		}
// ***************************************************************************************
-(void)	setGrainsPerSecondRange:(int)r1 r2:(int)r2
{
GPS1=44100/r1;
GPS2=44100/r2;
}
// ***************************************************************************************
-(void)	setGrainRatePeriodAsSamples:(int)r1 r2:(int)r2
{
GPS1=r1;
GPS2=r2;
}
// ***************************************************************************************
-(void)	setGrainRatePeriodAsMilliSeconds:(int)r1 r2:(int)r2
{
GPS1=r1*44.1;
GPS2=r2*44.1;
}
// ***************************************************************************************
-(void)	setGrainFrequencyRange:(float)f1 f2:(float)f2
{
if(f1>=0)   grainFreq1=f1;  
if(f2>=0)   grainFreq2=f2;
}
// ***************************************************************************************
-(void)	setGrainDurationAsSamples:(int)r1 r2:(int)r2
{
duration1=r1;
duration2=r2;
}
// ***************************************************************************************
-(void)	setGrainDurationAsMilliSeconds:(int)r1 r2:(int)r2
{
duration1=r1*44.1;
duration2=r2*44.1;
}
// ***************************************************************************************
-(void)	setGrainGainRange:(float)r1 r2:(float)r2
{
gain1=r1;  
gain2=r2;
}
// ***************************************************************************************
-(void)	setGrainPanRange:(float)r1 r2:(float)r2
{
pan1=r1;	pan2=r2;
}
// ***************************************************************************************
-(void)	setGrainWaveRange:(int)r1 r2:(int)r2
{
wave1=r1;	wave2=r2;
}
// ***************************************************************************************
-(void)	setGrainEnvelopeRange:(int)r1 r2:(int)r2
{
envelope1=r1;   envelope2=r2;
}
// ***************************************************************************************
-(void)	setGrainsPerSecondNSO:(id)ob								{		grainPerSecondEveryCount=44100/[ob floatValue];		}
-(void)	setGrainsPerSecondRange1NSO:(id)ob							{		GPS1=44100/[ob floatValue];						}
-(void)	setGrainsPerSecondRange2NSO:(id)ob							{		GPS2=44100/[ob floatValue];						}
-(void)	setGrainRatePeriodAsSamplesRange1NSO:(id)ob					{		GPS1=[ob floatValue];								}
-(void)	setGrainRatePeriodAsSamplesRange2NSO:(id)ob					{		GPS2=[ob floatValue];								}
-(void)	setGrainRatePeriodAsMilliSecondsRange1NSO:(id)ob			{		GPS1=44.1*[ob floatValue];							}
//-(void)	setGrainRatePeriodAsMilliSecondsRange1NSO:(id)ob			{		GPS2=44.1*[ob floatValue];							}

-(void)	setGrainFrequencyRange1NSO:(id)ob							{		grainFreq1=[ob floatValue];							}
-(void)	setGrainFrequencyRange2NSO:(id)ob							{		grainFreq2=[ob floatValue];							}
-(void)	setGrainDurationAsSamplesRange1NSO:(id)ob					{		duration1=[ob floatValue];							}
-(void)	setGrainDurationAsSamplesRange2NSO:(id)ob					{		duration2=[ob floatValue];							}
-(void)	setGrainDurationAsMilliSecondsRange1NSO:(id)ob				{		duration1=44.1*[ob floatValue];						}
-(void)	setGrainDurationAsMilliSecondsRange2NSO:(id)ob				{		duration2=44.1*[ob floatValue];						}
-(void)	setGrainGainRange1NSO:(id)ob								{		gain1=[ob floatValue];								}
-(void)	setGrainGainRange2NSO:(id)ob								{		gain2=[ob floatValue];								}
-(void)	setGrainPanRange1NSO:(id)ob									{		pan1=[ob floatValue];								}
-(void)	setGrainPanRange2NSO:(id)ob									{		pan2=[ob floatValue];								}
-(void)	setGrainWaveRange1NSO:(id)ob								{		wave1=[ob floatValue];								}
-(void)	setGrainWaveRange2NSO:(id)ob								{		wave2=[ob floatValue];								}
-(void)	setGrainEnvelopeRange1NSO:(id)ob							{		envelope1=[ob floatValue];							}
-(void)	setGrainEnvelopeRange2NSO:(id)ob							{		envelope2=[ob floatValue];							}
// ***************************************************************************************
-(int)		getFreeIndexAndUpdateGrainList;
{
int i;
if(freePlace>=grainAddIndex) return -1;
i=freeIndexStore[freePlace];
freePlace++;
if(activeGrainFirst==0) 
	{
	activeGrainFirst=grains[i];
	activeGrainLast=grains[i];
	[grains[i] setPrevAndNext:0 next:0];
	}
else
	{
	[activeGrainLast setNext:grains[i]];
	[grains[i] setPrevAndNext:activeGrainLast next:0];
	activeGrainLast=grains[i];
	}
return i;
}
// ***************************************************************************************
-(float)	DurMS:(float)d
{
return d*44.1;
}
// ***************************************************************************************
// TO OVERRIDE
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

}
// ***************************************************************************************
-(OSStatus)		audioCallbackOnDevice:(AudioBufferList*)ioData bus:(UInt32)bus frame:(UInt32)inNumFrames time:(AudioTimeStamp*)timeStamp
{
if(!isActive) return [self RenderBlank:ioData bus:bus frame:inNumFrames];

UInt32 i;
float* out1 =(float*) ioData->mBuffers[0].mData;
float* out2 =(float*) ioData->mBuffers[1].mData;


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
// ******************************************************************************************


@end
