// ************************************************************************************************
//  WXFilterPRCReverb
//  Created by Paul Webb on Thu Dec 30 2004.
// ************************************************************************************************
#import "WXFilterPRCReverb.h"


@implementation WXFilterPRCReverb
// ************************************************************************************************
-(id)		initFilter:(float)T60
{
if(self=[super init])
	{
	// Delay lengths for 44100 Hz sample rate.
	int lengths[4]= {353, 1097, 1777, 2137};
	double scaler = 44100.0 / 44100.0;

	// Scale the delay lengths if necessary.
	int delay, i;
	if ( scaler != 1.0 ) {
		for (i=0; i<4; i++)	{
			delay = (int) floor(scaler * lengths[i]);
			if ( (delay & 1) == 0) delay++;
			while (![self isPrime:delay]) delay += 2;
			lengths[i] = delay;
		}
	}

	for (i=0; i<2; i++)	{
		allpassDelays[i] =[[WXFilterDelay alloc]initDelay:lengths[i] md:lengths[i]];
		combDelays[i] = [[WXFilterDelay alloc]initDelay:lengths[i+2] md:lengths[i+2]];
		combCoefficient[i] = pow(10.0,(-3 * lengths[i+2] / (T60 * 44100.0)));
	}

	allpassCoefficient = 0.7;
	effectMix = 0.5;
	[self clear];
	}
return self;
}
// ******************************************************************************************
-(void)		dealloc
{
[allpassDelays[0] release];
[allpassDelays[1] release];
[combDelays[0] release];
[combDelays[1] release];
[super dealloc];
}
// ************************************************************************************************
-(void)		clear
{
[allpassDelays[0] clear];
[allpassDelays[1] clear];
[combDelays[0] clear];
[combDelays[1] clear];
lastOutput[0] = 0.0;
lastOutput[1] = 0.0;
}
// ************************************************************************************************
-(void)		filterChunk:(float*)ioData frame:(UInt32)inNumFrames
{
UInt32 i;
float inputSample;
float temp, temp0, temp1, temp2, temp3;

for (i=0; i<inNumFrames; ++i) 
	{
	inputSample=*ioData;
	temp = [allpassDelays[0] lastOut];
	temp0 = allpassCoefficient * temp;
	temp0 += inputSample;
	[allpassDelays[0] filter:temp0];
	temp0 = -(allpassCoefficient * temp0) + temp;

	temp = [allpassDelays[1] lastOut];
	temp1 = allpassCoefficient * temp;
	temp1 += temp0;
	[allpassDelays[1] filter:temp1];
	temp1 = -(allpassCoefficient * temp1) + temp;

	temp2 = temp1 + (combCoefficient[0] * [combDelays[0] lastOut]);
	temp3 = temp1 + (combCoefficient[1] * [combDelays[1] lastOut]);

	lastOutput[0] = effectMix * ([combDelays[0] filter:temp2]);
	lastOutput[1] = effectMix * ([combDelays[1] filter:temp3]);
	temp = (float) (1.0 - effectMix) * inputSample;
	lastOutput[0] += temp;
	lastOutput[1] += temp;

	*ioData++=(lastOutput[0] + lastOutput[1]) * (float) 0.5;
	}
}
// ************************************************************************************************
-(float)	filter:(float)input
{
float temp, temp0, temp1, temp2, temp3;

temp = [allpassDelays[0] lastOut];
temp0 = allpassCoefficient * temp;
temp0 += input;
[allpassDelays[0] filter:temp0];
temp0 = -(allpassCoefficient * temp0) + temp;

temp = [allpassDelays[1] lastOut];
temp1 = allpassCoefficient * temp;
temp1 += temp0;
[allpassDelays[1] filter:temp1];
temp1 = -(allpassCoefficient * temp1) + temp;

temp2 = temp1 + (combCoefficient[0] * [combDelays[0] lastOut]);
temp3 = temp1 + (combCoefficient[1] * [combDelays[1] lastOut]);

lastOutput[0] = effectMix * ([combDelays[0] filter:temp2]);
lastOutput[1] = effectMix * ([combDelays[1] filter:temp3]);
temp = (float) (1.0 - effectMix) * input;
lastOutput[0] += temp;
lastOutput[1] += temp;

return (lastOutput[0] + lastOutput[1]) * (float) 0.5;
}
// ************************************************************************************************

@end
