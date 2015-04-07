// ******************************************************************************************
//  WXDSInstrumentBlowHole
//  Created by Paul Webb on Mon Aug 15 2005.
// ******************************************************************************************

#import "WXDSInstrumentBlowHole.h"


@implementation WXDSInstrumentBlowHole

// ******************************************************************************************
-(id) initInstrumentBlowHole:(float)lowestFrequency
{
if(self=[super init])
	{
	length = (long) (44100.0 / lowestFrequency + 1);
	// delays[0] is the delay line between the reed and the register vent.
	delays[0] = [[WXFilterDelayL alloc]initDelay:5.0 * 44100.0 / 22050.0 md:100];
	// delays[1] is the delay line between the register vent and the tonehole.
	delays[1] = [[WXFilterDelayL alloc]initDelay:length >> 1 md:length];
	// delays[2] is the delay line between the tonehole and the end of the bore.
	delays[2] = [[WXFilterDelayL alloc]initDelay:4.0 * 44100.0 / 22050.0 md:100];
	reedTable = [[WXDSInstrumentReedTable alloc]init];
	[reedTable setOffset:(float) 0.7];
	[reedTable setSlope:(float) -0.3];
	filter = [[WXFilterOneZero alloc]init];
	blowEnvelope = [[WXDSInstrumentEnvelopeRamp alloc]init];


	// Calculate the initial tonehole three-port scattering coefficient
	double r_b = 0.0075;    // main bore radius
	r_th = 0.003;          // tonehole radius
	scatter = -pow(r_th,2) / ( pow(r_th,2) + 2*pow(r_b,2) );

	// Calculate tonehole coefficients
	float te = 1.4 * r_th;    // effective length of the open hole
	th_coeff = (te*2*44100.0 - 347.23) / (te*2*44100.0 + 347.23);
	tonehole = [[WXFilterPoleZero alloc]init];
	// Start with tonehole open
	[tonehole setA1:-th_coeff];
	[tonehole setB0:th_coeff];
	[tonehole setB1:-1.0];

	// Calculate register hole filter coefficients
	double r_rh = 0.0015;    // register vent radius
	te = 1.4 * r_rh;       // effective length of the open hole
	double xi = 0.0;         // series resistance term
	double zeta = 347.23 + 2*WXUPIE()*pow(r_b,2)*xi/1.1769;
	double psi = 2*WXUPIE()*pow(r_b,2)*te / (WXUPIE()*pow(r_rh,2));
	rh_coeff = (zeta - 2 * 44100.0 * psi) / (zeta + 2 * 44100.0 * psi);
	rh_gain = -347.23 / (zeta + 2 * 44100.0 * psi);
	vent = [[WXFilterPoleZero alloc]init];
	[vent setA1:rh_coeff];
	[vent setB0:1.0];
	[vent setB1:1.0];
	// Start with register vent closed
	[vent setGain:0.0];
	[self setTonehole:0.2];

	vibrato = [[WXDSWaveTable alloc]init];
	[vibrato loadWaveOfName: "rawwaves/sinewave.raw"];
	[vibrato setFrequencyForWave:(float) 5.735];
	outputGain = (float) 1.0;
	noiseGain = (float) 0.2;
	vibratoGain = (float) 0.01;
	}
return self;
}
// ******************************************************************************************
-(void) dealloc
{
[delays[0] release];
[delays[1] release];
[delays[2]release]; 
[reedTable release];
[filter release];
[tonehole release];
[vent release];
[blowEnvelope release];
[vibrato release];
  
[super dealloc]; 
}
// ******************************************************************************************
-(void) clear
{
[delays[0] clear];
[delays[1] clear];
[delays[2] clear];
[filter filter:0.0];
[tonehole filter:0.0];
[vent filter:0.0];
}
// ******************************************************************************************
-(void) setFrequency:(float)frequency
{
float freakency = frequency;
if ( frequency <= 0.0 ) freakency = 220.0;

// Delay = length - approximate filter delay.
float delay = (44100.0 / freakency) * 0.5 - 3.5;
delay -= [delays[0] getDelay] + [delays[2] getDelay];

if (delay <= 0.0) delay = 0.3;
else if (delay > length) delay = length;
[delays[1] setDelay:delay];
}
// ******************************************************************************************
-(void) setVent:(float)newValue
{
// This method allows setting of the register vent "open-ness" at
// any point between "Open" (newValue = 1) and "Closed"
// (newValue = 0).

float gain;

if (newValue <= 0.0) gain = 0.0;
else if (newValue >= 1.0) gain = rh_gain;
else gain = newValue * rh_gain;
[vent setGain:gain];
}
// ******************************************************************************************
-(void) setTonehole:(float)newValue
{
// This method allows setting of the tonehole "open-ness" at
// any point between "Open" (newValue = 1) and "Closed"
// (newValue = 0).
float new_coeff;

if (newValue <= 0.0) new_coeff = 0.9995;
else if (newValue >= 1.0) new_coeff = th_coeff;
else new_coeff = (newValue * (th_coeff - 0.9995)) + 0.9995;
[tonehole setA1:-new_coeff];
[tonehole setB0:new_coeff];
}
// ******************************************************************************************
-(void) startBlowing:(float)amplitude rate:(float)rate
{
[blowEnvelope setRate:rate/100.0];
[blowEnvelope setTarget:amplitude]; 
[blowEnvelope keyOnWithGain:1.0];
}
// ******************************************************************************************
-(void) stopBlowing:(float)rate
{
[blowEnvelope setRate:rate];
[blowEnvelope setTarget:(float) 0.0]; 
}
// ******************************************************************************************
-(void) keyONWithFreqGain:(float)freq gain:(float)gain
{
[self setFrequency:freq];
[self startBlowing:(float) 0.55 + (gain * 0.30) rate:gain * 0.005];
outputGain = gain + 0.001;
}
// ******************************************************************************************
-(void) keyOFF:(float)gain
{
[self stopBlowing:gain * 0.01];
}
// ************************************************************************************************
-(OSStatus)		audioCallbackOnDevice:(AudioBufferList*)ioData bus:(UInt32)bus frame:(UInt32)inNumFrames time:(AudioTimeStamp*)timeStamp
{
if(!isActive) return [self RenderBlank:ioData bus:bus frame:inNumFrames];
UInt32 i;
float* out1 =(float*) ioData->mBuffers[0].mData;


  float pressureDiff;
  float breathPressure;
  float temp,pa,pb,pth;

for (i=0; i<inNumFrames; ++i) 
	{
	// Calculate the breath pressure (blowEnvelope + noise + vibrato)
	breathPressure = [blowEnvelope tick]; 
	breathPressure += breathPressure * noiseGain * (-1.0+random()%60000/30000.0);
	breathPressure += breathPressure * vibratoGain * [vibrato tick];

	// Calculate the differential pressure = reflected - mouthpiece pressures
	pressureDiff = [delays[0] lastOut] - breathPressure;

	// Do two-port junction scattering for register vent
	pa = breathPressure + pressureDiff * [reedTable tick:pressureDiff];
	pb = [delays[1] lastOut];
	[vent filter:pa+pb];

	lastOutput = [delays[0] filter:[vent lastOut]+pb];
	lastOutput *= outputGain;

	// Do three-port junction scattering (under tonehole)
	pa += [vent lastOut];
	pb = [delays[2] lastOut];
	pth = [tonehole lastOut];
	temp = scatter * (pa + pb - 2 * pth);

	[delays[2] filter:[filter filter:pa + temp] * -0.95];
	[delays[1] filter:pb + temp];
	[tonehole filter:pa + pb - pth + temp];

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
    std::cerr << "BlowHole: Control value less than zero!" << std::endl;
  }
  else if ( norm > 1.0 ) {
    norm = 1.0;
    std::cerr << "BlowHole: Control value greater than 128.0!" << std::endl;
  }

  if (number == __SK_ReedStiffness_) // 2
    reedTable->setSlope( -0.44 + (0.26 * norm) );
  else if (number == __SK_NoiseLevel_) // 4
    noiseGain = ( norm * 0.4);
  else if (number == __SK_ModFrequency_) // 11
    this->setTonehole( norm );
  else if (number == __SK_ModWheel_) // 1
    this->setVent( norm );
  else if (number == __SK_AfterTouch_Cont_) // 128
    blowEnvelope->setValue( norm );
  else
    std::cerr << "BlowHole: Undefined Control Number (" << number << ")!!" << std::endl;

#if defined(_STK_DEBUG_)
  std::cerr << "BlowHole: controlChange number = " << number << ", value = " << value << std::endl;
#endif
}
*/
// ******************************************************************************************

@end
