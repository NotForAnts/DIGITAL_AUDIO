// ************************************************************************************************
//  WXFilterNReverb
//  Created by Paul Webb on Thu Dec 30 2004.
// ************************************************************************************************
#import "WXFilterNReverb.h"


@implementation WXFilterNReverb

// ************************************************************************************************
-(id)		initFilter:(float)T60
{
if(self=[super init])
	{
	int lengths[15] = {1433, 1601, 1867, 2053, 2251, 2399, 347, 113, 37, 59, 53, 43, 37, 29, 19};
	double scaler = 44100.0/ 25641.0;

	int delay, i;
	for (i=0; i<15; i++) {
		delay = (int) floor(scaler * lengths[i]);
		if ( (delay & 1) == 0) delay++;
		while (![self isPrime:delay]) delay += 2;
		lengths[i] = delay;
	}

	for (i=0; i<6; i++) {
		combDelays[i] =[[WXFilterDelay alloc]initDelay:lengths[i] md:lengths[i]];
		combCoefficient[i] = pow(10.0, (-3 * lengths[i] / (T60 * 44100.0)));
	}

	for (i=0; i<8; i++)
		allpassDelays[i] =[[WXFilterDelay alloc]initDelay:lengths[i+6] md:lengths[i+6]];

	allpassCoefficient = 0.7;
	effectMix = 0.3;
	[self clear];
	}
return self;
}
// ******************************************************************************************
-(void)		dealloc
{
int i;
for (i=0; i<6; i++) [combDelays[i] release];
for (i=0; i<8; i++) [allpassDelays[i] release];
[super dealloc];
}
// ***************************************************************************************
-(void)		doController:(int)index value:(float)value
{
switch(index)
	{
	case 1: break;
	}
}
// ************************************************************************************************
-(void)		clear
{
int i;
for (i=0; i<6; i++) [combDelays[i] clear];
for (i=0; i<8; i++) [allpassDelays[i] clear];
lastOutput[0] = 0.0;
lastOutput[1] = 0.0;
lowpassState = 0.0;
}
// ************************************************************************************************
-(void)		filterChunk:(float*)ioData frame:(UInt32)inNumFrames
{
UInt32 k;
float temp, temp0, temp1, temp2, temp3;
int i;
float inputSample;

for (k=0; k<inNumFrames; ++k) 
	{
	inputSample=*ioData;
	temp0 = 0.0;
	for (i=0; i<6; i++) {
		temp = inputSample + (combCoefficient[i] * [combDelays[i] lastOut]);
		temp0 += [combDelays[i] filter:temp];
	}
	for (i=0; i<3; i++)	{
		temp = [allpassDelays[i] lastOut];
		temp1 = allpassCoefficient * temp;
		temp1 += temp0;
		[allpassDelays[i] filter:temp1];
		temp0 = -(allpassCoefficient * temp1) + temp;
	}

	// One-pole lowpass filter.
	lowpassState = 0.7*lowpassState + 0.3*temp0;
	temp = [allpassDelays[3] lastOut];
	temp1 = allpassCoefficient * temp;
	temp1 += lowpassState;
	[allpassDelays[3] filter:temp1];
	temp1 = -(allpassCoefficient * temp1) + temp;

	temp = [allpassDelays[4] lastOut];
	temp2 = allpassCoefficient * temp;
	temp2 += temp1;
	[allpassDelays[4] filter:temp2];
	lastOutput[0] = effectMix*(-(allpassCoefficient * temp2) + temp);

	temp = [allpassDelays[5] lastOut];
	temp3 = allpassCoefficient * temp;
	temp3 += temp1;
	[allpassDelays[5] filter:temp3];
	lastOutput[1] = effectMix*(-(allpassCoefficient * temp3) + temp);

	temp = (1.0 - effectMix) * inputSample;
	lastOutput[0] += temp;
	lastOutput[1] += temp;

	*ioData++=(lastOutput[0] + lastOutput[1]) * 0.5;
	}
}
// ************************************************************************************************
-(float)	filter:(float)input
{
float temp, temp0, temp1, temp2, temp3;
int i;

temp0 = 0.0;
for (i=0; i<6; i++) {
	temp = input + (combCoefficient[i] * [combDelays[i] lastOut]);
	temp0 += [combDelays[i] filter:temp];
}
for (i=0; i<3; i++)	{
	temp = [allpassDelays[i] lastOut];
	temp1 = allpassCoefficient * temp;
	temp1 += temp0;
	[allpassDelays[i] filter:temp1];
	temp0 = -(allpassCoefficient * temp1) + temp;
}

// One-pole lowpass filter.
lowpassState = 0.7*lowpassState + 0.3*temp0;
temp = [allpassDelays[3] lastOut];
temp1 = allpassCoefficient * temp;
temp1 += lowpassState;
[allpassDelays[3] filter:temp1];
temp1 = -(allpassCoefficient * temp1) + temp;

temp = [allpassDelays[4] lastOut];
temp2 = allpassCoefficient * temp;
temp2 += temp1;
[allpassDelays[4] filter:temp2];
lastOutput[0] = effectMix*(-(allpassCoefficient * temp2) + temp);

temp = [allpassDelays[5] lastOut];
temp3 = allpassCoefficient * temp;
temp3 += temp1;
[allpassDelays[5] filter:temp3];
lastOutput[1] = effectMix*(-(allpassCoefficient * temp3) + temp);

temp = (1.0 - effectMix) * input;
lastOutput[0] += temp;
lastOutput[1] += temp;

return (lastOutput[0] + lastOutput[1]) * 0.5;
}
// ************************************************************************************************

@end
