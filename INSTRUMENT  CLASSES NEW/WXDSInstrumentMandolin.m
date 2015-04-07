// ***************************************************************************************
//  WXDSInstrumentMandolin
//  Created by Paul Webb on Sun Aug 14 2005.
// ***************************************************************************************

#import "WXDSInstrumentMandolin.h"


@implementation WXDSInstrumentMandolin

// ***************************************************************************************

-(id)   initMandolin:(float)lowestFrequency
{
if(self=[super initPluckTwo:lowestFrequency])
	{
	int t;
	for(t=0;t<11;t++)
			 soundfile[t]=[[WXDSWaveTable alloc]init];
	// Concatenate the STK rawwave path to the rawwave files

	[soundfile[0] loadWaveOfName: "rawwaves/mand1.raw"];
	[soundfile[1] loadWaveOfName: "rawwaves/mand2.raw"];
	[soundfile[2] loadWaveOfName:"rawwaves/mand3.raw"];
	[soundfile[3] loadWaveOfName:"rawwaves/mand4.raw"];
	[soundfile[4] loadWaveOfName:"rawwaves/mand5.raw"];
	[soundfile[5] loadWaveOfName:"rawwaves/mand6.raw"];
	[soundfile[6] loadWaveOfName:"rawwaves/mand7.raw"];
	[soundfile[7] loadWaveOfName:"rawwaves/mand8.raw"];
	[soundfile[8] loadWaveOfName:"rawwaves/mand9.raw"];
	[soundfile[9] loadWaveOfName:"rawwaves/mand10.raw"];
	[soundfile[10] loadWaveOfName:"rawwaves/mand11.raw"];
	[soundfile[11] loadWaveOfName:"rawwaves/mand12.raw"];

	pluckPosition=0.5;
	pluckAmplitude=0.0;
	lastOutput=0.0;
	directBody = 1.0;
	mic = 3;
	dampTime = 0;
	waveDone = [soundfile[mic] finished];
	[self setBodySize:1];
  }
return self;
}
// ***************************************************************************************
-(void) dealloc
{
int i;
for (i=0; i<12; i++ )
    [soundfile[i] release];

[super dealloc];	
}
// ***************************************************************************************
-(void) pluck:(float)amplitude
{
// This function gets interesting, because pluck
// may be longer than string length, so we just
// reset the soundfile and add in the pluck in
// the tick method.
[soundfile[mic] gotoStartOfWave];
waveDone = NO;
pluckAmplitude = amplitude;
if ( amplitude < 0.0 ) {
pluckAmplitude = 0.0;
}
else if ( amplitude > 1.0 ) {
pluckAmplitude = 1.0;
}

// Set the pick position, which puts zeroes at position * length.
[combDelay setDelay:(float) 0.5 * pluckPosition * lastLength]; 
dampTime = (long) lastLength;   // See tick method below.
}
// ***************************************************************************************
-(void) pluck:(float)amplitude  position:(float)position
{
// Pluck position puts zeroes at position * length.
pluckPosition = position;
if ( position < 0.0 ) {
pluckPosition = 0.0;
}
else if ( position > 1.0 ) {
pluckPosition = 1.0;
}

[self pluck:amplitude];
}
// ************************************************************************************************

-(void) keyONWithFreqGain:(float)freq gain:(float)gain
{
[self setFrequency:freq];
[self pluck:gain];
}
// ************************************************************************************************
-(void) keyOFF
{

}
// ***************************************************************************************
-(void) setBodySize:(float)size
{
// Scale the commuted body response by its sample rate (22050).
float rate = size * 22050.0 / 44100.0;
rate=1.0/rate;
int i;
for (i=0; i<12; i++ )
	[soundfile[i] setFrequency:rate];
}
// ************************************************************************************************
-(OSStatus)		audioCallbackOnDevice:(AudioBufferList*)ioData bus:(UInt32)bus frame:(UInt32)inNumFrames time:(AudioTimeStamp*)timeStamp
{

if(!isActive) return [self RenderBlank:ioData bus:bus frame:inNumFrames];
UInt32 i;
float* out1 =(float*) ioData->mBuffers[0].mData;
float temp = 0.0;
 
 
for (i=0; i<inNumFrames; ++i) 
	{
	if ( !waveDone ) 
		{
		// Scale the pluck excitation with comb
		// filtering for the duration of the file.
		temp = [soundfile[mic] tickTillEnd] * pluckAmplitude;
		temp = temp - [combDelay filter:temp];
		waveDone = [soundfile[mic] finished];
		}
	
	  // Damping hack to help avoid overflow on re-plucking.

	  if ( dampTime >=0 ) {
		dampTime -= 1;
		// Calculate 1st delay filtered reflection plus pluck excitation.
		lastOutput = [delayLine filter: [filter filter: temp + ([delayLine lastOut] * (float) 0.7) ]];
		// Calculate 2nd delay just like the 1st.
		lastOutput +=[delayLine2 filter:[filter2 filter:temp + ([delayLine2 lastOut] * (float) 0.7) ]];
	  }
	  else { // No damping hack after 1 period.
		// Calculate 1st delay filtered reflection plus pluck excitation.
		lastOutput = [delayLine filter: [filter filter:temp + ([delayLine lastOut] * loopGain) ]];
		// Calculate 2nd delay just like the 1st.
		lastOutput +=[delayLine2 filter: [filter filter:temp + ([delayLine2 lastOut] * loopGain) ]];
	  }

	lastOutput *= (float) 0.3;
	*out1++ = lastOutput;
	}


[self doMonoToStereoPan:ioData frame:inNumFrames];

return noErr;
}
// ***************************************************************************************

-(void) controlChange:(int)number value:(float)value
{
  float norm = value * 1.0/128.0;//ONE_OVER_128;
  if ( norm < 0 ) {
    norm = 0.0;
  }
  else if ( norm > 1.0 ) {
    norm = 1.0;
  }
/*
if (number == __SK_BodySize_) // 2
this->setBodySize( norm * 2.0 );
else if (number == __SK_PickPosition_) // 4
this->setPluckPosition( norm );
else if (number == __SK_StringDamping_) // 11
this->setBaseLoopGain((float) 0.97 + (norm * (float) 0.03));
else if (number == __SK_StringDetune_) // 1
this->setDetune((float) 1.0 - (norm * (float) 0.1));
else if (number == __SK_AfterTouch_Cont_) // 128
mic = (int) (norm * 11.0);
*/
}
// ***************************************************************************************

@end
