// ***************************************************************************************
//  WXDSWavePlotter
//  Created by Paul Webb on Sun Jan 09 2005.
// ***************************************************************************************

#import "WXDSWavePlotter.h"
// ******************************************************************************************
@implementation WXDSWavePlotter

- (id)initWithFrame:(NSRect)frameRect
{
xsize=512;
ysize=100;
frameRect.size.width=xsize;
frameRect.size.height=ysize;
if ((self = [super initWithFrame:frameRect]) != nil) 
	{
	showCentre=YES;
	showGraph=YES;
	theStep=1;
	theUpdateFreq=16;
	waveSize=512;
	xgap=5;
	style=1;
	counter=0;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doPlotter:) name:@"plotWave" object:nil];
	
	mInputBuffer=0;
	}
return self;
}
// ******************************************************************************************
-(void)		setStep:(int)v				{	theStep=v;			}
-(void)		setUpdateFreq:(int)v		{	theUpdateFreq=v;	}
-(void)		setStyle:(short)v gap:(int)g		
{   
style=v;	
xgap=g;		
}
// ******************************************************************************************
-(void)		doPlotter:(NSNotification *)notification
{
WXDSSoundInputSystem*   object=[notification object];
mInputBuffer=[object getBuffer];
counter++;
if(counter%theUpdateFreq==0)	
	[self setNeedsDisplay:true];
}
// ******************************************************************************************
- (void)drawRect:(NSRect)rect
{
int		t;
float   x,scale,yc1=30,yc2=60,v,v1;
float*  out1,*out2; 
scale=20;

[[NSColor colorWithDeviceRed:214/256.0 green:219/256.0 blue:191/256.0 alpha:1.0] set];	
NSRectFill(rect);
[[NSColor darkGrayColor]set];
NSFrameRect(rect);

[[NSColor redColor]set];	
if(showCentre)
	{
	[NSBezierPath strokeLineFromPoint:NSMakePoint(0,yc1) toPoint:NSMakePoint(xgap*waveSize/theStep,yc1)];
	[NSBezierPath strokeLineFromPoint:NSMakePoint(0,yc2) toPoint:NSMakePoint(xgap*waveSize/theStep,yc2)];
	}


[[NSColor blackColor]set];


if(mInputBuffer!=0)
	{
	out1=(float*) mInputBuffer->mBuffers[0].mData;
	out2=(float*) mInputBuffer->mBuffers[1].mData;
	v1=0;   x=0;
	for(t=0;t<waveSize;t+=theStep)
		{
		v=*out1++;
		switch(style)
			{
			case 1: [NSBezierPath strokeLineFromPoint:NSMakePoint(x-xgap,yc1+v1*scale) toPoint:NSMakePoint(x,yc1+v*scale)]; break;
			case 2: NSRectFill(NSMakeRect(x-1,yc1+v1*scale-1,2,2)); break;
			}
		v1=v;   x+=xgap;
		}
	v1=0;   x=0;
	for(t=0;t<waveSize;t+=theStep)
		{
		v=*out2++;
		switch(style)
			{
			case 1: [NSBezierPath strokeLineFromPoint:NSMakePoint(x-xgap,yc2+v1*scale) toPoint:NSMakePoint(x,yc2+v*scale)]; break;
			case 2: NSRectFill(NSMakeRect(x-1,yc2+v1*scale-1,2,2)); break;
			}
		v1=v;   x+=xgap;
		}
	}

[[NSColor redColor]set];	
if(showCentre)
	{
	[NSBezierPath strokeLineFromPoint:NSMakePoint(0,yc1) toPoint:NSMakePoint(waveSize/theStep,yc1)];
	[NSBezierPath strokeLineFromPoint:NSMakePoint(0,yc2) toPoint:NSMakePoint(waveSize/theStep,yc2)];
	}
}
// ******************************************************************************************
@end