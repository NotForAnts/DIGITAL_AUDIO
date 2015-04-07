// ******************************************************************************************
//  WXAudioUnit
//  Created by Paul Webb on Wed Nov 24 2004.
//
//  Wrapper for AudioUnit - will be done later 
//
// ******************************************************************************************
#import		<Foundation/Foundation.h>
#import		"AudioToolBox/AUGraph.h"
// ******************************************************************************************
@interface WXAudioUnit : NSObject {

AudioUnit   unit;
}


-(AudioUnit)	unit;
-(AudioUnit*)   unitPointer;

-(OSErr)		AudioUnitSetProperty:(AudioUnitPropertyID)inID scope:(AudioUnitScope)scope element:(AudioUnitElement)element data:(void*)data size:(UInt32)size;
-(OSErr)		AudioUnitSetParameter:(AudioUnitPropertyID)inID scope:(AudioUnitScope)scope element:(AudioUnitElement)element value:(float)value inFrames:(UInt32)inFrames;
// ******************************************************************************************
@end
