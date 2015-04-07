// ******************************************************************************************
//  WXDSInstrumentReedTable
//  Created by Paul Webb on Thu Aug 18 2005.
// ******************************************************************************************

#import "WXDSInstrumentReedTable.h"

// ******************************************************************************************

@implementation WXDSInstrumentReedTable

// ******************************************************************************************

-(id)   initReedTable
{
if(self=[super init])
	{
	offSet = (float) 0.6;  // Offset is a bias, related to reed rest position.
	slope = (float) -0.8;  // Slope corresponds loosely to reed stiffness.
	}
return self;
}
// ******************************************************************************************
-(void) setOffset:(float)aValue
{
offSet = aValue;
}
// ******************************************************************************************
-(void) setSlope:(float)aValue
{
slope = aValue;
}
// ******************************************************************************************
-(float) lastOut
{
return lastOutput;
}
// ******************************************************************************************
-(float) tick:(float)input    
{
// The input is differential pressure across the reed.
lastOutput = offSet + (slope * input);

// If output is > 1, the reed has slammed shut and the
// reflection function value saturates at 1.0.
if (lastOutput > 1.0) lastOutput = (float) 1.0;

// This is nearly impossible in a physical system, but
// a reflection function value of -1.0 corresponds to
// an open end (and no discontinuity in bore profile).
if (lastOutput < -1.0) lastOutput = (float) -1.0;
return lastOutput;
}
// ******************************************************************************************


@end
