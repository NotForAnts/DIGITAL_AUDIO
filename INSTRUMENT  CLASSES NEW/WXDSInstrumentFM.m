// ******************************************************************************************
//  WXDSInstrumentFM
//  Created by Paul Webb on Sun Aug 14 2005.
// ******************************************************************************************

#import "WXDSInstrumentFM.h"


@implementation WXDSInstrumentFM

// ******************************************************************************************
-(id)   initInstrumentFM:(short)nopss
{
if(self=[super init])
	{
	masterGain=2.0;
	nOperators=nopss;
	
	twozero = [[WXFilterTwoZero alloc]init];
	[twozero setB2:-1.0];
	[twozero setGain:0.0];

	waveMaker=[[WXDSEnvelopeTableMaker alloc]init];
	vibrato=[[WXDSWaveTable alloc]init];
	[vibrato setWave:[waveMaker makeSineWaveTable:44100 r1:-1.0 r2:1.0 freq:1.0]];
	[vibrato setFrequencyForWave:2.0];
	
	int i;

	  for (i=0; i<nOperators; i++ ) 
		{
		ratios[i] = 1.0;
		gains[i] = 1.0;
		waves[i]=[[WXDSWaveTable alloc]init];
		[waves[i] setWave:[waveMaker makeSineWaveTable:44100 r1:-1.0 r2:1.0 freq:1.0]];
		adsr[i] = [[WXDSInstrumentEnvelopeBase alloc]init];
		}
		
		
	  [waves[3] setWave:[waveMaker makeRampTable:44100 freq:@"1,3" amp:@"1,1" r1:-1.0 r2:1.0]];

	  modDepth = (float) 0.0;
	  control1 = (float) 1.0;
	  control2 = (float) 1.0;
	  baseFrequency = (float) 440.0;

	  float temp = 1.0;
	  for (i=99; i>=0; i--) {
		__FM_gains[i] = temp;
		temp *= 0.933033;
	  }

	  temp = 1.0;
	  for (i=15; i>=0; i--) {
		__FM_susLevels[i] = temp;
		temp *= 0.707101;
	  }

	  temp = 8.498186;
	  for (i=0; i<32; i++) {
		__FM_attTimes[i] = temp;
		temp *= 0.707101;
	  }

	}

return self;
}

// ************************************************************************************************
-(void) setRatio:(int)waveIndex ratio:(float)ratio
{
ratios[waveIndex] = ratio;
if (ratio > 0.0) 
	[waves[waveIndex] setFrequencyForWave:baseFrequency * ratio];
else
    [waves[waveIndex] setFrequencyForWave:-ratio];
}
// ************************************************************************************************
-(void)		keyOFF
{
int i;
for (i=0; i<nOperators; i++ )
	[adsr[i] keyOff];
}
// ************************************************************************************************
-(void)		keyONWithFreqGain:(float)freq gain:(float)gain
{
noteFrequency=freq;
[self setFrequency:noteFrequency];
[envelope keyOnWithGain:gain];
[self doKeyOnExtra:freq];
int i;
for (i=0; i<nOperators; i++ ) 
	{
	[adsr[i] keyOnWithGain:gain];
	}
	
gains[0] = gain * __FM_gains[94];
gains[1] = gain * __FM_gains[76];
gains[2] = gain * __FM_gains[99];
gains[3] = gain * __FM_gains[71];	

baseFrequency = noteFrequency;
for (i=0; i<nOperators; i++ )
	[waves[i] setFrequency:baseFrequency * ratios[i]];
}
// ************************************************************************************************
-(OSStatus)		audioCallbackOnDevice:(AudioBufferList*)ioData bus:(UInt32)bus frame:(UInt32)inNumFrames time:(AudioTimeStamp*)timeStamp
{

if(!isActive) return [self RenderBlank:ioData bus:bus frame:inNumFrames];
UInt32 i;
float* out1 =(float*) ioData->mBuffers[0].mData;
float temp, temp2;
 
for (i=0; i<inNumFrames; ++i) 
	{

	temp = gains[1] * [adsr[1] tick] * [waves[1] tick];
	temp = temp * control1;

	[waves[0] addPhaseOffset:temp];
	[waves[3] addPhaseOffset:[twozero lastOut]];
	temp = gains[3] * [adsr[3] tick] * [waves[3] tick];
	[twozero filter:temp];

	[waves[2] addPhaseOffset:temp];
	temp = ( 1.0 - (control2 * 0.5)) * gains[0] * [adsr[0] tick] * [waves[0] tick];
	temp += control2 * 0.5 * gains[2] * [adsr[2] tick] * [waves[2] tick];


	// Calculate amplitude modulation and apply it to output.
	temp2 = [vibrato tick] * modDepth;
	temp = temp * (1.0 + temp2);
    
	theSample = temp * 0.5;
	*out1++ = theSample;
	}


[self doMonoToStereoPan:ioData frame:inNumFrames];

return noErr;
}
// ************************************************************************************************

@end
