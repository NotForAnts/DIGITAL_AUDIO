// ******************************************************************************************
//  WXDSPulsarSynth.h
//  Created by Paul Webb on Tue Jan 04 2005.
// ******************************************************************************************
#import "WXDSPulsarSynth.h"


@implementation WXDSPulsarSynth


// ***************************************************************************************
-(id)   init
{
if(self=[super init])
	{
	psamples=[self DurMS:25];
	dsamples=[self DurMS:2];
	
	vangle1=vangle2=0.0;
	}
return self;
}
// ******************************************************************************************
// init the wavetables used for the pulsar synth
// NOTE THAT FREQUENCIES ARE ALREADY AT HIGHER FREQ THAN 1htz
// ******************************************************************************************
-(void) initialiseWaveTables
{
[self setWaveTable:0 table:[waveTableMaker makePulseTable:88200 r1:-1.0 r2:1.0 freq:220.0 pulsePercent:90]];
[self setWaveTable:1 table:[waveTableMaker makePulseTable:88200 r1:-1.0 r2:1.0 freq:220.0 pulsePercent:70]];
[self setWaveTable:2 table:[waveTableMaker makePulseTable:88200 r1:-1.0 r2:1.0 freq:220.0 pulsePercent:50]];
[self setWaveTable:3 table:[waveTableMaker makePulseTable:88200 r1:-1.0 r2:1.0 freq:220.0 pulsePercent:30]];
[self setWaveTable:4 table:[waveTableMaker makeSincPulseWaveTable:88200 r1:-1 r2:1.0 freq:220.0 phases:32]];
[self setWaveTable:5 table:[waveTableMaker makeSincPulseWaveTable:88200 r1:-1 r2:1.0 freq:220.0 phases:16]];
[self setWaveTable:6 table:[waveTableMaker makeSincPulseWaveTable:88200 r1:-1 r2:1.0 freq:220.0 phases:8]];
[self setWaveTable:7 table:[waveTableMaker makeNoisePulseWave:88200 r1:-1 r2:1.0 freq:220.0 pulsePercent:3]];


[self setEnvelopeTable:0 table:[waveTableMaker makeGaussianEnvelope:44100 r1:0.0 r2:1.0]];
[self setEnvelopeTable:1 table:[waveTableMaker makeQuasiGaussianEnvelope:44100 flat:10000 r1:0.0 r2:1.0]];
[self setEnvelopeTable:2 table:[waveTableMaker makeSmoothSineEnvelope:44100 r1:0.0 r2:1.0]];
[self setEnvelopeTable:3 table:[waveTableMaker makeShiftedHalfSineEnvelope:44100 p1:5000 p2:35100 r1:0.0 r2:1.0]];
[self setEnvelopeTable:4 table:[waveTableMaker makeThreeStageTriangleEnvelope:44100 r1:0.0 r2:1.0 flat:30000]];
[self setEnvelopeTable:5 table:[waveTableMaker makeTriangleEnvelope:44100 r1:0.0 r2:1.0]];
[self setEnvelopeTable:6 table:[waveTableMaker makeExpodecEnvelope:44100 r1:0.0 r2:1.0]];
[self setEnvelopeTable:7 table:[waveTableMaker makeRexpodecEnvelope:44100 r1:0.0 r2:1.0 e1:0 e2:5.0]];
[self setEnvelopeTable:8 table:[waveTableMaker makeSincEnvelope:44100 r1:0.0 r2:1.0 phases:5.0]];
}
// ******************************************************************************************
// spawn new grains - pulsar style
// ******************************************************************************************
-(void)		addGrainProcess
{
if(counter!=nextGrainAtCounter)		return;
int i=[self getFreeIndexAndUpdateGrainList];
if(i<0) return;

[grains[i] initGrain:
1000.25+sin(vangle2+vangle1)*999.0
gain:0.8
pan:0.5
dur:dsamples
wave:grainWaves[2]
env:grainEnvelope[8]
index:i];


dsamples=200+sin(vangle1)*130;
psamples=1500+sin(vangle2)*908;
vangle1+=0.1;
vangle2+=0.05;

//dsamples-=2;
//if(dsamples<10) dsamples=44*5;
//psamples-=5;
//if(psamples<10) psamples=44*25;

nextGrainAtCounter+=psamples;
}
// ******************************************************************************************


@end
