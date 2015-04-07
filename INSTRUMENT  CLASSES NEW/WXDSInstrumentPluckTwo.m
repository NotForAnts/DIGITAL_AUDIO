// ***************************************************************************************
//  WXDSInstrumentPluckTwo
//  Created by Paul Webb on Sun Aug 14 2005.
// ***************************************************************************************

#import "WXDSInstrumentPluckTwo.h"


@implementation WXDSInstrumentPluckTwo

// ***************************************************************************************

-(id) initPluckTwo:(float)lowestFrequency
{
if(self=[super init])
	{
	length = (long) (44100.0 / lowestFrequency + 1);
	baseLoopGain = (float) 0.995;
	loopGain = (float) 0.999;
	delayLine = [[WXFilterDelayA alloc]initDelay:(length / 2.0) md:length];
	delayLine2 = [[WXFilterDelayA alloc]initDelay:(length / 2.0) md:length];
	combDelay = [[WXFilterDelayL alloc]initDelay:(length / 2.0) md:length];
	filter = [[WXFilterOneZero alloc]init];;
	filter2 = [[WXFilterOneZero alloc]init];;
	pluckAmplitude = (float) 0.3;
	pluckPosition = (float) 0.4;
	detuning = (float) 0.995;
	lastFrequency = lowestFrequency * (float) 2.0;
	lastLength = length * (float) 0.5;
	}
return self;
}
// ***************************************************************************************

-(void) dealloc
{
[delayLine release];
[delayLine2 release];
[combDelay release];
[filter release];
[filter2 release];
[super dealloc];
}
// ***************************************************************************************

-(void) clear
{
[delayLine clear];
[delayLine2 clear];
[combDelay clear];
[filter clear];
[filter2 clear];
}
// ***************************************************************************************
-(void) setFrequency:(float)frequency
{
lastFrequency = frequency;
if ( lastFrequency <= 0.0 ) {
lastFrequency = 220.0;
}

// Delay = length - approximate filter delay.
lastLength = ( 44100.0 / lastFrequency);
float delay = (lastLength / detuning) - (float) 0.5;
if ( delay <= 0.0 ) delay = 0.3;
else if ( delay > length ) delay = length;
[delayLine setDelay:delay];

delay = (lastLength * detuning) - (float) 0.5;
if ( delay <= 0.0 ) delay = 0.3;
else if ( delay > length ) delay = length;
[delayLine2 setDelay:delay];

loopGain = baseLoopGain + (frequency * (float) 0.000005);
if ( loopGain > 1.0 ) loopGain = (float) 0.99999;
}
// ***************************************************************************************
-(void) setDetune:(float)detune
{
detuning = detune;
if ( detuning <= 0.0 ) {
detuning = 0.1;
}
[delayLine setDelay:( lastLength / detuning) - (float) 0.5];
[delayLine2 setDelay: (lastLength * detuning) - (float) 0.5];
}
// ***************************************************************************************
-(void) setFreqAndDetune:(float)frequency detune:(float)detune
{
detuning = detune;
[self setFrequency:frequency];
}
// ***************************************************************************************
-(void) setPluckPosition:(float)position
{
pluckPosition = position;
if ( position < 0.0 ) {
pluckPosition = 0.0;
}
else if ( position > 1.0 ) {
pluckPosition = 1.0;
}
}
// ***************************************************************************************
-(void)  setBaseLoopGain:(float)aGain
{
baseLoopGain = aGain;
loopGain = baseLoopGain + (lastFrequency * (float) 0.000005);
if ( loopGain > 0.99999 ) loopGain = (float) 0.99999;
}
// ***************************************************************************************
-(void) keyOFF:(float)amplitude
{
loopGain =  ((float) 1.0 - amplitude) * (float) 0.5;
}
// ***************************************************************************************

@end
