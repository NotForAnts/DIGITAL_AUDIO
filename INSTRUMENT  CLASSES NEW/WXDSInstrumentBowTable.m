// ***************************************************************************************
//  WXDSInstrumentBowTable
//  Created by Paul Webb on Mon Aug 15 2005.
// ***************************************************************************************
#import "WXDSInstrumentBowTable.h"


@implementation WXDSInstrumentBowTable
// ***************************************************************************************
-(id)   init
{
if(self=[super init])
	{
	offSet = (float) 0.0;
	slope = (float) 0.1;
	}
return self;
}
// ***************************************************************************************
-(void) setOffset:(float)aValue
{
offSet = aValue;
}
// ***************************************************************************************
-(void) setSlope:(float)aValue
{
slope = aValue;
}
// ***************************************************************************************
-(float) lastOut
{
return lastOutput;
}
// ***************************************************************************************
-(float) tick:(float)input
{
// The input represents differential string vs. bow velocity.
float sample;
sample = input + offSet;  // add bias to input
sample *= slope;          // then scale it
lastOutput = (float)  fabs((double) sample) + (float) 0.75;
lastOutput = (float)  pow( lastOutput,(float) -4.0 );

// Set minimum friction to 0.0
//if (lastOutput < 0.0 ) lastOutput = 0.0;
// Set maximum friction to 1.0.
if (lastOutput > 1.0 ) lastOutput = (float) 1.0;

return lastOutput;
}
// ***************************************************************************************
/*
float *BowTabl :: tickChuck(float *vector, unsigned int vectorSize)
{
  for (unsigned int i=0; i<vectorSize; i++)
    vector[i] = tick(vector[i]);

  return vector;
}
*/
// ***************************************************************************************

@end
