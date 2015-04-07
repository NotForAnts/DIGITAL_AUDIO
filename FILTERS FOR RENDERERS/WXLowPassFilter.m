// ******************************************************************************************
//  WXLowPassFilter.h
//  Created by Paul Webb on Thu Dec 30 2004.
// ******************************************************************************************
#import "WXLowPassFilter.h"


@implementation WXLowPassFilter
// ******************************************************************************************
-(id)		initFilter:(UInt32)d s1:(float)fs1 s2:(float)fs2
{
if(self=[super init])
	{
	msize=44100;
	theDelay=d;
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
-(void)		clear
{
int i;
count=0;
for(i=0;i<msize;i++)
	tap[i]=0;
}
// ******************************************************************************************
-(void)		setDelay:(long)delay
{
if(delay<msize) theDelay=delay;		
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
// ******************************************************************************************
-(float)   filter:(float)sample
{
tap[count%msize]=sample;
if(count>theDelay)sample=sample*s1-s2*tap[(count-theDelay)%msize]; 
count++;
return sample*gain;
}
// ******************************************************************************************
-(float)   filterFB:(float)sample
{
if(count>theDelay)sample=sample*s1-s2*tap[(count-theDelay)%msize]; 
tap[count%msize]=sample;
count++;
return sample*gain;
}
// ******************************************************************************************
@end
