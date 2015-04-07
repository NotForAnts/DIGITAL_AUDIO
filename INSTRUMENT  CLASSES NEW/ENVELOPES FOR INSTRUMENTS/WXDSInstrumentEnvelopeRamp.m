// ************************************************************************************************
//  WXDSInstrumentEnvelopeRamp
//  Created by Paul Webb on Mon Aug 15 2005.
// ************************************************************************************************
#import "WXDSInstrumentEnvelopeRamp.h"


@implementation WXDSInstrumentEnvelopeRamp


// ************************************************************************************************
-(void)		keyOnWithGain:(float)g
{
gain=g;
state=1;
value=0.0;
}
// ************************************************************************************************
-(void)		setTarget:(float)v
{
attackLevel=v;
}
// ************************************************************************************************
-(void)		setRate:(float)v
{
attackDelta=v;
}
// ************************************************************************************************
-(float)   tick
{
switch(state)
	{
	case 0: return 0; break;		// DONE or NOT STARTED
	
	case 1:
		value+=attackDelta;
		if(value>=attackLevel)  
			{
			state=0;
			value=attackLevel;
			}
		break;
	}
		
return value;
}
// ************************************************************************************************


@end
