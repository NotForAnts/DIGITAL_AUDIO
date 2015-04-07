// ************************************************************************************************
//  WXDSAdsr
//  Created by Paul Webb on Wed Jan 12 2005.
// ************************************************************************************************

#import "WXDSAdsr.h"

// ************************************************************************************************

@implementation WXDSAdsr
// ************************************************************************************************
-(id)   init
{
if(self=[super init])
	{
	value=0.0;
	state=0;
	[self setAttack:1.0 time:1.0];
	[self setDecay:0.5 time:1.0];
	[self setRelease:0.0 time:1.0];
	gain=1.0;
	}
return self;
}
// ************************************************************************************************
-(void)		keyOnWithGainAndecayDeltauration:(float)g dur:(float)duration
{
noteDuration=duration*44100.0;;
sustainTime=noteDuration-(attackTime+decayTime+releaseTime);
gain=g;
state=1;
value=0.0;
}
// ************************************************************************************************
// this is used so if note on before release finishes it starts from where left off
// ************************************************************************************************
-(void)		keyOnWithReGain:(float)g
{
noteDuration=0;
gain=g;
state=1;
}
// ************************************************************************************************
-(void)		keyOnWithGain:(float)g
{
noteDuration=0;
gain=g;
state=1;
value=0.0;
}
// ************************************************************************************************
-(void)		keyOff
{
releaseDelta=(releaseLevel-value)/releaseTime;
state=4;
}
// ************************************************************************************************
-(BOOL)		hasFinished
{
if(state==0)	return YES;
return NO;
}
// ************************************************************************************************
// 0=done 1=attack 2=delay 3=sustain 4=release
// ************************************************************************************************
-(short)   getCurrentState
{
return state;
}
// ************************************************************************************************
-(void)		setAttack:(float)l time:(float)t
{
attackLevel=l;  
attackTime=t*44100.0;
[self calcRates];
}
// ************************************************************************************************
-(void)		setDecay:(float)l time:(float)t
{
decayLevel=l;   
decayTime=t*44100.0;
[self calcRates];
}
// ************************************************************************************************
-(void)		setRelease:(float)l time:(float)t
{
releaseLevel=0;				// always to zero for release
releaseTime=t*44100.0;
[self calcRates];
}
// ************************************************************************************************
-(void)		calcRates
{
attackDelta=attackLevel/attackTime;
decayDelta=(decayLevel-attackLevel)/decayTime;
releaseDelta=(releaseLevel-decayLevel)/releaseTime;
}
// ************************************************************************************************
-(float)   tick
{
switch(state)
	{
	case 0: return 0; break;		// DONE or NOT STARTED
	
	case 1:
		value+=attackDelta;
		if(value>=attackLevel)  state=2;
		break;
		
	case 2:
		value+=decayDelta;
		if(value<=decayLevel) state=3;
		break;
		
	case 3:
		if(noteDuration!=0) if((sustainTime--)<0)	[self keyOff];
		return decayLevel*gain;
		break;
		
	case 4:
		value+=releaseDelta;
		if(value<=0) state=0;
		break;
	}
	
return value*gain;
}
// ************************************************************************************************

@end
