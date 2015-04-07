// ************************************************************************************************
//  WXFilterJohnChowningReverb
//  Created by Paul Webb on Wed Dec 29 2004.
// ************************************************************************************************
#import "WXFilterJohnChowningReverb.h"


@implementation WXFilterJohnChowningReverb
// ************************************************************************************************
-(id)		initFilter:(float)T60
{
if(self=[super init])
	{
	int lengths[9] = {1777, 1847, 1993, 2137, 389, 127, 43, 211, 179};
	double scaler = 44100.0 / 44100.0;

	int delay, i;
	if ( scaler != 1.0 ) {
		for (i=0; i<9; i++) {
			delay = (int) floor(scaler * lengths[i]);
			if ( (delay & 1) == 0) delay++;
			while(![self isPrime:delay]) delay+=2;
			lengths[i] = delay;
		}
	}

	for (i=0; i<3; i++)
		allpassDelays[i]=[[WXFilterDelay alloc]initDelay:lengths[i+4] md:lengths[i+4]];

	for (i=0; i<4; i++)	{
		combDelays[i] =[[WXFilterDelay alloc]initDelay:lengths[i] md:lengths[i]];
		combCoefficient[i] = pow(10.0,(-3 * lengths[i] / (T60 * 44100.0)));
	}

	outLeftDelay =[[WXFilterDelay alloc]initDelay:lengths[7] md:lengths[7]];
	outRightDelay =[[WXFilterDelay alloc]initDelay:lengths[8] md:lengths[8]];
	allpassCoefficient = 0.7;
	effectMix = 0.3;
	[self clear];
	}
return self;
}
// ******************************************************************************************
-(void)		dealloc
{
[allpassDelays[0] release];
[allpassDelays[1] release];
[allpassDelays[2] release];
[combDelays[0] release];
[combDelays[1] release];
[combDelays[2] release];
[combDelays[3] release];
[super dealloc];
}
// ************************************************************************************************
-(void)		clear
{
[allpassDelays[0] clear];
[allpassDelays[1] clear];
[allpassDelays[2] clear];
[combDelays[0] clear];
[combDelays[1] clear];
[combDelays[2] clear];
[combDelays[3] clear];
[outRightDelay clear];
[outLeftDelay clear];
lastOutput[0] = 0.0;
lastOutput[1] = 0.0;
}
// ************************************************************************************************
-(void)		filterChunk:(float*)ioData frame:(UInt32)inNumFrames
{
UInt32 i;
float inputSample;
float temp, temp0, temp1, temp2, temp3, temp4, temp5, temp6;
float filtout;

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

	temp = [allpassDelays[2] lastOut];
	temp2 = allpassCoefficient * temp;
	temp2 += temp1;
	[allpassDelays[2] filter:temp2];
	temp2 = -(allpassCoefficient * temp2) + temp;

	temp3 = temp2 + (combCoefficient[0] * [combDelays[0] lastOut]);
	temp4 = temp2 + (combCoefficient[1] * [combDelays[1] lastOut]);
	temp5 = temp2 + (combCoefficient[2] * [combDelays[2] lastOut]);
	temp6 = temp2 + (combCoefficient[3] * [combDelays[3] lastOut]);

	[combDelays[0] filter:temp3];
	[combDelays[1] filter:temp4];
	[combDelays[2] filter:temp5];
	[combDelays[3] filter:temp6];

	filtout = temp3 + temp4 + temp5 + temp6;

	lastOutput[0] = effectMix * ([outLeftDelay filter:filtout]);
	lastOutput[1] = effectMix * ([outRightDelay filter:filtout]);
	temp = (1.0 - effectMix) * inputSample;
	lastOutput[0] += temp;
	lastOutput[1] += temp;

	*ioData++=(lastOutput[0] + lastOutput[1]) * 0.5;
	}
}
// ************************************************************************************************
-(float)	filter:(float)input
{
float temp, temp0, temp1, temp2, temp3, temp4, temp5, temp6;
float filtout;

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

temp = [allpassDelays[2] lastOut];
temp2 = allpassCoefficient * temp;
temp2 += temp1;
[allpassDelays[2] filter:temp2];
temp2 = -(allpassCoefficient * temp2) + temp;

temp3 = temp2 + (combCoefficient[0] * [combDelays[0] lastOut]);
temp4 = temp2 + (combCoefficient[1] * [combDelays[1] lastOut]);
temp5 = temp2 + (combCoefficient[2] * [combDelays[2] lastOut]);
temp6 = temp2 + (combCoefficient[3] * [combDelays[3] lastOut]);

[combDelays[0] filter:temp3];
[combDelays[1] filter:temp4];
[combDelays[2] filter:temp5];
[combDelays[3] filter:temp6];

filtout = temp3 + temp4 + temp5 + temp6;

lastOutput[0] = effectMix * ([outLeftDelay filter:filtout]);
lastOutput[1] = effectMix * ([outRightDelay filter:filtout]);
temp = (1.0 - effectMix) * input;
lastOutput[0] += temp;
lastOutput[1] += temp;

return (lastOutput[0] + lastOutput[1]) * 0.5;
}
// ************************************************************************************************


@end
