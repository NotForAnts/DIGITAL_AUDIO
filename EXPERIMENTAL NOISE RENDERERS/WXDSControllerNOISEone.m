// ***************************************************************************************
//  WXDSControllerNOISEone.m
//  Created by Paul Webb on Mon Sep 19 2005.
// ***************************************************************************************

#import "WXDSControllerNOISEone.h"


@implementation WXDSControllerNOISEone

// ***************************************************************************************
-(id)		initWithObject:(WXDSNOISEone*)n
{
if(self=[super init])
	{
	theNoise=n;
	mapRange2=127;
	
	pattern=[[NSMutableString alloc]initWithString:@"abefabefabefabefabegabegabegabeg"];
	patternLength=[pattern length];
	patternIndex=0;
	patternCount=0;
	
	updateCounter=0;
	updateRate=2;
	
	[self initParameterForControlPitchPatterns];
	[self initParameterForNoiseIntenseOne];
	

	}
return self;
}
// ***************************************************************************************
-(void)		dealloc
{

}
// ***************************************************************************************
-(void) doStart
{
[trag1 setStartIsNow];
[trag2 setStartIsNow];
[trag3 setStartIsNow];
}
// ***************************************************************************************
-(void)		setControlAsMap:(int)type value:(int)value
{
switch(type)
	{
	case 1:		[theNoise setMutateStrength:WXUNormalise(value,0,mapRange2,0.0,10.0)];
				break;
				
	case 2:		[theNoise setMutateRate:WXUNormalise(value,0,mapRange2,1,200)];
				break;

	case 3:		[theNoise setEveryCount:WXUNormalise(value,0,mapRange2,1,20)];
				break;	
				
	case 4:		[theNoise setDeltaStart1:WXUNormalise(value,0,mapRange2, -1.92636191114421113646, 1.92636191114421113646)];
				break;

	case 5:		[theNoise setDeltaStart2:WXUNormalise(value,0,mapRange2, -0.00030591641978933724, 0.00030591641978933724)];
				break;
				
	case 6:		[theNoise setDeltaStart4:WXUNormalise(value,0,mapRange2, -1.92534652831449180077, 1.92534652831449180077)];
				break;
	}
}
// ***************************************************************************************
-(void)		initParameterForNoiseIntenseOne
{
mapRange2=1000;
[self setControlAsMap:1 value:0];
[self setControlAsMap:2 value:3];
[self setControlAsMap:3 value:20];
[self setControlAsMap:4 value:0];
[self setControlAsMap:5 value:60];
[self setControlAsMap:6 value:84];
[theNoise setPanShiftActive:NO];
[theNoise setCombineType:1];

trag1=[[WXDSTragectoryManager alloc]init];		[trag1 setEndValue:100];
trag2=[[WXDSTragectoryManager alloc]init];		[trag2 setEndValue:100];
trag3=[[WXDSTragectoryManager alloc]init];		[trag3 setEndValue:100];
trag4=[[WXDSTragectoryManager alloc]init];		[trag4 setEndValue:0.3];

tragPatterns=[[WXDSTragectoryPatternManager alloc]init];	
}
// ***************************************************************************************
-(void)		doNoiseIntenseOne
{
//updateCounter++;
//if(updateCounter % updateRate!=0)   return;

if([trag1 doUpdate])  [self setControlAsMap:4 value:[trag1 currentValue]];
if([trag2 doUpdate])  [self setControlAsMap:5 value:[trag2 currentValue]];
if([trag3 doUpdate])  [self setControlAsMap:3 value:[trag3 currentValue]];
if([trag4 doUpdate])  
	{
	float v;
	//[theNoise setMasterGain:[trag4 currentValue]];
	v=[[trag4 performSelector:@selector(currentValueNS)]floatValue];
	[theNoise setMasterGain:v];
	}

[self addShapeOne];

//if(WXUPercentChance(82)) [theNoise setCombineType:WXURandomInteger(1,3)];
}
// ***************************************************************************************
-(void)		addShapeOne
{
float   rate=WXUFloatRandomBetween(1.0,2.0);
float   number=WXUFloatRandomBetween(0.25,2.0);

if(![trag4 isEmpty])	return;
[trag1 removeAllObjects];
[trag2 removeAllObjects];
[trag3 removeAllObjects];
[trag4 removeAllObjects];

if([tragPatterns count]>7)  
	{
	if(WXUPercentChance(97)) return;
	
	int patt=WXURandomInteger(0,[tragPatterns count]-1);
	printf("patt %d\n",patt);
	
	[tragPatterns makeRealTimeCopyScale:patt index:0 dest:trag1 scale:0.1];
	[tragPatterns makeRealTimeCopyScale:patt index:1 dest:trag2 scale:0.1];
	[tragPatterns makeRealTimeCopyScale:patt index:2 dest:trag3 scale:0.1];
	[tragPatterns makeRealTimeCopyScale:patt index:3 dest:trag4 scale:0.1];
	
	return;
	}



[trag1 addSmoothSine:25*rate*number v1:WXURandomInteger(600,1000) v2:20 d1:1.0 d2:4.0*rate];
[trag2 addLine:25*rate*number v1:WXURandomInteger(600,1000) v2:20 d1:1.6*rate d2:4.0*rate];
[trag2 addLine:25*rate*number v1:20 v2:WXURandomInteger(200,300) d1:0.3*rate d2:4.0*rate];
[trag3 addLine:3*rate*number v1:0 v2:170 d1:2.3*rate d2:4.0*rate];
[trag3 addRandom:4*rate*number v1:4 v2:170 d1:3.1*rate d2:4.0*rate];

[trag4 addLine:10*rate*number v1:0.4 v2:3.0 d1:0.0 d2:1.0*rate];
if(WXUPercentChance(22))[trag4 addPink:10*rate*number v1:0.4 v2:3.0 d1:0.1 d2:1.1*rate];
[trag4 addLine:10*rate*number v1:3.0 v2:0.4 d1:1.0*rate d2:2.0*rate];
if(WXUPercentChance(22))[trag4 addPink:10*rate*number v1:0.4 v2:3.0 d1:1.1 d2:2.1*rate];
if(WXUPercentChance(52))[trag4 addLine:10*rate*number v1:3.0 v2:0.4 d1:2.0*rate d2:3.0*rate];
[trag4 addPink:10*rate v1:3.0 v2:0.4 d1:3.0*rate d2:4.0*rate];

//if([tragPatterns count]>3)  return;

[tragPatterns makeNewStore];
[tragPatterns addToLast:trag1];
[tragPatterns addToLast:trag2];
[tragPatterns addToLast:trag3];
[tragPatterns addToLast:trag4];
}
// ***************************************************************************************
-(void)		initParameterForControlPitchPatterns
{
[self setControlAsMap:1 value:0];
[self setControlAsMap:2 value:3];
[self setControlAsMap:3 value:0];
[self setControlAsMap:4 value:0];
[self setControlAsMap:5 value:60];
[self setControlAsMap:6 value:54];
[theNoise setPanShiftActive:NO];
}
// ***************************************************************************************
-(void)		doControlPitchPatterns
{
int c;
updateCounter++;
if(updateCounter % updateRate!=0)   return;

c=[pattern characterAtIndex:patternIndex];
patternIndex++;
patternCount++;
if(patternIndex>=patternLength) patternIndex=0;

if(c=='-')   return;
c=c-97+54;

if(patternCount % 9==0)				[theNoise setMasterGain:0.3]; else [theNoise setMasterGain:0.2]; 
if(patternCount % 11==0)			[theNoise setMasterGain:0.5]; 
if(patternCount % 21==0)			[self setControlAsMap:4 value:WXURandomInteger(0,124)];
if(patternCount % 33==0)			[self setControlAsMap:5 value:WXURandomInteger(20,124)];
if(patternCount % 22==0)			[self setControlAsMap:4 value:WXURandomInteger(0,124)];
if(patternCount % 36==0)			[self setControlAsMap:5 value:WXURandomInteger(20,124)];
if(patternCount % 27==0)			[self setControlAsMap:3 value:WXURandomInteger(1,40)]; else [self setControlAsMap:3 value:0];
if(patternIndex % 4==0)				[self setControlAsMap:4 value:WXURandomInteger(0,84)];
if(patternIndex % 16==0)			[self setControlAsMap:5 value:WXURandomInteger(40,94)];

if(patternCount % 133==0)			[theNoise setCombineType:WXURandomInteger(1,3)];
if(patternCount % 90==0)			[self setControlAsMap:1 value:40]; 
if(patternCount % 32==0)			[self setControlAsMap:1 value:0];

[self setControlAsMap:6 value:c];

}
// ***************************************************************************************



@end
