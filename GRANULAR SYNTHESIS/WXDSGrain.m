// ***************************************************************************************
//  WXDSGrain
//  Created by Paul Webb on Thu Dec 30 2004.
// ***************************************************************************************
#import "WXDSGrain.h"


@implementation WXDSGrain

// ***************************************************************************************
-(id)			init
{
if(self=[super init])
	{
	tickCountDown=0;
	prevGrain=0;
	nextGrain=0;
	leftSample=rightSample=0.0;
	panPosition=0.5;
	}
return self;
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
}
// ***************************************************************************************
-(void)			setGrainWaveModulas:(int)mod
{
grainWaveModulas=mod;
}
// ***************************************************************************************
-(void)			setStartTime:(int)sampleTime
{
startSampleTime=sampleTime;
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
sample=sample*envelopePointer[(int)envelopeIndex];
envelopeIndex+=envelopeIncrement;
sample*=gain;
rightSample=sample*panPosition;
leftSample=sample*(1.0-panPosition);
}
// ***************************************************************************************
-(void)			getLeftRight:(float*)ls right:(float*)rs
{
*ls=leftSample;
*rs=rightSample;
}
// ***************************************************************************************
-(float)		getLeftSample
{
return leftSample;
}
// ***************************************************************************************
-(float)		getRightSample
{
return rightSample;
}
// ***************************************************************************************
-(int)			getCountDown
{
return tickCountDown;
}
// ***************************************************************************************
-(int)			getIndex
{
return index;
}
// ***************************************************************************************
-(void)			removeSelfFromGrainList
{
if(prevGrain!=0) [prevGrain setNext:nextGrain];
if(nextGrain!=0) [nextGrain setPrev:prevGrain];
prevGrain=0;
}
// ***************************************************************************************
-(void)			setNext:(WXDSGrain*)grain
{
nextGrain=grain;
}
// ***************************************************************************************
-(void)			setPrev:(WXDSGrain*)grain
{
prevGrain=grain;
}
// ***************************************************************************************
-(void)			setPrevAndNext:(WXDSGrain*)prev next:(WXDSGrain*)next
{
prevGrain=prev;
nextGrain=next;
}
// ***************************************************************************************
-(WXDSGrain*)   getNext
{
return nextGrain;
}
// ***************************************************************************************
-(WXDSGrain*)   getPrev
{
return prevGrain;
}
// ***************************************************************************************


@end
