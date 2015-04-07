// ***************************************************************************************
//  WXDSEnvelopeSeries
//  Created by Paul Webb on Sat Jul 23 2005.
// ***************************************************************************************


#import "WXDSEnvelopeSeries.h"


@implementation WXDSEnvelopeSeries

// ***************************************************************************************
-(id)		init
{
if(self=[super init])
	{
	theSeries=[[NSMutableArray alloc]init];
	currentEnvelope=nil;
	
	}
return self;
}
// ***************************************************************************************
-(void)		dealloc
{
[theSeries release];
[super dealloc];
}
// ***************************************************************************************
-(void)		test:(int)duration
{
WXDSEnvelopeBasic   *e1,*e2,*e3,*e4;
int numberGestures=WXURandomInteger(1,7),t;


numberGestures=1;
for(t=0;t<numberGestures;t++)
	{
	e1=[[WXDSEnvelopeSegmentGaussian alloc]initSegmentGaussian:0.0 g2:1.0];
//e2=[[WXDSEnvelopeSegmentGaussian alloc]initSegmentGaussian:0.0 g2:1.0];
//e3=[[WXDSEnvelopeSegmentGaussian alloc]initSegmentGaussian:0.0 g2:1.0];
//e4=[[WXDSEnvelopeSegmentGaussian alloc]initSegmentGaussian:0.0 g2:1.0];

	[e1 setDuration:duration/numberGestures];
	//[e2 setDuration:duration*25/100];
	//[e3 setDuration:duration*25/100];
	//[e4 setDuration:duration*25/100];

	[self addObjectAndRelease:e1];
	
	}
//[self addObjectAndRelease:e2];
//[self addObjectAndRelease:e3];
//[self addObjectAndRelease:e4];
}
// ***************************************************************************************
-(void)		addObjectAndRelease:(id)env
{
[theSeries addObject:env];
currentEnvelope=[theSeries objectAtIndex:0];
numberSegments=[theSeries count];
[env release];
}
// ***************************************************************************************
-(void)		addObject:(id)env
{
[theSeries addObject:env];
currentEnvelope=[theSeries objectAtIndex:0];
numberSegments=[theSeries count];
}
// ***************************************************************************************
-(void)		reset								
{
[theSeries makeObjectsPerformSelector:@selector(reset)];
currentEnvelope=[theSeries objectAtIndex:0];
numberSegments=[theSeries count];
currentSegment=0;
[super reset];					
}
// ***************************************************************************************
-(void)		renderEnvelopeOnto:(AudioBufferList*)ioData frame:(UInt32)inNumFrames skipSize:(int)skipSize
{
UInt32 i;

if(done)	return;


float*  out1 =(float*) ioData->mBuffers[0].mData;
float*  out2 =(float*) ioData->mBuffers[1].mData;
float   gain;

for (i=0; i<inNumFrames; i++) 
	{
	gain=[currentEnvelope tick];
	if([currentEnvelope done])
		{
		currentSegment++;
		if(currentSegment>=numberSegments) done=YES;
		else currentEnvelope=[theSeries objectAtIndex:currentSegment];
		}
	
	
	out1[i+skipSize] = out1[i+skipSize]*gain;
	out2[i+skipSize] = out2[i+skipSize]*gain;
	}
}

// ***************************************************************************************
@end
