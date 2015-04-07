// ******************************************************************************************
//  WXDSInstrumentBlowBottle
//  Created by Paul Webb on Mon Aug 15 2005.
// ******************************************************************************************

#import "WXDSInstrumentBlowBottle.h"


@implementation WXDSInstrumentBlowBottle

// ******************************************************************************************
-(id) init
{
if(self=[super init])
	{
	jetTable = [[WXDSInstrumentJetTable alloc]init];

	dcBlock =[[WXFilterPoleZero alloc]init];
	[dcBlock setBlockZeroDef];


	vibrato = [[WXDSWaveTable alloc]init];
	[vibrato loadWaveOfName: "rawwaves/sinewave.raw"];
	[vibrato setFrequencyForWave:(float) 5.925]; 

	vibratoGain = 0.0;

	resonator=[[WXFilterBiQuad alloc]init];
	[resonator setResonance:500.0 radius:__BOTTLE_RADIUS__ normalise:YES];

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
}
// ******************************************************************************************
-(void) setFrequency:(float)frequency
{
float freakency = frequency;
if ( frequency <= 0.0 ) {
freakency = 220.0;
}

[resonator setResonance:freakency radius:__BOTTLE_RADIUS__ normalise:YES];
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
float pressureDiff;
for (i=0; i<inNumFrames; ++i) 
	{
	// Calculate the breath pressure (envelope + vibrato)
	breathPressure = maxPressure * [adsr tick];
	breathPressure += vibratoGain * [vibrato tick];

	pressureDiff = breathPressure - [resonator lastOut];

	randPressure = noiseGain * (-1.0+random()%60000/30000.0);
	randPressure *= breathPressure;
	randPressure *= (1.0 + pressureDiff);

	[resonator filter:breathPressure + randPressure - ( [jetTable tick: pressureDiff] * pressureDiff ) ];
	lastOutput = 0.2 * outputGain * [dcBlock filter:pressureDiff];

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
    std::cerr << "BlowBotl: Control value less than zero!" << std::endl;
  }
  else if ( norm > 1.0 ) {
    norm = 1.0;
    std::cerr << "BlowBotl: Control value greater than 128.0!" << std::endl;
  }

  if (number == __SK_NoiseLevel_) // 4
    noiseGain = norm * 30.0;
  else if (number == __SK_ModFrequency_) // 11
    vibrato->setFrequency( norm * 12.0 );
  else if (number == __SK_ModWheel_) // 1
    vibratoGain = norm * 0.4;
  else if (number == __SK_AfterTouch_Cont_) // 128
    adsr->setTarget( norm );
  else
    std::cerr << "BlowBotl: Undefined Control Number (" << number << ")!!" << std::endl;

#if defined(_STK_DEBUG_)
  std::cerr << "BlowBotl: controlChange number = " << number << ", value = " << value << std::endl;
#endif
}

*/
// ******************************************************************************************


@end
