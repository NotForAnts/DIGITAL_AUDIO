// ******************************************************************************************
//  WXDSEnvelopeTableMaker
//  Created by Paul Webb on Mon Nov 29 2004.
// ******************************************************************************************
#import "WXDSEnvelopeTableMaker.h"

@implementation WXDSEnvelopeTableMaker

// ******************************************************************************************
-(id)		init
{
if(self=[super init])
	{
	}
return self;
}
// ******************************************************************************************
-(void)		dealloc
{
[super dealloc];
}
// ******************************************************************************************
// set np=1 and partials=nil for basic ramp
// ******************************************************************************************
-(float*)   makeRampTable:(int)size freq:(NSString*)freq amp:(NSString*)amp r1:(float)r1 r2:(float)r2
{
int		t,p,m;
float   *dest=malloc(size*sizeof(float)),sum=0,ampSum=0;

NSArray* parts=[freq componentsSeparatedByString:@" "];
NSArray* amps=[amp componentsSeparatedByString:@" "];
NSMutableArray* rampMod=[[NSMutableArray alloc]initWithCapacity:1];

if([amps count]!=[parts count]) return dest;
for(t=0;t<[amps count];t++)		ampSum+=[[amps objectAtIndex:t]floatValue];
for(t=0;t<[parts count];t++)	[rampMod addObject:[NSNumber numberWithInt:size/[[parts objectAtIndex:t]intValue]]];

for(p=0;p<size;p++,sum=0)
	{
	for(t=0;t<[parts count];t++)
		{
		m=[[rampMod objectAtIndex:t]intValue];
		sum+=(WXUNormalise(p%m,0,m,r1,r2)*[[amps objectAtIndex:t]floatValue]);
		}
	dest[p]=sum/ampSum;
	}

//[parts release];
//[amps release];
//[rampMod release];
return dest;
}

// ******************************************************************************************
-(float*)   makeSincPulseWaveTable:(int)size r1:(float)r1 r2:(float)r2 freq:(float)freq phases:(float)phases
{
int		t,pulseSize=size/freq;
float   *dest=malloc(size*sizeof(float));
float   *thePulse=[self makeSincEnvelope:pulseSize r1:r1 r2:r2 phases:phases];
for(t=0;t<size;t++)
	dest[t]=thePulse[t%pulseSize];
	
free(thePulse);
return dest;
}
// ******************************************************************************************
-(float*)   makeNoisePulseWave:(int)size r1:(float)r1 r2:(float)r2 freq:(float)freq pulsePercent:(int)pulsePercent
{
int		t,pulseSize=size/freq,pulseLength;
float   *dest=malloc(size*sizeof(float));

pulseLength=pulseSize*pulsePercent/100;
for(t=0;t<size;t++)
	{
	if((t%pulseSize)<pulseLength)
		dest[t]=WXUFloatRandomBetween(r1,r2); else dest[t]=r1;
	}
return dest;
}
// ******************************************************************************************
-(float*)   makePulseTable:(int)size r1:(float)r1 r2:(float)r2 freq:(float)freq pulsePercent:(int)pulsePercent
{
int		t,pulseSize=size/freq,pulseLength;
float   *dest=malloc(size*sizeof(float));

pulseLength=pulseSize*pulsePercent/100;
for(t=0;t<size;t++)
	{
	if((t%pulseSize)<pulseLength)
		dest[t]=r2; else dest[t]=r1;
	}
return dest;
}
// ******************************************************************************************
-(float*)   makeDecaySineWaveTable:(int)size r1:(float)r1 r2:(float)r2 freq:(float)freq
{
int		t;
float   *dest=malloc(size*sizeof(float)),degree=0.0, delta=2.0 *freq* 3.14159265359*1.0/(float)size;
for(t=0;t<size;t++,degree+=delta)
	dest[t]=sin(degree)*WXUNormalise(t,0,size-1,1.0,0.0); 
return dest;
}
// ******************************************************************************************
-(float*)   makeSineWaveTable:(int)size r1:(float)r1 r2:(float)r2 freq:(float)freq
{
int		t;
float   *dest=malloc(size*sizeof(float)),degree=0.0, delta=2.0 *freq* 3.14159265359*1.0/(float)size;
for(t=0;t<size;t++,degree+=delta)
	dest[t]=sin(degree); 
return dest;
}
// ******************************************************************************************
-(float*)   makePartialSineTable:(int)size freq:(NSString*)freq amp:(NSString*)amp r1:(float)r1 r2:(float)r2;
{
int		t,p;
float   *degree,*delta,*gain;
float   *dest=malloc(size*sizeof(float)),sum=0,ampSum=0;

NSArray* parts=[freq componentsSeparatedByString:@" "];
NSArray* amps=[amp componentsSeparatedByString:@" "];

degree=malloc([parts count]*sizeof(float));
delta=malloc([parts count]*sizeof(float));
gain=malloc([parts count]*sizeof(float));

for(t=0;t<[parts count];t++)
	{
	degree[t]=0;
	delta[t]=2.0 * [[parts objectAtIndex:t]floatValue] * 3.14159265359*1.0/(float)size;
	gain[t]=[[amps objectAtIndex:t]floatValue];
	ampSum+=gain[t];
	}
	
for(p=0;p<size;p++,sum=0)
	{
	for(t=0;t<[parts count];t++)
		{
		sum+=sin(degree[t])*gain[t];
		degree[t]+=delta[t];
		}
	
	dest[p]=sum/ampSum;
	}
		
//[parts release];
//[amps release];	
free(gain);
free(degree);
free(delta);
return dest;
}
// ******************************************************************************************
//			ENVELOPES
// ******************************************************************************************
-(float*)   makeSmoothSineEnvelope:(int)size r1:(float)r1 r2:(float)r2
{
int		t;
float   *dest=malloc(size*sizeof(float)),a;

for(t=0;t<size;t++)
	{
	a=(6.283185*WXUNormalise(t,0,size-1,270,630))/360.0;
	dest[t]=WXUNormalise(sin(a),-1.0,1.0,r1,r2);
	}
return dest;
}
// ******************************************************************************************
-(float*)	makeTriangleEnvelope:(int)size r1:(float)r1 r2:(float)r2
{
int		t,mid=size/2;
float   *dest=malloc(size*sizeof(float));

for(t=0;t<size;t++)
	{
	if(t<mid)   dest[t]=WXUNormalise(t,0,mid,r1,r2);
	if(t>=mid)  dest[t]=WXUNormalise(t,mid,size-1,r2,r1);
	}
return dest;
}
// ******************************************************************************************
-(float*)   makeThreeStageTriangleEnvelope:(int)size r1:(float)r1 r2:(float)r2 flat:(int)flat
{
int		t,part1,part2;
float   *dest=malloc(size*sizeof(float));

part1=(size-flat)/2;
part2=size-part1;

for(t=0;t<size;t++)
	{
	if(t<=part1)	dest[t]=WXUNormalise(t,0,part1,r1,r2); else
	if(t>=part2)	dest[t]=WXUNormalise(t,part2,size-1,r2,r1); else
	dest[t]=r2;
	}
return dest;
}
// ******************************************************************************************
-(float*)	makeGaussianEnvelope:(int)size r1:(float)r1 r2:(float)r2
{
return [self makeShiftedGaussianEnvelope:size p1:size/2 p2:size/2 r1:r1 r2:r2];
}
// ******************************************************************************************
-(float*)	makeQuasiGaussianEnvelope:(int)size flat:(int)flat r1:(float)r1 r2:(float)r2
{
return [self makeShiftedGaussianEnvelope:size p1:size/2-(flat/2) p2:size/2+(flat/2) r1:r1 r2:r2];
}
// ******************************************************************************************
-(float*)	makeShiftedGaussianEnvelope:(int)size p1:(int)p1 p2:(int)p2 r1:(float)r1 r2:(float)r2
{
int p;
float   *dest=malloc(size*sizeof(float)),a,b,d,x,m=0;


d=1;	d=d*d;
a=1.0/(sqrt(pow(2,3.14159*d)));

// first calculate the max of M which is then used in the mapping to the ranges
for(p=0;p<size;p++)
	{
	x=0;
	if(p<=p1) x=WXUNormalise(p,0,p1,-250,0)*d;	
	if(p>=p2) x=WXUNormalise(p,p2,size,0,250)*d;	
	x=x/100;	
	b=pow(2.718282,-(x*x))/2;	b=a*b;
	if(b>m) m=b;
	}
	
// now make the envelope
for(p=0;p<size;p++)
	{
	if(p<=p1) x=WXUNormalise(p,0,p1,-250,0)*d;	
	if(p>=p2) x=WXUNormalise(p,p2,size,0,250)*d;	
	x=x/100;
	b=pow(2.718282,-(x*x))/2;	b=a*b;	
	dest[p]=WXUNormalise(b,0,m,r1,r2);
	}
return dest;
}
// ******************************************************************************************
// RAMP ENVELOPE /
// ******************************************************************************************
-(float*)	makeStraightEnvelope:(int)size r1:(float)r1 r2:(float)r2
{
int p;
float   *dest=malloc(size*sizeof(float));
for(p=0;p<size;p++)
	dest[p]=WXUNormalise(p,0,size-1,r1,r2);
	
return dest;
}
// ******************************************************************************************
-(float*)	makeRexpodecEnvelope:(int)size r1:(float)r1 r2:(float)r2  e1:(float)e1 e2:(float)e2
{
float   *dest=malloc(size*sizeof(float)),exp1=exp(e1),exp2=exp(e2),expvalue;
int p;

for(p=0;p<size;p++)
	{
	expvalue=WXUNormalise(p,size-1,0,e1,e2);
	expvalue=exp(expvalue);
	dest[size-p-1]=WXUNormalise(expvalue,exp1,exp2,r1,r2);	
	}
return dest;
}
// ******************************************************************************************
-(float*)	makeExpodecEnvelope:(int)size r1:(float)r1 r2:(float)r2
{
return [self makeExpodecEnvelope:size r1:r1 r2:r2 e1:0.0 e2:5.0];
}
// ******************************************************************************************
-(float*)	makeExpodecEnvelope:(int)size r1:(float)r1 r2:(float)r2 e1:(float)e1 e2:(float)e2
{
float   *dest=malloc(size*sizeof(float)),exp1=exp(e1),exp2=exp(e2),expvalue;
int p;

for(p=0;p<size;p++)
	{
	expvalue=WXUNormalise(p,size-1,0,e1,e2);
	expvalue=exp(expvalue);
	dest[p]=WXUNormalise(expvalue,exp1,exp2,r1,r2);	
	}
return dest;
}
// ******************************************************************************************
-(float*)	makeShiftedHalfSineEnvelope:(int)size p1:(int)p1 p2:(int)p2 r1:(float)r1 r2:(float)r2
{
float 	angle,a1,a2,a3,*dest=malloc(size*sizeof(float));
int		p;


a1=(6.1415926535898*270)/360; 
a2=(6.1415926535898*450)/360; 
a3=(6.1415926535898*630)/360;

for(p=0;p<size;p++)
	{
	angle=a2;
	if(p<=p1) angle=WXUNormalise(p,0,p1,a1,a2);
	if(p>=p2) angle=WXUNormalise(p,p2,size,a2,a3);
	dest[p]=WXUNormalise(sin(angle),-1.0,1.0,r1,r2);
	}
return dest;
}
// ******************************************************************************************
// normal is 5 phases
// ******************************************************************************************
-(float*)	makeSincEnvelope:(int)size r1:(float)r1 r2:(float)r2 phases:(float)phases
{
float 	*dest=malloc(size*sizeof(float));
float   degree=-phases*3.14159265359, delta=2.0*phases*3.14159265359/(float)size,v;
int		p;

for(p=0;p<size;p++)
	{
	if(degree==0) degree+=delta;
	v=sin(degree)/degree;
	dest[p]=v;
	degree+=delta;
	}

return dest;
}
// ******************************************************************************************
-(float*)   makeADSREnvelope:(int)size v1:(float)v1 t1:(int)t1 v2:(float)v2 t2:(int)t2 v3:(float)v3 t3:(int)t3
{
int p;
float 	*dest=malloc(size*sizeof(float)),value;

for(p=0;p<size;p++)
	{
	if(p<=t1) 			value=WXUNormalise(p,0,t1,0,v1);
	if(p>t1 && p<=t2) 	value=WXUNormalise(p,t1,t2,v1,v2);
	if(p>t2 && p<=t3) 	value=WXUNormalise(p,t2,t3,v2,v3);
	if(p>t3)			value=WXUNormalise(p,t3,size,v3,0);
	dest[p]=value;
	}
return dest;
}
// ******************************************************************************************


@end
