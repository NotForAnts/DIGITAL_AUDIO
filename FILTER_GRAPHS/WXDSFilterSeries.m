// ***************************************************************************************
//  WXDSFilterSeries
//  Created by Paul Webb on Thu Dec 30 2004.
// ***************************************************************************************
#import "WXDSFilterSeries.h"


@implementation WXDSFilterSeries
// ***************************************************************************************
-(id)		init
{
if(self=[super init])
	{
	filterSeries=[[NSMutableArray alloc]init];
	}
return self;
}
// ***************************************************************************************
-(void)		dealloc
{
[filterSeries release];
[super dealloc];
}
// ***************************************************************************************
-(int)		seriesSize
{
return [filterSeries count];
}
// ***************************************************************************************
-(void)		setParamControls:(int)index control:(id)control
{
[[filterSeries  objectAtIndex:index]setParamControls:control];
}
// ***************************************************************************************
-(void)		addObject:(id)filter
{
[filterSeries addObject:filter];
}
// ***************************************************************************************
-(id)		filterAtIndex:(int)index
{
return [filterSeries objectAtIndex:index];
}
// ***************************************************************************************
-(void)		removeAllObjects
{
[filterSeries removeAllObjects];
}
// ***************************************************************************************
-(void)		filterChunk:(float*)ioData frame:(UInt32)inNumFrames
{
int t,size=[filterSeries count];
for(t=0;t<size;t++)
	[[filterSeries objectAtIndex:t]filterChunk:ioData frame:inNumFrames];

}
// ***************************************************************************************
-(float)	filter:(float)input
{
int t,size=[filterSeries count];
for(t=0;t<size;t++)
	input=[[filterSeries objectAtIndex:t]filter:input];

return input;
}
// ***************************************************************************************

@end
