// ******************************************************************************************
//  WXSPKitBWBandPassFilter.h
//  Created by Paul Webb on Mon Jan 10 2005.
// ******************************************************************************************

#import "WXSPKitBWBandPassFilter.h"

@implementation WXSPKitBWBandPassFilter
// ******************************************************************************************
-(id)		init
{
if(self=[super init])
	{
	[self setCenterFreqAndBW:400 width:400];
	}
return self;
}
// ***************************************************************************************
-(void)		doController:(int)index value:(float)value
{
switch(index)
	{
	case 1:		[self setCenterFreq:value];		break;
	case 2:		[self setBandWidth:value];		break;
	}
}
// ******************************************************************************************
-(void) setCenterFreqNSO:(id)f		{   [self setCenterFreq:[f floatValue]];	}
-(void) setBandWidthNSO:(id)bw		{   [self setBandWidth:[bw floatValue]];	}
// ******************************************************************************************
-(void) setBandWidth:(float)bw 
{
[self setCenterFreqAndBW:centerFreq width:bw];
}
// ******************************************************************************************
-(void) setCenterFreq:(float)f 
{
[self setCenterFreqAndBW:f width:bandwidth];
}
// ******************************************************************************************
-(void) setCenterFreqAndBW:(float)f width:(float)bw
{
    centerFreq = f;
    bandwidth = bw;
    
    C = 1.0 / tan(M_PI * bandwidth / 44100.0);
    D = 2 * cos(2 * M_PI * centerFreq / 44100.0);

    a0 = 1.0 / (1.0 + C);
    a1 = 0.0;
    a2 = -a0;

    b1 = -C * D * a0;
    b2 = (C - 1.0) * a0;
}
// ******************************************************************************************


@end
