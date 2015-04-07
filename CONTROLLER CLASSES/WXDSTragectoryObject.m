// ***************************************************************************************
//  WXDSTragectoryObject
//  Created by Paul Webb on Mon Jul 18 2005.
// ***************************************************************************************

#import "WXDSTragectoryObject.h"


@implementation WXDSTragectoryObject

// ***************************************************************************************
-(id)   init
{
if(self=[super init])
	{
	startUpTimeInterval=0;
	timepoints=[[NSMutableArray alloc]init];
	values=[[NSMutableArray alloc]init];
	currentIndex=0;
	currentValue=0;
	isDone=NO;
	size=0;
	timeScale=1.0;
	}
return self;
}
// ***************************************************************************************
-(void)		dealloc
{
[timepoints release];
[values release];
[super dealloc];
}
// ***************************************************************************************
-(id)		deepCopy
{
WXDSTragectoryObject	*copy=[[WXDSTragectoryObject alloc]init];
int t;
float   value;
NSTimeInterval  timeInterval;
NSDate* date;
for(t=0;t<[values count];t++)
	{
	value=[[values objectAtIndex:t]floatValue];
	timeInterval=[[timepoints objectAtIndex:t] timeIntervalSinceReferenceDate];
	date=[NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
	[copy addValue:value atTime:date];
	
	//printf("v=%f %f\n",value,(double)[date timeIntervalSinceReferenceDate]);
	}
return copy;	
}
// ***************************************************************************************
-(void)		shiftByTime:(NSTimeInterval)shift   {   startUpTimeInterval+=shift;		}
-(void)		setTimeScale:(float)scale			{   timeScale=scale;				}
-(float)	currentValue						{   return currentValue;			}
-(BOOL)		isDone								{   return isDone;					}
-(int)		size								{   return size;					}
// ***************************************************************************************
-(NSTimeInterval) getStartTimeInterval  
{  
 return	[[timepoints objectAtIndex:0]	timeIntervalSinceReferenceDate];				
}
// ***************************************************************************************
-(void)		setStartTimePointInterval:(NSTimeInterval)interval
{
startUpTimeInterval=interval;
}
// ***************************************************************************************
-(void)		addValue:(float)value atTime:(NSDate*)timepoint
{
[values addObject:[NSNumber numberWithFloat:value]];
[timepoints addObject:timepoint];
size=[values count];
}
// ***************************************************************************************
-(BOOL)		checkUpdate:(NSDate*)timepoint
{
if(size==0) return NO;
if(isDone)  return NO;
NSTimeInterval  timeGap;
NSDate  *currentdate=[timepoints objectAtIndex:currentIndex];

timeGap=[currentdate timeIntervalSinceReferenceDate];
timeGap*=timeScale;

currentdate=[NSDate dateWithTimeIntervalSinceReferenceDate:timeGap+startUpTimeInterval];

if([currentdate compare:timepoint]==NSOrderedAscending)
	{
	currentValue=[[values objectAtIndex:currentIndex] floatValue];
	currentIndex++;
	if(currentIndex>=size)  isDone=YES;
	return YES;
	}

return NO;
}
// ***************************************************************************************
//  MUTATIONS
//  These mutate the values of the tragectory object itself
//  To make a mutated copy
//  mutant=[[source deepCopy] transformation];
// ***************************************************************************************
-(void)		scaleTimes:(float)scale
{
int		t,count=[timepoints count];
float   interval;
for(t=0;t<count;t++)
	{
	interval=[[timepoints objectAtIndex:t] timeIntervalSinceReferenceDate]*scale;
	[timepoints replaceObjectAtIndex:t withObject:[NSDate dateWithTimeIntervalSinceReferenceDate:interval]];
	}
}
// ***************************************************************************************
-(void)		scaleValue:(float)scale shift:(float)shift
{
int		t,count=[values count];
for(t=0;t<count;t++)
	{
	[timepoints replaceObjectAtIndex:t withObject:[NSNumber numberWithFloat:
		[[timepoints objectAtIndex:t]floatValue]*scale+shift]];
	}
}
// ***************************************************************************************
-(void)		retrogradeValues
{
NSMutableArray  *retro=[[NSMutableArray alloc]init];
int		t,count=[values count];
for(t=count-1;t>=0;t++)
	[retro addObject:[NSNumber numberWithFloat:[[values objectAtIndex:t]floatValue]]];
	
[values release];
values=retro;
}
// ***************************************************************************************

// ***************************************************************************************


@end
