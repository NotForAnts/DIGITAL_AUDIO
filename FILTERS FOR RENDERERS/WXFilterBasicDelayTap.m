// ******************************************************************************************
//  WXFilterBasicDelayTap
//  Created by Paul Webb on Wed Dec 29 2004.
// ******************************************************************************************

#import "WXFilterBasicDelayTap.h"


@implementation WXFilterBasicDelayTap
// ******************************************************************************************
-(id)		initFilter:(UInt32)delay fb:(float)fb
{
if(self=[super init])
	{
	msize=delay;
	delaylength=delay;
	count=0;
	feedback=fb;
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
-(id)		initFilter:(UInt32)size delay:(UInt32)delay fb:(float)fb
{
if(self=[super init])
	{
	msize=size;
	delaylength=delay;
	count=0;
	feedback=fb;
	tap=malloc(msize*sizeof(float));
	}
return self;
}
// ******************************************************************************************
-(void) 	setDelayNSO:(id)delay		{   delaylength=[delay floatValue];		}
-(void) 	setDelay:(long)delay		{   delaylength=delay;					}	
// ******************************************************************************************
-(float)	filter:(float)input
{
tap[count%msize]=input;
if(count>delaylength) input=tap[(count-delaylength)%msize]*feedback;
count++;
return input;
}
// ******************************************************************************************
-(float)    filterFB:(float)input
{
if(count>delaylength) input=tap[(count-delaylength)%msize]*feedback;
tap[count%msize]=input;
count++;
return input;
}
// ******************************************************************************************

@end
