// ******************************************************************************************
//  WXFilterChorus
//  Created by Paul Webb on Wed Dec 29 2004.
// ******************************************************************************************
#import "WXFilterChorus.h"


@implementation WXFilterChorus
// ******************************************************************************************
-(id)		initChorus:(UInt32)ms
{
if(self=[super init])
	{
	msize=ms;
	count=0;
	tap=malloc(msize*sizeof(float));
	strength=0.99;

	delay=delay1=200;
	delay2=300;
	delayMid=delay2-delay1;
	delayRange=(delay2-delay1)/2;

	LFO=2.0;
	LFOphase=-1.0;
	LFOdelta=LFO * 2.0 * 3.14159265359 / 44100.0; 	
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
for(i=0;i<msize;i++) tap[i]=0.0;
count=0;
}
// ******************************************************************************************
-(void)		setChorus:(int)d1 d2:(int)d2 freq:(float)freq
{
LFO=freq;
LFOdelta=LFO * 2.0 * 3.14159265359 / 44100.0; 
delay1=d1;
delay2=d2;
delayMid=delay2-delay1;
delayRange=(delay2-delay1)/2;
}

// ***************************************************************************************
-(void)		doController:(int)index value:(float)value
{
switch(index)
	{
	case 1: [self setFreq:value];		break;
	case 2: [self setDelay1:value];		break;
	case 3: [self setDelay2:value];		break;
	}
}
// ******************************************************************************************
-(void)		setFreqNSO:(id)freq		{   [self setFreq:[freq floatValue]];   }
-(void)		setDelay1NSO:(id)d1		{   [self setDelay1:[d1 floatValue]];   }
-(void)		setDelay2NSO:(id)d2		{   [self setDelay2:[d2 floatValue]];   }
// ******************************************************************************************
-(void)		setFreq:(float)freq
{
LFO=freq;
LFOdelta=LFO * 2.0 * 3.14159265359 / 44100.0; 
}
// ******************************************************************************************
-(void)		setDelay1:(int)d1
{
if(delay1<0) delay1=0; if(delay1>=msize) delay1=msize-1;
delay1=d1;
delayMid=delay2-delay1;
delayRange=(delay2-delay1)/2;
}
// ******************************************************************************************
-(void)		setDelay2:(int)d2
{
if(delay2<0) delay2=0; if(delay2>=msize) delay2=msize-1;
delay2=d2;
delayMid=delay2-delay1;
delayRange=(delay2-delay1)/2;
}
// ************************************************************************************************
-(void)		filterChunk:(float*)ioData frame:(UInt32)inNumFrames
{
UInt32 i;
float inputSample;

for (i=0; i<inNumFrames; ++i) 
	{
	inputSample=*ioData;
	delay=(UInt32)(delayMid+sin(LFOphase)*delayRange);
	tap[count%msize]=inputSample;
	if(count>delay)inputSample=inputSample+strength*tap[(count-delay)%msize]; 

	count++;
	LFOphase=LFOphase+LFOdelta;
	*ioData++=inputSample;
	}
}
// ******************************************************************************************
-(float)	filter:(float)input
{
delay=(UInt32)(delayMid+sin(LFOphase)*delayRange);
tap[count%msize]=input;
if(count>delay)input=input+strength*tap[(count-delay)%msize]; 

count++;
LFOphase=LFOphase+LFOdelta;
return input;
}
// ******************************************************************************************


@end
