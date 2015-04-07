// ***************************************************************************************
//  WSDSInputSuddenLoudMonitor
//  Created by veronica ibarra on 04/10/2006.
// ***************************************************************************************

#import "WSDSInputSuddenLoudMonitor.h"


@implementation WSDSInputSuddenLoudMonitor
// ***************************************************************************************

-(id)		init
{
if(self=[super init])
	{
	gainConstant=3.5;
	isActive=NO;
	timeWindow=[[WXTimeWindowStore alloc]initWithTimeLength:4000];
	}
return self;
}
// ***************************************************************************************
-(void)		dealloc
{
[super dealloc];
}
// ***************************************************************************************
-(void)		startThread
{
counter=0;
[timeWindow reset];
isActive=YES;
doneFirstUpdate=NO;
[NSThread detachNewThreadSelector:@selector(backGroundThread) toTarget:self withObject:self];
}
// ******************************************************************************************
-(void)		backGroundThread
{
NSAutoreleasePool *pool2;
pool2 = [[NSAutoreleasePool alloc] init];

float	clevel;
do{


	currentTime=AudioGetCurrentHostTime()/(AudioGetHostClockFrequency()/1000.0);
	clevel=[self currentTotal];
	[timeWindow bang:currentTime value:clevel];

	counter++;
	if(counter>=10)
		{
		[timeWindow doUpdate];
		if([timeWindow wasUpdated])
			{
			doneFirstUpdate=YES;
			currentAverage=[timeWindow getAverage];
			
			//printf("LEVEl %d\n",(int)currentAverage);
			}
		}
		
	if(doneFirstUpdate)	
		if(clevel>currentAverage*gainConstant && clevel>4*gainConstant)
			{
		
			printf("ALARM %d %f<---------------------------\n",(int)clevel,4*gainConstant);
			
			[[NSNotificationCenter defaultCenter]   postNotificationName:@"LOUDALARM" object:self];	
			}

	[NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
	}while(isActive);


[pool2 release];
}
// ***************************************************************************************
-(void)		setLoudDangerLevel:(float)level
{
gainConstant=level;
}
// ***************************************************************************************

@end
