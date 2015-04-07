// ******************************************************************************************
//  WXDSInstrumentJetTable
//  Created by Paul Webb on Thu Aug 18 2005.
// ******************************************************************************************

#import "WXDSInstrumentJetTable.h"


@implementation WXDSInstrumentJetTable

// ******************************************************************************************
-(id)   init
{
if(self=[super init])
	{
	lastOutput = (float) 0.0;
	}
return self;
}
// ******************************************************************************************
-(float) lastOut
{
return lastOutput;
}
// ******************************************************************************************

-(float) tick:(float)input
{
// Perform "table lookup" using a polynomial
// calculation (x^3 - x), which approximates
// the jet sigmoid behavior.
lastOutput = input * (input * input - (float)  1.0);

// Saturate at +/- 1.0.
if (lastOutput > 1.0) 
lastOutput = (float) 1.0;
if (lastOutput < -1.0)
lastOutput = (float) -1.0; 
return lastOutput;
}
// ******************************************************************************************



@end
