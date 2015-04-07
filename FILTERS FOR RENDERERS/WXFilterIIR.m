// ******************************************************************************************
//  WXFilterIIR.h
//  Created by Paul Webb on Thu Dec 30 2004.
// ******************************************************************************************
#import "WXFilterIIR.h"


@implementation WXFilterIIR
// ******************************************************************************************
-(id)		initFilter:(UInt32)d s1:(float)fs1 s2:(float)fs2
{
if(self=[super init])
	{
	msize=20000;
	theDelay=WXUBetween(0,msize,d);
	count=0;
	s1=fs1;
	s2=fs2;
	gain=1.0;
	tap=malloc(msize*sizeof(float));
	}
return self;
}
// ******************************************************************************************
-(void)		dealloc
{
free(tap);
[super dealloc];
}
// ******************************************************************************************
-(void)		setDelayNSO:(id)delay			{   [self setDelay:[delay floatValue]];		}
-(void)		setStrengthOneNSO:(id)v			{   [self setStrengthOne:[v floatValue]];	}
-(void)		setStrengthTwoNSO:(id)v			{   [self setStrengthTwo:[v floatValue]];	}
-(void)		setGainNSO:(id)g				{   [self setGain:[g floatValue]];			}
// ******************************************************************************************
-(void)		setDelay:(long)delay;
{
if(delay<msize) theDelay=(UInt32)delay;		
}
// ******************************************************************************************
-(void)		setFStrengths:(float)v1 s2:(float)v2;
{
s1=v1;
s2=v2;
}
// ******************************************************************************************
-(void)		setStrengthOne:(float)v
{
s1=v;
}
// ******************************************************************************************
-(void)		setStrengthTwo:(float)v
{
s2=v;
}
// ******************************************************************************************
-(void)		setGain:(float)g
{
gain=g;
}
// ***************************************************************************************
-(void)		clear
{
int i;
for(i=0;i<msize;i++) tap[i]=0.0;
count=0;
}
// ************************************************************************************************
-(void)		filterChunk:(float*)ioData frame:(UInt32)inNumFrames
{
UInt32 i;
float inputSample;

for (i=0; i<inNumFrames; ++i) 
	{
	inputSample=*ioData;
	if(count>theDelay)inputSample=inputSample*s1-s2*tap[(count-theDelay)%msize]; 
	tap[count%msize]=inputSample;
	count++;
	*ioData++=inputSample*gain;
	}
}
// ******************************************************************************************
-(float)   filter:(float)sample
{
if(count>theDelay)sample=sample*s1-s2*tap[(count-theDelay)%msize]; 
tap[count%msize]=sample;
count++;
return sample*gain;
}
// ******************************************************************************************
@end
