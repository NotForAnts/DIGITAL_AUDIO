// ********************************************************************************************
//  WXDSSalientGestureObject
//  Created by veronica ibarra on 10/10/2006.
// *********************************************************************************************

#import "WXDSSalientGestureObject.h"


@implementation WXDSSalientGestureObject
// *********************************************************************************************

// *********************************************************************************************
-(id)		init
{
if(self=[super init])
	{
	salientFreqArray=[[NSMutableArray alloc]init];
	salientLevelArray=[[NSMutableArray alloc]init];
	}
return self;
}
// *********************************************************************************************
-(void)		dealloc
{
[salientFreqArray release];
[salientLevelArray release];

[super dealloc];
}
// *********************************************************************************************
-(id)		freqArray		{	return salientFreqArray;		}
-(id)		levelArray		{	return salientLevelArray;		}
// *********************************************************************************************
-(void)		setGestureUsing:(NSMutableArray*)freq levels:(NSMutableArray*)levels
{
[salientFreqArray removeAllObjects];
[salientLevelArray removeAllObjects];

[salientFreqArray addObjectsFromArray:freq];
[salientLevelArray addObjectsFromArray:levels];
}
// ************************************************************************************************
-(void)		showSalientGesture
{
int t,size=[salientFreqArray count];
int	freq,level;

printf("SALIENT %d\n", size);
for(t=0;t<size;t++)
	{
	freq=[[salientFreqArray objectAtIndex:t]intValue];
	level=[[salientLevelArray objectAtIndex:t]intValue];
	printf("%d    %d\n",freq,level);
	}
	
printf("--------\n");
}
// *********************************************************************************************


// *********************************************************************************************

@end
