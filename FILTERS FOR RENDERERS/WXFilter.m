// ************************************************************************************************
//  WXFilter.h
//  Created by Paul Webb on Wed Dec 29 2004.
// ************************************************************************************************

#import "WXFilter.h"


@implementation WXFilter


// ************************************************************************************************
// The default constructor should setup for pass-through.
// ************************************************************************************************
-(id)		init
{
if(self=[super init])
	{
	gain = 1.0;
	nB = 1;
	nA = 1;
	b = malloc(nB*sizeof(float));
	b[0] = 1.0;
	a = malloc(nA*sizeof(float));
	a[0] = 1.0;

	inputs = malloc(nB*sizeof(float));
	outputs = malloc(nA*sizeof(float));
	[self clear];	
	}
return self;
}
// ************************************************************************************************
-(id)		initFilter:(int)nb bc:(float*)bCoefficients na:(int)na ac:(float*)aCoefficients
{
if(self=[super init])
	{
	gain = 1.0;
	nB = nb;
	nA = na;
	b = malloc(nB*sizeof(float));
	a = malloc(nA*sizeof(float));
	inputs = malloc(nB*sizeof(float));
	outputs = malloc(nA*sizeof(float));
	[self clear];	
	[self setCoefficients:nB bc:bCoefficients na:nA ac:aCoefficients];
	}
return self;
}
// ******************************************************************************************
-(void)		dealloc
{
free(b);
free(a);
free(inputs);
free(outputs);
[super dealloc];
}
// ************************************************************************************************
-(void)		clear
{
int i;
for(i=0;i<nB;i++) inputs[i]=0.0;
for(i=0;i<nA;i++) outputs[i]=0.0;
}
// ************************************************************************************************
-(void)		setCoefficients:(int)nb bc:(float*)bCoefficients na:(int)na ac:(float*)aCoefficients
{
int i;

if (nb != nB) 
	{
	free(b);
	free(inputs);
	nB = nb;
	b = malloc(nB*sizeof(float));
	inputs = malloc(nB*sizeof(float));
	for (i=0; i<nB; i++) inputs[i] = 0.0;
	}

if (na != nA) 
	{
	free(a);
	free(outputs);
	nA = na;
	a = malloc(nA*sizeof(float));
	outputs = malloc(nA*sizeof(float));
	for (i=0; i<nA; i++) outputs[i] = 0.0;
	}

for (i=0; i<nB; i++)
    b[i] = bCoefficients[i];

for (i=0; i<nA; i++)
    a[i] = aCoefficients[i];

// scale coefficients by a[0] if necessary
if (a[0] != 1.0) 
	{
    for (i=0; i<nB; i++)
      b[i] /= a[0];
    for (i=0; i<nA; i++)
      a[i] /= a[0];
	}
}
// ************************************************************************************************
-(void)		setNumerator:(int)nb  bc:(float*)bCoefficients
{
int i;

if (nb != nB) 
	{
    free(b);
	free(inputs);
    nB = nb;
	b = malloc(nB*sizeof(float));
	inputs = malloc(nB*sizeof(float));
    for (i=0; i<nB; i++) inputs[i] = 0.0;
  }

for (i=0; i<nB; i++)
	b[i] = bCoefficients[i];
}
// ************************************************************************************************
-(void)		setDenominator:(int)na  ac:(float*)aCoefficients
{
int i;

if (na != nA) 
	{
	free(a);
	free(outputs);
    nA = na;
	a = malloc(nA*sizeof(float));
	outputs = malloc(nA*sizeof(float));
    for (i=0; i<nA; i++) outputs[i] = 0.0;
  }

for (i=0; i<nA; i++)
	a[i] = aCoefficients[i];

// scale coefficients by a[0] if necessary
if (a[0] != 1.0) 
	{
    for (i=0; i<nB; i++)
      b[i] /= a[0];
    for (i=0; i<nA; i++)
      a[i] /= a[0];
  }
}	
// ************************************************************************************************
-(void)		setGain:(float)theGain
{
gain=theGain;
}
// ************************************************************************************************
-(float)	getGain
{
return gain;
}
// ************************************************************************************************
-(float)	lastOut
{
return outputs[0];
}
// ************************************************************************************************
-(void)		filterChunk:(float*)ioData frame:(UInt32)inNumFrames
{
UInt32 i;
float inputSample;

for (i=0; i<inNumFrames; ++i) 
	{
	inputSample=*ioData;
	outputs[0] = 0.0;
	inputs[0] = gain * inputSample;

	for (i=nB-1; i>0; i--) 
		{
		outputs[0] += b[i] * inputs[i];
		inputs[i] = inputs[i-1];
		}
	outputs[0] += b[0] * inputs[0];

	for (i=nA-1; i>0; i--) 
		{
		outputs[0] += -a[i] * outputs[i];
		outputs[i] = outputs[i-1];
		}


	*ioData++=outputs[0];
	}
}
// ************************************************************************************************
-(float)	filter:(float)sample
{
int i;

outputs[0] = 0.0;
inputs[0] = gain * sample;

for (i=nB-1; i>0; i--) 
	{
    outputs[0] += b[i] * inputs[i];
    inputs[i] = inputs[i-1];
	}
outputs[0] += b[0] * inputs[0];

for (i=nA-1; i>0; i--) 
	{
    outputs[0] += -a[i] * outputs[i];
    outputs[i] = outputs[i-1];
	}

return outputs[0];
}
// ************************************************************************************************



@end
