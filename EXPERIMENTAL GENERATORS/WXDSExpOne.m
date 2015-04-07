// ******************************************************************************************
//  WXDSExpOne.h
//  Created by Paul Webb on Fri Aug 19 2005.
// ******************************************************************************************
#import "WXDSExpOne.h"


@implementation WXDSExpOne
// ******************************************************************************************
-(id) init
{
if(self=[super init])
	{
	counter=0;
	jetTable = [[WXDSInstrumentJetTable alloc]init];

	dcBlock =[[WXFilterPoleZero alloc]init];
	[dcBlock setBlockZeroDef];
	[dcBlock setBlockZero:0.99999];
	[dcBlock setB1:-0.7];
	[dcBlock setB0:0.7];

	vibrato = [[WXDSWaveTable alloc]init];
	[vibrato loadWaveOfName: "rawwaves/sinewave.raw"];
	[vibrato setFrequencyForWave:(float) 2.925]; 

	vibratoGain = 0.7;

	resonator=[[WXFilterBiQuad alloc]init];
	[resonator setResonance:500.0 radius:__BOTTLE_RADIUS__ normalise:YES];
	resonator2=[[WXFilterBiQuad alloc]init];
	[resonator2 setResonance:500.0 radius:__BOTTLE_RADIUS__ normalise:YES];	
	resonator3=[[WXFilterBiQuad alloc]init];
	[resonator3 setResonance:500.0 radius:__BOTTLE_RADIUS__ normalise:YES];		

	adsr=[[WXDSInstrumentEnvelopeBase alloc]init];
	[adsr setAllTimes:0.005 v2:0.01 v3:0.8 v4:0.010];
	

	noiseGain = 20.0;

	maxPressure = (float) 0.0;
	}
return self;
}
// ******************************************************************************************
-(void)		dealloc
{
[jetTable release];
[resonator release];
[dcBlock release];
[adsr release];
[vibrato release];
[super dealloc]; 
}
// ******************************************************************************************
-(void) clear
{
[resonator clear];
[resonator2 clear];
[resonator3 clear];
}
// ******************************************************************************************
-(void) setFrequency:(float)frequency
{
float freakency = frequency;
if ( frequency <= 0.0 ) {
freakency = 220.0;
}

[resonator setResonance:freakency radius:__BOTTLE_RADIUS__ normalise:YES];
[resonator2 setResonance:freakency/4 radius:__BOTTLE_RADIUS__ normalise:YES];
[resonator3 setResonance:freakency/10 radius:__BOTTLE_RADIUS__ normalise:YES];
}
// ******************************************************************************************
-(void) startBlowing:(float)amplitude rate:(float)rate
{
[adsr setAttackRate:rate];
maxPressure = amplitude;
[adsr keyOnWithGain:1.0];
}
// ******************************************************************************************
-(void) stopBlowing:(float)rate
{
[adsr setReleaseRate:rate];
[adsr keyOff];
}
// ******************************************************************************************
-(void) keyONWithFreqGain:(float)freq gain:(float)gain
{
freq=150;
noiseGain = 10.0;
[self setFrequency:freq];
[self startBlowing: 1.1 + (gain * 0.20) rate:gain * 0.02];
outputGain = gain + 0.001;
}
// ******************************************************************************************
-(void) keyOFF:(float)gain
{
[self stopBlowing:gain * 0.02];
}
// ************************************************************************************************
-(OSStatus)		audioCallbackOnDevice:(AudioBufferList*)ioData bus:(UInt32)bus frame:(UInt32)inNumFrames time:(AudioTimeStamp*)timeStamp
{
if(!isActive) return [self RenderBlank:ioData bus:bus frame:inNumFrames];
UInt32 i;
float* out1 =(float*) ioData->mBuffers[0].mData;
float breathPressure;
float randPressure;
float pressureDiff,v;
for (i=0; i<inNumFrames; ++i) 
	{
	// Calculate the breath pressure (envelope + vibrato)
	counter++;
	
	
	
	breathPressure = maxPressure * [adsr tick];
	breathPressure += vibratoGain * [vibrato tick];

	pressureDiff = breathPressure - [resonator lastOut] + [resonator2 lastOut];// + [resonator3 lastOut];

	randPressure = noiseGain * (-1.0+random()%60000/30000.0);

	randPressure *= breathPressure;
	randPressure *= (1.0 + pressureDiff);

	v=[resonator filter:breathPressure + randPressure - ( [jetTable tick: pressureDiff] * pressureDiff ) ];
	pressureDiff*=0.8;
	[resonator2 filter:breathPressure + randPressure - ( [jetTable tick: pressureDiff] * pressureDiff ) ];
	//pressureDiff*=1.2;
	//[resonator3 filter:breathPressure - randPressure + ( [jetTable tick: pressureDiff] * pressureDiff ) ];
	
	lastOutput = 0.2 * outputGain * [dcBlock filter:pressureDiff];

	*out1++ = lastOutput;
	}

[self doMonoToStereoPan:ioData frame:inNumFrames];

return noErr;
}
// ******************************************************************************************

@end
