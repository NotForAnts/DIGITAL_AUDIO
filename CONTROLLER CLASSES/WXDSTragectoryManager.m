// ***************************************************************************************
//  WXDSTragectoryManager
//  Created by Paul Webb on Mon Jul 18 2005.
// ***************************************************************************************

#import "WXDSTragectoryManager.h"


@implementation WXDSTragectoryManager

// ***************************************************************************************
-(id)		init
{
if(self=[super init])
	{
	createTimeInterval=[NSDate timeIntervalSinceReferenceDate];
	tragectories=[[NSMutableArray alloc]init];
	currentValue=0;
	startUpTimeInterval=0;
	endTimeInterval=0;
	endValue=0;
	
	expCalc=[[WXCalculatorExponential alloc]initWave:10 range1:0 range2:0 slope:5.0];
	expMCalc=[[WXCalculatorExponentialMirror alloc]initWave:10 range1:0 range2:0 slope1:5.0 slope2:5.0];
	logCalc=[[WXCalculatorLog alloc]initWave:10 range1:0 range2:0 slope:5.0];
	logMCalc=[[WXCalculatorLogMirror alloc]initWave:10 range1:0 range2:0 slope1:5.0 slope2:5.0];
	rwCalc=[[WXCalculatorRandomWalk alloc]initWave:-5 walkRange2:5 range1:0 range2:0];
	sawCalc=[[WXCalculatorSawWave alloc]initWave:10 mid:5 range1:0 range2:0];
	sineCalc=[[WXCalculatorSineWave alloc]initWave:10 range1:0 range2:0 degree1:0 degree2:360];
	smoothCalc=[[WXCalculatorSmoothSine alloc]initWave:10 range1:0 range2:0 mid:5];
	spikeCalc=[[WXCalculatorSpikes alloc]initWave:1 wavelength2:10 range1:0 range2:0];
	pinkCalc=[[WXCalculatorsPINKNOISE alloc]initWave:0 range2:0 numberDice:3];
	squareCalc=[[WXCalculatorSquareWave alloc]initWave:10 mid:5 range1:0 range2:0];
	vsawCalc=[[WXCalculatorVariedSaw alloc]initWave:10 maxWaveSize:20 range1:0 range2:0];
	vtriCalc=[[WXCalculatorVariedTriangleWave alloc]initWave:10 maxWaveSize:20 range1:0 range2:0 range3:0 range4:0];
	rpeakCalc=[[WXCalculatorRandomPeaks alloc]initWave:10 range1:0 range2:0 startLoop:NO];
	}
return self;
}
// ***************************************************************************************
-(void)		dealloc
{
[tragectories release];
[expCalc release];
[expMCalc release];
[logCalc release];
[logMCalc release];
[rwCalc release];
[sawCalc release];
[sineCalc release];
[smoothCalc release];
[spikeCalc release];
[pinkCalc release];
[squareCalc release];
[vsawCalc release];
[vtriCalc release];
[rpeakCalc release];
[super dealloc];
}
// ***************************************************************************************
-(void)		setStartIsNow
{
startUpTimeInterval=[NSDate timeIntervalSinceReferenceDate]-createTimeInterval;
int t;
for(t=0;t<[tragectories count];t++)
	{
	[[tragectories objectAtIndex:t]setStartIsNow:startUpTimeInterval]; 
	}
}
// ***************************************************************************************
-(id)		currentValueNSO					{   return  [NSNumber numberWithFloat:currentValue];	}
-(float)	currentValue					{   return  currentValue;								}
-(float)	lastAddedValue					{   return  lastAddedValue;								}
-(float)	endValue						{   return  endValue;									}
-(void)		setEndValue:(float)v			{   endValue=v;											}
-(NSTimeInterval)   endTimeInterval			{   return  endTimeInterval;							}
-(NSTimeInterval)   lastTimeInterval		{   return  lastTimeInterval;							}
-(int)		getNumberTrags					{   return [tragectories count];						}
-(BOOL)		isEmpty							{   return [tragectories count]==0;						}
-(BOOL)		isLess:(int)n					{   return [tragectories count]<n;						}
-(BOOL)		wasUpdateCP						{   return wasUpdate;									}
// ***************************************************************************************
-(BOOL)		doUpdate
{
int		t,size=[tragectories count];
wasUpdate=NO;
if(size==0) return NO;

NSDate  *timeNow=[NSDate dateWithTimeIntervalSinceNow:0];
WXDSTragectoryObject	*checkTrag;

for(t=0;t<size;t++)
	{
	checkTrag=[tragectories objectAtIndex:t];
	if([checkTrag checkUpdate:timeNow])
		{
		currentValue=[checkTrag currentValue];
		wasUpdate=YES;
		}
	}

// removal of ones finished	
t=0;
while(t<[tragectories count])
	{
	checkTrag=[tragectories objectAtIndex:t];
	if([checkTrag isDone])
		[tragectories removeObjectAtIndex:t];
	else
		t++;
	}

return wasUpdate;
}
// ***************************************************************************************
-(void)		makeCopyInto:(WXDSTragectoryManager*)dest
{
if(dest==nil)   return;
[dest removeAllObjects];
int t;
NSTimeInterval firstTime=[self findFirstTimeInterval];
WXDSTragectoryObject	*copy;

for(t=0;t<[tragectories count];t++)
	{
	copy=[[tragectories objectAtIndex:t] deepCopy];
	[dest addObject:copy];
	[copy release];
	}
}
// ***************************************************************************************
-(NSTimeInterval)   findFirstTimeInterval
{
NSTimeInterval  testTime,timeFound=0;
int t;
for(t=0;t<[tragectories count];t++)
	{
	testTime=[[tragectories objectAtIndex:t] getStartTimeInterval];
	if(t==0) timeFound=testTime;
	else if(testTime<timeFound) timeFound=testTime;
	}
return timeFound;
}
// ***************************************************************************************
-(void)		setStartTimePointInterval:(NSTimeInterval)startTime
{
int t;
for(t=0;t<[tragectories count];t++)
	[[tragectories objectAtIndex:t]setStartTimePointInterval:startTime];
}
// ***************************************************************************************
-(void)		setTimeScale:(float)scale
{
int t;
for(t=0;t<[tragectories count];t++)
	[[tragectories objectAtIndex:t]setTimeScale:scale];
}
// ***************************************************************************************
-(void) removeAllObjects
{
[tragectories removeAllObjects];
}
// ***************************************************************************************
-(void) addObject:(id)anObject
{
[tragectories addObject:anObject];
}
// ***************************************************************************************
-(WXDSTragectoryObject*)	objectAtIndex:(unsigned)index
{
return [tragectories objectAtIndex:index];
}
// ***************************************************************************************
// BASIC CURVE ADDED FUNCTIONS
// ref based on the basic sysex klangs
// ***************************************************************************************
-(void)		prepare
{
tragObject=[[WXDSTragectoryObject alloc]init];
totalInterval=[NSDate timeIntervalSinceReferenceDate];
[tragObject setStartTimePointInterval:totalInterval];
}
// ***************************************************************************************
-(void)		finish
{
[tragectories addObject:tragObject];	
[tragObject release];	
lastAddedValue=value;
lastTimeInterval=interval;
if(interval>endTimeInterval)	
	{
	endTimeInterval=interval;
	endValue=value;
	}
}
// ***************************************************************************************
-(void)		addLine:(int)number v1:(float)v1 v2:(float)v2 d1:(float)d1 d2:(float)d2
{
int		t;
[self prepare];

for(t=0;t<number;t++)
	{
	value=WXUNormalise(t,0,number-1,v1,v2);
	interval=WXUNormalise(t,0,number-1,d1,d2);//+totalInterval;
	[tragObject addValue:value atTime:[NSDate dateWithTimeIntervalSinceReferenceDate:interval]];
	}

[self finish];
}
// ***************************************************************************************
-(void)		addRandom:(int)number v1:(float)v1 v2:(float)v2 d1:(float)d1 d2:(float)d2
{
int		t;
[self prepare];

for(t=0;t<number;t++)
	{
	value=WXUFloatRandomBetween(v1,v2);
	interval=WXUNormalise(t,0,number-1,d1,d2);//+totalInterval;
	[tragObject addValue:value atTime:[NSDate dateWithTimeIntervalSinceReferenceDate:interval]];
	}

[self finish];
}
// ***************************************************************************************
-(void)		addFromCalc:(WXCalculatorBasic*)calc number:(int)number d1:(float)d1 d2:(float)d2
{
int		t;
[self prepare];
[calc setLoopSize:number];
[calc reset];

for(t=0;t<number;t++)
	{
	value=[calc doUpdate];
	interval=WXUNormalise(t,0,number-1,d1,d2);//+totalInterval;
	[tragObject addValue:value atTime:[NSDate dateWithTimeIntervalSinceReferenceDate:interval]];
	}

[self finish];
}
// ***************************************************************************************
-(void)		addExp:(int)number v1:(float)v1 v2:(float)v2 d1:(float)d1 d2:(float)d2
{
[expCalc setRanges:v1 range2:v2];
[self addFromCalc:expCalc number:number d1:d1 d2:d2];
}
// ***************************************************************************************
-(void)		addExpMirror:(int)number v1:(float)v1 v2:(float)v2 d1:(float)d1 d2:(float)d2
{
[expMCalc setRanges:v1 range2:v2];
[self addFromCalc:expMCalc number:number d1:d1 d2:d2];
}
// ***************************************************************************************
-(void)		addLog:(int)number v1:(float)v1 v2:(float)v2 d1:(float)d1 d2:(float)d2
{
[logCalc setRanges:v1 range2:v2];
[self addFromCalc:logCalc number:number d1:d1 d2:d2];
}
// ***************************************************************************************
-(void)		addLogMirror:(int)number v1:(float)v1 v2:(float)v2 d1:(float)d1 d2:(float)d2
{
[logMCalc setRanges:v1 range2:v2];
[self addFromCalc:logMCalc number:number d1:d1 d2:d2];
}
// ***************************************************************************************
-(void)		addWalk:(int)number v1:(float)v1 v2:(float)v2 d1:(float)d1 d2:(float)d2
{
[rwCalc setRanges:v1 range2:v2];
[rwCalc setWalk:-(abs(v2-v1)*10./100.0) w2:(abs(v2-v1)*10./100.0)];
[self addFromCalc:rwCalc number:number d1:d1 d2:d2];
}
// ***************************************************************************************
-(void)		addSaw:(int)number v1:(float)v1 v2:(float)v2 d1:(float)d1 d2:(float)d2
{
[sawCalc setRanges:v1 range2:v2];
[sawCalc setMidPoint:number/2];
[self addFromCalc:sawCalc number:number d1:d1 d2:d2];
}
// ***************************************************************************************
-(void)		addSine:(int)number v1:(float)v1 v2:(float)v2 d1:(float)d1 d2:(float)d2 deg1:(float)deg1 deg2:(float)deg2
{
[sineCalc setRanges:v1 range2:v2];
[sineCalc setDegree:deg1 degree2:deg2];
[self addFromCalc:sineCalc number:number d1:d1 d2:d2];
}
// ***************************************************************************************
-(void)		addSmoothSine:(int)number v1:(float)v1 v2:(float)v2 d1:(float)d1 d2:(float)d2
{
[smoothCalc setRanges:v1 range2:v2];
[self addFromCalc:smoothCalc number:number d1:d1 d2:d2];
}
// ***************************************************************************************
-(void)		addPink:(int)number v1:(float)v1 v2:(float)v2 d1:(float)d1 d2:(float)d2
{
[pinkCalc setRanges:v1 range2:v2];
[self addFromCalc:pinkCalc number:number d1:d1 d2:d2];
}
// ***************************************************************************************
-(void)		addSquare:(int)number v1:(float)v1 v2:(float)v2 d1:(float)d1 d2:(float)d2
{
[squareCalc setRanges:v1 range2:v2];
[squareCalc setMidPoint:number/2];
[self addFromCalc:squareCalc number:number d1:d1 d2:d2];
}
// ***************************************************************************************
-(void)		addPeak:(int)number v1:(float)v1 v2:(float)v2 d1:(float)d1 d2:(float)d2
{
[rpeakCalc setRanges:v1 range2:v2];
[self addFromCalc:rpeakCalc number:number d1:d1 d2:d2];
}
// ***************************************************************************************


@end
