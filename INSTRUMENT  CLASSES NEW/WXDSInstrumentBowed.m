// ***************************************************************************************
//  WXDSInstrumentBowed
//  Created by Paul Webb on Mon Aug 15 2005.
// ***************************************************************************************

#import "WXDSInstrumentBowed.h"


@implementation WXDSInstrumentBowed

// ***************************************************************************************
-(id)   initInstrumentBowed:(float)lowestFrequency
{
if(self=[super init])
	{
	long length;
	length = (long) (44100.0 / lowestFrequency + 1);

	neckDelay =[[WXFilterDelayL alloc]initDelay:100.0 md:length];
	length >>= 1;
	bridgeDelay = [[WXFilterDelayL alloc]initDelay:29.0 md:length];

	bowTable = [[WXDSInstrumentBowTable alloc]init];
	[bowTable setSlope:(float) 3.0];

	vibrato = [[WXDSWaveTable alloc]init];
	[vibrato loadWaveOfName: "rawwaves/sinewave.raw"];
	[vibrato setFrequency:6.12723/(512.0)];
	vibratoGain = (float) 0.0;

	stringFilter = [[WXFilterOnePole alloc]init];
	[stringFilter setPole:(float) (0.6 - (0.1 * 22050.0 / 44100.0 ) ) ];
	[stringFilter setGain:(float) 0.95];

	bodyFilter = [[WXFilterBiQuad alloc]init];
	[bodyFilter setResonance:500.0 radius:0.85 normalise:YES];
	[bodyFilter setGain:0.2];

	adsr =[[WXDSInstrumentEnvelopeBase alloc]init];
	//adsr->setAllTimes((float) 0.02,(float) 0.005,(float) 0.9,(float) 0.01);
	[adsr setAttack:1.0 time:0.02];
	[adsr setDecay:0.9 time:0.005];
	[adsr setRelease:0.0 time:0.01];	

	betaRatio = (float) 0.127236;

	// Necessary to initialize internal variables.
	[self setFrequency:220.0];
	}
return self;
}
// ***************************************************************************************
-(void) dealloc
{
[neckDelay release];
[bridgeDelay release];
[bowTable release];
[stringFilter release];
[bodyFilter release];
[vibrato release];
[adsr release];
[super dealloc] ; 
}
// ***************************************************************************************
-(void) clea
{
[neckDelay clear];
[bridgeDelay clear];
}
// ***************************************************************************************
-(void) setFrequency:(float)frequency
{
float freakency = frequency;
if ( frequency <= 0.0 ) {
freakency = 220.0;
}

// Delay = length - approximate filter delay.
baseDelay = 44100.0 / freakency - (float) 4.0;
if ( baseDelay <= 0.0 ) baseDelay = 0.3;
[bridgeDelay setDelay:baseDelay * betaRatio]; 	               // bow to bridge length
[neckDelay setDelay:baseDelay * ((float) 1.0 - betaRatio)]; // bow to nut (finger) length
}
// ***************************************************************************************
-(void) startBowing:(float)amplitude rate:(float)rate
{
[adsr setRate:rate];
[adsr keyOnWithGain:1.0];
maxVelocity = (float) 0.03 + ((float) 0.2 * amplitude); 
}
// ***************************************************************************************
-(void) stopBowing:(float)rate
{
[adsr setRate:rate];
[adsr keyOff];
}
// ***************************************************************************************

-(void) keyONWithFreqGain:(float)freq gain:(float)gain
{
[self startBowing:gain rate:gain * 0.001];
[self setFrequency:freq];
}
// ***************************************************************************************
-(void) keyOFF:(float)gain
{
[self stopBowing:((float) 1.0 - gain) * (float) 0.005];
}
// ***************************************************************************************
-(void) setVibrato:(float)gain
{
vibratoGain = gain;
}
// ************************************************************************************************
-(OSStatus)		audioCallbackOnDevice:(AudioBufferList*)ioData bus:(UInt32)bus frame:(UInt32)inNumFrames time:(AudioTimeStamp*)timeStamp
{

if(!isActive) return [self RenderBlank:ioData bus:bus frame:inNumFrames];
UInt32 i;
float* out1 =(float*) ioData->mBuffers[0].mData;
float bowVelocity;
float bridgeRefl;
float nutRefl;
float newVel;
float velDiff;
float stringVel;
   
	
for (i=0; i<inNumFrames; ++i) 
	{
	bowVelocity = maxVelocity * [adsr tick];

	bridgeRefl = -[stringFilter filter:[bridgeDelay lastOut]];
	nutRefl = -[neckDelay lastOut];
	stringVel = bridgeRefl + nutRefl;               // Sum is String Velocity
	velDiff = bowVelocity - stringVel;              // Differential Velocity
	newVel = velDiff * [bowTable tick:velDiff];		// Non-Linear Bow Function
	[neckDelay filter:bridgeRefl + newVel];			// Do string propagations
	[bridgeDelay filter:nutRefl + newVel];

	if (vibratoGain > 0.0)  
		{
		[neckDelay setDelay:(baseDelay * ((float) 1.0 - betaRatio)) + 
						(baseDelay * vibratoGain * [vibrato tick])];
		}

	lastOutput = [bodyFilter filter:[bridgeDelay lastOut]];                 
	*out1++ = lastOutput;
	}


[self doMonoToStereoPan:ioData frame:inNumFrames];

return noErr;
}
// ***************************************************************************************
/*
-(void) controlChange(int number, float value)
{
  float norm = value * ONE_OVER_128;
  if ( norm < 0 ) {
    norm = 0.0;
    std::cerr << "Bowed: Control value less than zero!" << std::endl;
  }
  else if ( norm > 1.0 ) {
    norm = 1.0;
    std::cerr << "Bowed: Control value greater than 128.0!" << std::endl;
  }

  if (number == __SK_BowPressure_) // 2
		bowTable->setSlope( 5.0 - (4.0 * norm) );
  else if (number == __SK_BowPosition_) { // 4
		betaRatio = 0.027236 + (0.2 * norm);
    bridgeDelay->setDelay(baseDelay * betaRatio);
    neckDelay->setDelay(baseDelay * ((float) 1.0 - betaRatio));
  }
  else if (number == __SK_ModFrequency_) // 11
    vibrato->setFrequency( norm * 12.0 );
  else if (number == __SK_ModWheel_) // 1
    vibratoGain = ( norm * 0.4 );
  else if (number == __SK_AfterTouch_Cont_) // 128
    adsr->setTarget(norm);
  else
    std::cerr << "Bowed: Undefined Control Number (" << number << ")!!" << std::endl;

#if defined(_STK_DEBUG_)
  std::cerr << "Bowed: controlChange number = " << number << ", value = " << value << std::endl;
#endif
}
*/
// ***************************************************************************************
@end
