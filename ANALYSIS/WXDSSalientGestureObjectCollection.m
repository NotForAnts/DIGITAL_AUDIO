// *********************************************************************************************
//  WXDSSalientGestureObjectCollection
//  Created by veronica ibarra on 10/10/2006.
// *********************************************************************************************

#import "WXDSSalientGestureObjectCollection.h"


@implementation WXDSSalientGestureObjectCollection
// *********************************************************************************************


// *********************************************************************************************
-(id)		init
{
if(self=[super init])
	{
	theGestures=[[NSMutableArray alloc]init];
	}
return self;
}
// *********************************************************************************************
-(void)		dealloc
{
[theGestures release];
[super dealloc];
}
// *********************************************************************************************
-(id)		lastGesture
{
return [theGestures lastObject];
}
// *********************************************************************************************
-(void)		addGestureUsing:(NSMutableArray*)freq levels:(NSMutableArray*)levels
{
WXDSSalientGestureObject		*newGesture=[[WXDSSalientGestureObject alloc]init];

[newGesture setGestureUsing:freq levels:levels];
[theGestures addObject:newGesture];

[newGesture release];
}
// *********************************************************************************************

@end
