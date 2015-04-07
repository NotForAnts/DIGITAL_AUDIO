// ******************************************************************************************
//  WXDSInstrumentFlute
//  Created by Paul Webb on Mon Aug 15 2005.
// ******************************************************************************************

#import "WXDSInstrumentFlute.h"


@implementation WXDSInstrumentFlute

// ******************************************************************************************
-(id)   initInstrumentFlute:(float)lowestFrequency
{
if(self=[super init])
	{
	length = (long) (44100.0 / lowestFrequency + 1);
	boreDelay = [[WXFilterDelayL alloc]initDelay:100.0 md: length];
	length >>= 1;
	jetDelay = [[WXFilterDelayL alloc]initDelay:49.0 md:length];
	jetTable = [[WXDSInstrumentJetTable alloc]init];
	filter = [[WXFilterOnePole alloc]init];
	dcBlock =[[WXFilterPoleZero alloc]init];
	[dcBlock setBlockZeroDef];
	adsr = [[WXDSInstrumentEnvelopeBase alloc]init];

	// Concatenate the STK rawwave path to the rawwave file
	vibrato = [[WXDSWaveTable alloc]init];
	[vibrato loadWaveOfName: "rawwaves/sinewave.raw"];
	[vibrato setFrequency:(float) 5.925 / 512.0];

	[self clear];

	[filter setPole: 0.7 - ((float) 0.1 * 22050.0 / 44100.0) ];
	[filter setGain:-1.0];
	//adsr->setAllTimes( 0.005, 0.01, 0.8, 0.010);
	[adsr setAttack:1.0 time:0.005];
	[adsr setDecay:0.8 time:0.01];
	[adsr setRelease:0.0 time:0.010];		
	
	endReflection = (float) 0.5;
	jetReflection = (float) 0.5;
	noiseGain =  0.05;				// Breath pressure random component.
	vibratoGain = (float) 0.05;		// Breath periodic vibrato component.
	jetRatio = (float) 0.32;

	maxPressure = (float) 0.0;
	lastFrequency = 220.0;
	}
return self;
}
// ******************************************************************************************
-(void) dealloc
{
[jetDelay release];
[boreDelay release];
[jetTable release];
[filter release];
[dcBlock release];
[adsr release];
[vibrato release];
[super dealloc];
}
// ******************************************************************************************
-(void) clear
{
[jetDelay clear];
[boreDelay clear];
[filter clear];
[dcBlock clear];
}
// ******************************************************************************************
-(void) setFrequency:(float)frequency
{
lastFrequency = frequency;
if ( frequency <= 0.0 ) lastFrequency = 220.0;


// We're overblowing here.
lastFrequency *= 0.66666;
// Delay = length - approximate filter delay.
float delay = 44100.0 / lastFrequency - (float) 2.0;
if (delay <= 0.0) delay = 0.3;
else if (delay > length) delay = length;

[boreDelay setDelay:delay];
[jetDelay setDelay:delay * jetRatio];
}
// ******************************************************************************************
-(void) startBlowing:(float)amplitude rate:(float)rate
{
[adsr setAttackRate:rate];
maxPressure = amplitude / (float) 0.8;
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
[self setFrequency:freq+220];
[self startBlowing:1.1 + (gain * 0.20) rate:gain* 0.02];
outputGain = gain + 0.001;
}
// ******************************************************************************************
-(void) keyOFF:(float)gain
{
[self stopBlowing:gain * 0.02];
}
// ******************************************************************************************
-(void) setJetReflection:(float)coefficient
{
jetReflection = coefficient;
}
// ******************************************************************************************
-(void) setEndReflection:(float)coefficient
{         
endReflection = coefficient;
}               
// ******************************************************************************************
-(void) setJetDelay:(float)aRatio
{
// Delay = length - approximate filter delay.
float temp = 44100.0 / lastFrequency - (float) 2.0;
jetRatio = aRatio;
[jetDelay setDelay:temp * aRatio]; // Scaled by ratio.
}
// ************************************************************************************************
-(OSStatus)		audioCallbackOnDevice:(AudioBufferList*)ioData bus:(UInt32)bus frame:(UInt32)inNumFrames time:(AudioTimeStamp*)timeStamp
{

if(!isActive) return [self RenderBlank:ioData bus:bus frame:inNumFrames];
UInt32 i;
float* out1 =(float*) ioData->mBuffers[0].mData;
float pressureDiff;
float breathPressure,temp;


for (i=0; i<inNumFrames; ++i) 
	{
	// Calculate the breath pressure (envelope + noise + vibrato)
	breathPressure = maxPressure * [adsr tick];
	breathPressure += breathPressure * noiseGain * (-1.0+random()%60000/30000.0);
	breathPressure += breathPressure * vibratoGain * [vibrato tick];

	temp = [filter filter:[boreDelay lastOut]];
	temp = [dcBlock filter:temp]; // Block DC on reflection.

	pressureDiff = breathPressure - (jetReflection * temp);
	pressureDiff = [jetDelay filter:pressureDiff];
	pressureDiff = [jetTable tick:pressureDiff]+ (endReflection * temp);
	lastOutput = (float) 0.3 * [boreDelay filter:pressureDiff];

	lastOutput *= outputGain;
	*out1++ = lastOutput;
	}


[self doMonoToStereoPan:ioData frame:inNumFrames];

return noErr;
}
// ******************************************************************************************
/*
-(void) controlChange(int number, float value)
{
  float norm = value * ONE_OVER_128;
  if ( norm < 0 ) {
    norm = 0.0;
    std::cerr << "Flute: Control value less than zero!" << std::endl;
  }
  else if ( norm > 1.0 ) {
    norm = 1.0;
    std::cerr << "Flute: Control value greater than 128.0!" << std::endl;
  }

  if (number == __SK_JetDelay_) // 2
    this->setJetDelay( (float) (0.08 + (0.48 * norm)) );
  else if (number == __SK_NoiseLevel_) // 4
    noiseGain = ( norm * 0.4);
  else if (number == __SK_ModFrequency_) // 11
    vibrato->setFrequency( norm * 12.0);
  else if (number == __SK_ModWheel_) // 1
    vibratoGain = ( norm * 0.4 );
  else if (number == __SK_AfterTouch_Cont_) // 128
    adsr->setTarget( norm );
  else
    std::cerr << "Flute: Undefined Control Number (" << number << ")!!" << std::endl;

#if defined(_STK_DEBUG_)
  std::cerr << "Flute: controlChange number = " << number << ", value = " << value << std::endl;
#endif
}
*/
// ******************************************************************************************

@end
