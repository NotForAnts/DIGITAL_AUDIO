// ******************************************************************************************
//  WXDSFFTView
//  Created by Paul Webb on Fri Jan 07 2005.
// ******************************************************************************************

#import "WXDSFFTView.h"


// ******************************************************************************************
@implementation WXDSFFTView

- (id)initWithFrame:(NSRect)frameRect
{
short t;
xsize=250;
ysize=100;
frameRect.size.width=xsize;
frameRect.size.height=ysize;
if ((self = [super initWithFrame:frameRect]) != nil) 
	{
	timeWindow=[[WXTimeWindowStore alloc]initWithTimeLength:100];
	[timeWindow reset];
	
	doRunningAverage=YES;
	isActive=YES;
	for(t=0;t<1000;t++) peakCount[t]=peaks[t]=0;
	quantize=1;
	resetPeakCount=0;
	xgap=4;
	plots=0;
	theData=0;	
	counter=0;
	runningSum=0;
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(analiserUpdate:) name:@"GOTSALIENT" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(analiserUpdate:) name:@"Analised" object:nil];
	mInputBuffer=0;
	}
return self;
}
// ******************************************************************************************
-(void)		setActive:(BOOL)state		{		isActive=state;		}
// ******************************************************************************************
-(void)		analiserUpdate:(NSNotification *)notification
{
if(!isActive)   return;
theData=[[notification object]getReal];
plots=[[notification object]numberFreqsChecked];
counter++;
if(counter%4==0)	
	[self setNeedsDisplay:true];
}
// ******************************************************************************************

// ******************************************************************************************
- (void)drawRect:(NSRect)rect
{
float   v;
float   v1,v2;
int t,p,xd=0;
float x,y,xl,yl,scale,yc=10;

if(!isActive)   return;
return;

xl=0; yl=10; scale=0.05;

scale=0.25;

//[[NSColor colorWithDeviceRed:214/256.0 green:219/256.0 blue:191/256.0 alpha:1.0] set];	
//NSRectFill(rect);
//[[NSColor greenColor]set];
//NSFrameRect(rect);
//[[NSColor blackColor]set];
//NSRectFill(rect);


if(theData==0)	return;
[[NSColor yellowColor]set];
x=10;

int startPlot=10*2;
int endPlot=startPlot+40*2;

float	diff=(endPlot-startPlot)/2,sum=0;

for(t=startPlot;t<endPlot;t+=(quantize*2))
//for(t=0;t<plots;t+=(quantize*2))
	{
	v=0;
	//for(p=t;p<t+quantize;p++) 
	//	if(theData[p]>v) v=theData[p];
		
	v=theData[t];	
	v1=theData[t];
	v2=theData[t+1];
	v=sqrt(v1*v1+v2*v2);
	sum+=v;
	
	
	 // v+=abs(theData[p]);	
	//v=v/(float)quantize;
	if(peakCount[xd]>0) peakCount[xd]--;
	if(v>peaks[xd] && v>5) 
		{
		peaks[xd]=v; 
		peakCount[xd]=50;
		}
	if(resetPeakCount%40==0) peaks[xd]=0;
	
	if(v>runningAverage)	
		NSRectFill(NSMakeRect(x,yc,xgap,v*scale));
	else
		NSFrameRect(NSMakeRect(x,yc,xgap,v*scale));

	if(peaks[xd]>20)
		{
		//[[NSColor redColor]set];
		[NSBezierPath strokeLineFromPoint:NSMakePoint(x,yc+peaks[xd]*scale) toPoint:NSMakePoint(x+xgap,yc+peaks[xd]*scale)];
		}
	yl=y;
	x+=xgap+1;
	xd++;
	if(x>xsize-10) break;
	}
resetPeakCount++;

if(doRunningAverage)
	{
	long currentTime=AudioGetCurrentHostTime()/(AudioGetHostClockFrequency()/1000.0);
	[timeWindow bang:currentTime value:sum*100];
	[timeWindow doUpdate];

	runningSum=[timeWindow getAverage];;
	runningAverage=runningSum/diff;
	runningAverage=runningAverage/100.0;
	runningAverage=runningAverage*4.0;		
		
	[[NSColor greenColor]set];
	[NSBezierPath strokeLineFromPoint:NSMakePoint(10,yc+runningAverage*scale) toPoint:NSMakePoint(x,yc+runningAverage*scale)];

	}
}
// ******************************************************************************************

@end
