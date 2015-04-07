// ******************************************************************************************
//  WXSPKBWLowPassFilter
//  Created by Paul Webb on Mon Jan 10 2005.
// ******************************************************************************************
#import "WXSPKBWLowPassFilter.h"


@implementation WXSPKBWLowPassFilter

// ******************************************************************************************
-(id)		init
{
if(self=[super init])
	{
	[self setCutOffFreq:400];
	}
return self;
}
// ***************************************************************************************
-(void)		doController:(int)index value:(float)value
{
[self setCutOffFreq:value]; 
}
// ******************************************************************************************
-(void)		setCutOffFreqNSO:(id)freq
{
[self setCutOffFreq:[freq floatValue]];
}
// ******************************************************************************************
-(void)		setCutOffFreq:(float)freq
{
if(freq==0) return;
cutOffFreq = freq;

C = 1.0 / tan(3.14159265358979323846 * cutOffFreq / 44100.0);

a0 = 1.0 / (1.0 + sqrt(2.0) * C + C * C);
a1 = 2.0 * a0;
a2 = a0;

b1 = 2 * (1.0 - C * C) * a0;
b2 = (1.0 - sqrt(2.0) * C + C * C) * a0;
}
// ******************************************************************************************


@end
