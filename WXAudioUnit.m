// ******************************************************************************************
//  WXAudioUnit
//  Created by Paul Webb on Wed Nov 24 2004.
// ******************************************************************************************

#import "WXAudioUnit.h"


@implementation WXAudioUnit


// ******************************************************************************************
-(AudioUnit) unit
{
return unit;
}
// ******************************************************************************************
-(AudioUnit*)   unitPointer
{
return &unit;
}
// ******************************************************************************************
-(OSErr)		AudioUnitSetProperty:(AudioUnitPropertyID)inID scope:(AudioUnitScope)scope element:(AudioUnitElement)element data:(void*)data size:(UInt32)size
{
return AudioUnitSetProperty(unit,inID,scope,element,data,size);
}
// ******************************************************************************************
-(OSErr)		AudioUnitSetParameter:(AudioUnitPropertyID)inID scope:(AudioUnitScope)scope element:(AudioUnitElement)element value:(float)value inFrames:(UInt32)inFrames
{
return AudioUnitSetParameter(unit,inID,scope,element,value,inFrames);
}
// ******************************************************************************************
@end
