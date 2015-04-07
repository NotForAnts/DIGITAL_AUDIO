// ***************************************************************************************
//  WXDSInputGrain
//  Created by Paul Webb on Tue Jan 11 2005.
// ***************************************************************************************


#import <Foundation/Foundation.h>
#import "WXDSGrain.h"
// ***************************************************************************************

@interface WXDSInputGrain : WXDSGrain {

float  *bufferInputLeft;
float  *bufferInputRight;
float   *useBuffer;
float   playPosition;
float   bufferSize,halfSize,startPos1,startPos2;
int		bufferPosition;
}

-(void)		setInputBuffers:(float*)b1 right:(float*)b2 size:(int)size;
-(void)		setBufferPosition:(int)pos channel:(short)channel;
-(void)		setPositions:(int)pos1 pos2:(int)pos2;

@end
