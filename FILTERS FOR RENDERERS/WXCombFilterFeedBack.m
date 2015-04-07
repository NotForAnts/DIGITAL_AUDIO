// ******************************************************************************************
//  WXCombFilterFeedBack
//  Created by Paul Webb on Wed Dec 29 2004.
// ******************************************************************************************

#import "WXCombFilterFeedBack.h"



@implementation WXCombFilterFeedBack

// ******************************************************************************************
-(id)		initComb:(UInt32)ms delay:(UInt32)d
{
if(self=[super init])
	{
	msize=ms;
	theDelay=d;
	count=0;
	strength=0.95;
	tap=malloc(msize*sizeof(float));
	}
return self;
}
// ***************************************************************************************
-(void)		doController:(int)index value:(float)value
{
switch(index)
	{
	case 1:		theDelay=(UInt32)value;		break;
	case 2:		strength=value;				break;
	}
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
-(void)		setDelayNSO:(id)delay		{	theDelay=(UInt32)[delay floatValue];	}
-(void)		setFStrengthNSO:(id)s		{	strength=[s floatValue];				}
-(void)		setDelay:(long)delay		{   theDelay=(UInt32)delay;					}
-(void)		setFStrength:(float)s		{   strength=s;								}
// ************************************************************************************************
-(void)		filterChunk:(float*)ioData frame:(UInt32)inNumFrames
{
UInt32 i;
float inputSample;

for (i=0; i<inNumFrames; ++i) 
	{
	inputSample=*ioData;
	if(count>theDelay)inputSample=inputSample+strength*tap[(count-theDelay)%msize]; 
	tap[count%msize]=inputSample;
	count++;
	*ioData++=inputSample;
	}
}
// ******************************************************************************************
-(float)	filter:(float)input
{
if(count>theDelay)input=input+strength*tap[(count-theDelay)%msize]; 
tap[count%msize]=input;
count++;
return input;
}
// ******************************************************************************************

@end
