// ***************************************************************************************
//  WXGrainFilterEnvelope
//  Created by Paul Webb on Mon Jan 03 2005.
// ***************************************************************************************
#import "WXGrainFilterEnvelope.h"

// ***************************************************************************************
@implementation WXGrainFilterEnvelope


// ***************************************************************************************
-(id)			initWithFilter:(WXFilterBase*)filterObject filterTime:(int)filterTime
{
if(self=[super init])
	{
	theFilter=filterObject;
	[theFilter retain];
	filterDecayTime=filterTime;
	}
return self;
}
// ***************************************************************************************
-(void)			dealloc
{
[theFilter release];
[super dealloc];
}
// ***************************************************************************************
-(void)			initGrain:(float)freq gain:(float)g pan:(float)pan dur:(int)dur wave:(float*)wp env:(float*)ep index:(int)i
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
waveIncrement=frequency*2.0;
grainWaveModulas=88200;
startSampleTime=0;

// clear stuff for filter
[theFilter clear];
tickCountDown+=filterDecayTime;
filterGainDelta=gain/(float)filterDecayTime;
}
// ***************************************************************************************
-(void)			setFilterAs:(WXFilterBase*)filterObject
{
theFilter=filterObject;
}
// ***************************************************************************************
-(void)			setFilterTime:(int)filterTime
{
filterDecayTime=filterTime;
}
// ***************************************************************************************
-(WXFilterBase*)	getFilter
{
return theFilter;
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
	
if(tickCountDown>filterDecayTime)
		{
		sample=wavePointer[((int)waveIndex)%grainWaveModulas];
		waveIndex+=waveIncrement;
		sample=sample*envelopePointer[(int)envelopeIndex];
		envelopeIndex+=envelopeIncrement;
		}
else
	{
	sample=0;	
	gain+=filterGainDelta;
	}

sample=[theFilter filter:sample];
sample*=gain;
rightSample=sample*panPosition;
leftSample=sample*(1.0-panPosition);
}
// ***************************************************************************************


@end
