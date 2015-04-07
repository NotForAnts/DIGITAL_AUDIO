// ******************************************************************************************
//  WXDSFilterSeriesConstructerView
//  Created by Paul Webb on Mon Sep 26 2005.
// ******************************************************************************************

#import "WXDSFilterSeriesConstructerView.h"

@implementation WXDSFilterSeriesConstructerView


// ******************************************************************************************
-(id) initWithFrame:(NSRect)frameRect
{
if ((self = [super initWithFrame:frameRect]) != nil) 
	{
	filterSeries=nil;
	maxFiltersAllowed=5;
	yTopUse=frameRect.size.height-16;
	infoY=yTopUse-46-16;
	
	filterFactory=[[WXFactoryDSFilters alloc]init];
	
	filterTypeNames=[[NSMutableArray alloc]init];
	filterTypeTypes=[[NSMutableArray alloc]init];
	seriesRefNames=[[NSMutableArray alloc]init];
	seriesRefTypes=[[NSMutableArray alloc]init];
	madeSeriesRefNames=[[NSMutableArray alloc]init];
	madeSeriesRefTypes=[[NSMutableArray alloc]init];
	
	[self initFilterNames];
	[self addGui];
	[self addFilterAvailableGui];
	
	displayString=[[WXDisplayStrings alloc]init];
	}
return self;
}
// ******************************************************************************************
-(void) drawRect:(NSRect)rect
{
[[NSColor blackColor]set];
[self showFilterSeries];
//NSFrameRect(rect);
}
// ******************************************************************************************
-(WXDSFilterSeries*)	filterSeries
{
return filterSeries;
}
// ******************************************************************************************
-(id)		filterFactory						{   return filterFactory;					}
-(void)		setMaxFiltersAllowed:(int)mfa		{   maxFiltersAllowed=mfa;					}
-(int)		getMadeFilterSize					{   return [madeSeriesRefNames count];		}
// ******************************************************************************************
-(int)		numberParamForFilterAtIndex:(int)index
{
int type,number;
if(index>=[madeSeriesRefNames count])   return 0;
type=[[madeSeriesRefTypes objectAtIndex:index]intValue];
number=[filterFactory numberParamsFortype:type];
return number;
}
// ******************************************************************************************
-(NSString*) filterNameAtIndex:(int)index
{
int type;
if(index>=[madeSeriesRefNames count])   return @"err index";
type=[[madeSeriesRefTypes objectAtIndex:index]intValue];
return [filterFactory filterNameForType:type];
}
// ******************************************************************************************
-(NSString*) paramNameAtIndex:(int)index paramIndex:(int)paramIndex
{
int type;
if(index>=[madeSeriesRefNames count])   return @"err index";
type=[[madeSeriesRefTypes objectAtIndex:index]intValue];
return [filterFactory paramNameForType:type paramIndex:paramIndex];
}
// ******************************************************************************************
-(id)		paramInfoAtIndex:(int)index paramIndex:(int)paramIndex
{
int type;
if(index>=[madeSeriesRefNames count])   return @"err index";
type=[[madeSeriesRefTypes objectAtIndex:index]intValue];
return [filterFactory paramInfoForType:type paramIndex:paramIndex];
}
// ******************************************************************************************
-(void)		showFilterSeries
{
int t,size=[seriesRefNames count],yp;
for(t=0;t<size;t++)
	{
	yp=infoY-16-t*14;
	[displayString formatNumberAt:10 y:yp value:t+1 zero:2 color:[NSColor blackColor]];
	[displayString textAt:30 y:yp text:[seriesRefNames objectAtIndex:t] color:[NSColor blackColor]];
	//[displayString numberAt:80 y:yp value:[[seriesRefTypes objectAtIndex:t]intValue] color:[NSColor blackColor]];
	}
	
if(size>=maxFiltersAllowed)
	[displayString inverseText:10 y:infoY text:@" FULL " color:[NSColor redColor] color2:[NSColor blackColor]];
	
size=[madeSeriesRefNames count];	
for(t=0;t<size;t++)
	{
	yp=infoY-16-t*14;
	[displayString textAt:100 y:yp text:[madeSeriesRefNames objectAtIndex:t] color:[NSColor blackColor]];
	//[displayString numberAt:150 y:yp value:[[madeSeriesRefTypes objectAtIndex:t]intValue] color:[NSColor blackColor]];
	}	
if(size>0)
	[displayString inverseText:100 y:infoY text:@" MADE " color:[NSColor redColor] color2:[NSColor blackColor]];	
	
[displayString textAt:10 y:yTopUse text:@"Filter Series Constructor  " color:[NSColor blackColor]];	
	
}
// ******************************************************************************************
-(void)		initFilterNames
{
[filterFactory copyNamesInto:filterTypeNames];
[filterFactory copyTypesInto:filterTypeTypes];
}
// ******************************************************************************************
-(void) addFilterAvailableGui
{
int t,yp,size=[filterTypeNames count];
filterPopUp=[[NSPopUpButton alloc]initWithFrame:NSMakeRect(70,yTopUse-27-15,96,15)];
[[filterPopUp cell]setControlSize:NSMiniControlSize];

[filterPopUp setFont:[NSFont fontWithName:@"Lucida Grande" size:10]]; 
for(t=0;t<size;t++)
	[filterPopUp addItemWithTitle:[filterTypeNames objectAtIndex:t]];

[self addSubview:filterPopUp];


addButton=[[NSButton alloc]initWithFrame:NSMakeRect(10,yTopUse-30-15,50,19)];
[addButton setButtonType:NSMomentaryPushButton];
[addButton setBezelStyle:NSRoundedBezelStyle]; 
[[addButton cell]setControlSize:NSMiniControlSize];
[addButton setFont:[NSFont fontWithName:@"Lucida Grande" size:10]]; 
[addButton setTitle:@"Add"];
[addButton setTarget:self];
[addButton  setAction:@selector(doAddFilterAction:)];
[self addSubview:addButton];

return;
NSButton	*newButton;
for(t=0;t<size;t++)
	{
	yp=yTopUse-30-t*22;
	newButton=[[NSButton alloc]initWithFrame:NSMakeRect(10,yp,70,18)];
	[newButton setButtonType:NSMomentaryPushButton];
	[newButton setBezelStyle:NSRoundedBezelStyle]; 
	[[newButton cell]setControlSize:NSMiniControlSize];
	[newButton setFont:[NSFont fontWithName:@"Lucida Grande" size:10]]; 	
	[newButton setTitle:[filterTypeNames objectAtIndex:t]];
	[newButton setTag:t];
	[newButton setTarget:self];
	[newButton  setAction:@selector(doAddFilterAction:)];
	[self addSubview:newButton];
	[newButton release];
	}
}
// ******************************************************************************************
-(void) addGui
{
resetButton=[[NSButton alloc]initWithFrame:NSMakeRect(10,yTopUse-24,70,19)];
[resetButton setButtonType:NSMomentaryPushButton];
[resetButton setBezelStyle:NSRoundedBezelStyle]; 
[[resetButton cell]setControlSize:NSMiniControlSize];
[resetButton setFont:[NSFont fontWithName:@"Lucida Grande" size:10]]; 
[resetButton setTitle:@"Reset"];
[resetButton setTarget:self];
[resetButton  setAction:@selector(doResetAction:)];
[self addSubview:resetButton];

makeButton=[[NSButton alloc]initWithFrame:NSMakeRect(95,yTopUse-24,70,19)];
[makeButton setButtonType:NSMomentaryPushButton];
[makeButton setBezelStyle:NSRoundedBezelStyle]; 
[[makeButton cell]setControlSize:NSMiniControlSize];
[makeButton setFont:[NSFont fontWithName:@"Lucida Grande" size:10]]; 
[makeButton setTitle:@"Make"];
[makeButton setTarget:self];
[makeButton  setAction:@selector(doMakeAction:)];
[self addSubview:makeButton];
}
// ******************************************************************************************
//  USER INTERFACING
// ******************************************************************************************
-(IBAction) doResetAction:(id)sender
{
[seriesRefNames removeAllObjects];
[seriesRefTypes removeAllObjects];
[self setNeedsDisplay:true];
}
// ******************************************************************************************
-(IBAction) doMakeAction:(id)sender
{
if(filterSeries!=nil)   [filterSeries release];
filterSeries=[filterFactory createFilterSeries:seriesRefTypes];

printf("series made size = %d\n",[filterSeries seriesSize]);
int t;

[madeSeriesRefNames removeAllObjects];
[madeSeriesRefTypes removeAllObjects];
for(t=0;t<[seriesRefTypes count];t++)
	{
	[madeSeriesRefNames addObject:[NSString stringWithString:[seriesRefNames objectAtIndex:t]]];
	[madeSeriesRefTypes addObject:[NSNumber numberWithInt:[[seriesRefTypes objectAtIndex:t]intValue]]];
	}
	
id superView=[self superview];
if(superView!=nil)
	[superView filterSeriesMade];

[self setNeedsDisplay:true];	
}
// ******************************************************************************************
-(IBAction) doAddFilterAction:(id)sender
{
if([seriesRefNames count]>=maxFiltersAllowed)   return;

int type=[filterPopUp indexOfSelectedItem];
[self addFilterAtIndex:type];
}
// ******************************************************************************************
-(void)		addFilterAtIndex:(int)type
{
[seriesRefNames addObject:[NSString stringWithString:[filterTypeNames objectAtIndex:type]]];
[seriesRefTypes addObject:[NSNumber numberWithInt:[[filterTypeTypes objectAtIndex:type]intValue]]];
[self setNeedsDisplay:true];
}
// ******************************************************************************************

@end
