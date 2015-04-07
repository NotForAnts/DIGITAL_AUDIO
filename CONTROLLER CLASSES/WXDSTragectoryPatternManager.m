// ***************************************************************************************
//  WXDSTragectoryPatternManager
//  Created by Paul Webb on Tue Sep 20 2005.
// ***************************************************************************************
#import "WXDSTragectoryPatternManager.h"


// ***************************************************************************************
@implementation WXDSTragectoryPatternManager


// ***************************************************************************************
-(id)   init
{
if(self=[super init])
	{
	tragectoryStore=[[NSMutableArray alloc]init];
	}
return self;
}
// ***************************************************************************************
-(void) dealloc
{

}
// ***************************************************************************************
-(int)  count
{
return [tragectoryStore count];
}
// ***************************************************************************************
-(void) makeNewStore
{
NSMutableArray  *tragSet=[[NSMutableArray alloc]init];

[tragectoryStore addObject:tragSet];
[tragSet release];
}
// ***************************************************************************************
-(void) makeRealTimeCopyScale:(int)patt index:(int)index dest:(WXDSTragectoryManager*)dest scale:(float)scale
{
WXDSTragectoryManager   *source=[[tragectoryStore objectAtIndex:patt] objectAtIndex:index];
[dest removeAllObjects];
[source makeCopyInto:dest];
[dest setTimeScale:scale];
[dest setStartTimePointInterval:[NSDate timeIntervalSinceReferenceDate]];
}
// ***************************************************************************************
-(void) makeRealTimeCopy:(int)patt index:(int)index dest:(WXDSTragectoryManager*)dest
{
WXDSTragectoryManager   *source=[[tragectoryStore objectAtIndex:patt] objectAtIndex:index];
[dest removeAllObjects];
[source makeCopyInto:dest];
[dest setStartTimePointInterval:[NSDate timeIntervalSinceReferenceDate]];
}
// ***************************************************************************************
// this will add all the objects in the trag to the destination
// ***************************************************************************************
-(void) addToLast:(WXDSTragectoryManager*)source
{
WXDSTragectoryManager   *sourceCopy=[[WXDSTragectoryManager alloc]init];
[source makeCopyInto:sourceCopy];
[[tragectoryStore lastObject] addObject:sourceCopy];
}
// ***************************************************************************************

@end
