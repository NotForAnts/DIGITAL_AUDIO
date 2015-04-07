// ******************************************************************************************
//  WXReverbMoorer
//
//  Created by Paul Webb on Thu Dec 30 2004.
// ******************************************************************************************
#import "WXReverbMoorer.h"


@implementation WXReverbMoorer
// ******************************************************************************************
-(id)		init
{
if(self=[super init])
	{
	d1=d2=d3=d4=d5=d6=0;

	xn1=0;
	ofdelay1 =fdelay1 =1039;
	ofdelay2 =fdelay2 =2011;
	ofdelay3 =fdelay3 =3121;
	ofdelay4 =fdelay4 =5741;
	ofdelay5 =fdelay5 =7039;
	ofdelay6 =fdelay6 =12232;

	fFeedBack=0.91599;
	msize=88000;

	tap1=malloc(msize*sizeof(float));
	tap2=malloc(msize*sizeof(float));
	tap3=malloc(msize*sizeof(float));
	tap4=malloc(msize*sizeof(float));
	tap5=malloc(msize*sizeof(float));
	tap6=malloc(msize*sizeof(float));

	buffer7=malloc(msize*sizeof(float));

	bufferx=malloc(msize*sizeof(float));
	buffery=malloc(msize*sizeof(float));

	ofgain1=fgain1 = 0.76307805477; // -26.4 was -26.6dB
	ofgain2=fgain2 = 0.6050487881f; // -17.8 was -22.4dB
	ofgain3=fgain3 = 0.25;

	ofgain1=fgain1 = 0.426118728129f; // -2dB
	ofgain2=fgain2 = 0.326118728129f; // -2dB
	ofgain3=fgain3 = 0.4f;

	LPFa0 = 0.4634255;
	LPFb1 = -0.0731489;

	SHFa0 = 0.5817138;
	SHFa1 = -0.2540805;
	SHFb1 = -0.3357944;
	SHFx1 = SHFy1 = 0.0f;

	lowPass1=[[WXLowPass2 alloc]initFilter:1 a0:0.4634255 b1:-0.0731489];
	lowPass2=[[WXLowPass2 alloc]initFilter:1 a0:0.4634255 b1:-0.0731489];
	lowPass3=[[WXLowPass2 alloc]initFilter:1 a0:0.4634255 b1:-0.0731489];
	lowPass4=[[WXLowPass2 alloc]initFilter:1 a0:0.4634255 b1:-0.0731489];
	lowPass5=[[WXLowPass2 alloc]initFilter:1 a0:0.4634255 b1:-0.0731489];
	lowPass6=[[WXLowPass2 alloc]initFilter:1 a0:0.4634255 b1:-0.0731489];
	}
return self;
}
// ******************************************************************************************
-(void)		dealloc
{
[lowPass1 release];
[lowPass2 release];
[lowPass3 release];
[lowPass4 release];
[lowPass5 release];
[lowPass6 release];
free(tap1);
free(tap2);
free(tap3);
free(tap4);
free(tap5);
free(tap6);
free(buffer7);
free(bufferx);
free(buffery);
[super dealloc];
}
// ******************************************************************************************
-(void)		setMainFeedBack:(float)fb
{
fFeedBack=fb;
}
// ******************************************************************************************
-(void)		setDelayOfSix:(int)which delay:(UInt32)delay
{
if(delay>msize) delay=msize;

switch(which)
	{
	case 1:			fdelay1=delay;  break;
	case 2:			fdelay2=delay;  break;
	case 3:			fdelay3=delay;  break;
	case 4:			fdelay4=delay;  break;
	case 5:			fdelay5=delay;  break;
	case 6:			fdelay6=delay;  break;
	}
}
// ******************************************************************************************
-(void)		setFilterGain:(int)which gain:(float)gain
{
switch(which)
	{
	case 1:			fgain1=gain;  break;
	case 2:			fgain2=gain;  break;
	case 3:			fgain3=gain;  break;
	}
}
// ******************************************************************************************
-(float)	filter:(float)input
{
// low pass filter
// y(n) = a0*x(n) + a0*x(n-1) - b1*y(n-1)
// so these filters are using a last value saved method

if(count>fdelay1)
	{
	d1 = (tap1[(count-fdelay1)%msize] * fFeedBack);
	d1=[lowPass1 filter:d1];
	}

if(count>fdelay2)
	{
	d2 = (tap2[(count-fdelay2)%msize] * fFeedBack);
	d2=[lowPass2 filter:d2];
	}

if(count>fdelay3)
	{
	d3 = (tap3[(count-fdelay3)%msize] * fFeedBack);
	d3=[lowPass3 filter:d3];
	}
	
if(count>fdelay4)
	{
	d4 = (tap4[(count-fdelay4)%msize] * fFeedBack);
	d4=[lowPass4 filter:d4];
	}
	
if(count>fdelay5)
	{
	d5 = (tap5[(count-fdelay5)%msize] * fFeedBack);
	d5=[lowPass5 filter:d5];
	}
	
if(count>fdelay6)
	{
	d6 = (tap6[(count-fdelay6)%msize] * fFeedBack);
	d6=[lowPass6 filter:d6];
	}							

if(count>5) xn1=buffery[(count-5)%msize]; else xn1=0;

//xn1=input;

tap1[count%msize] = d1+xn1;
tap2[count%msize] = d2+xn1;
tap3[count%msize] = d3+xn1;
tap4[count%msize] = d4+xn1;
tap5[count%msize] = d5+xn1;
tap6[count%msize] = d6+xn1;

xnAP=(d1+d2+d3+d4+d5+d6)/6.0;
buffery[count%msize] = input*0.7-xnAP*0.3;

if(count>9) dAP = (-0.85f * xnAP) + buffer7[(count-9)%msize]; else dAP=0;
buffer7[count%msize] = xnAP + (0.85 * dAP);

bufferx[count%msize] = input;

if(count>7) SHFin = (fgain3*bufferx[(count-7)%msize]) + (fgain1*input) +(fgain2*dAP);
SHFout = SHFa0*SHFin + SHFa1*SHFx1 - SHFb1*SHFy1;
SHFout *= 2.0f;
SHFx1 = SHFin;
SHFy1 = SHFout;

cinput=input;
input = SHFout/2.0f; //multiply by .5 to cancel the 6dB boost of the shelf
	
count++;
return input;
}
// ******************************************************************************************



@end
