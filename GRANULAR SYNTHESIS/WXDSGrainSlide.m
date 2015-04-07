// ***************************************************************************************
//  WXDSGrainSlide
//  Created by Paul Webb on Thu Dec 30 2004.
//
//  A granular synthesis grain which does pitch slide (portamentos)
//  BIRD CALLS
// ***************************************************************************************

#import "WXDSGrainSlide.h"


@implementation WXDSGrainSlide

// ***************************************************************************************
-(void)			initSlideGrain:(float)freq freq2:(float)freq2 gain:(float)g pan:(float)pan dur:(int)dur wave:(float*)wp env:(float*)ep index:(int)i
{
index=i;
frequency=freq;
gain=g;
wavePointer=wp;
envelopePointer=ep;
tickCountDown=dur;
panPosition=pan;
waveIndex=0;
envelopeIndex=0;
envelopeIncrement=44100.0/(float)dur;
grainWaveModulas=88200;
startSampleTime=0;
waveIncrement=frequency*2.0;

grainFreq1=freq;
grainFreq2=freq2;

// calculate the change to the waveIncrement to go from f1...f2 in 'dur' samples
waveIncrementFinal=freq2*2.0;
deltaFreq=(waveIncrementFinal-waveIncrement)/(float)tickCountDown;
}
// ***************************************************************************************
-(void)			tick
{
if(tickCountDown>0) tickCountDown--; 
else 
	{
	leftSample=rightSample=0.0;
	return;
	}

sample=wavePointer[((int)waveIndex)%grainWaveModulas];
waveIndex+=waveIncrement;
waveIncrement+=deltaFreq;
sample=sample*envelopePointer[(int)envelopeIndex];
envelopeIndex+=envelopeIncrement;
sample*=gain;
rightSample=sample*panPosition;
leftSample=sample*(1.0-panPosition);
}
// ***************************************************************************************


@end
