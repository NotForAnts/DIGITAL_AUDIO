// ***************************************************************************************
//  WXFilterBase
//  Created by Paul Webb on Mon Jan 03 2005.
//
//  BASE CLASS FOR FILTER
//
// ***************************************************************************************
#import <Foundation/Foundation.h>
// ***************************************************************************************
@interface WXFilterBase : NSObject {

id   paramControls;
}

-(void)		doController:(int)index value:(float)value;
-(void)		filterChunk:(float*)ioData frame:(UInt32)inNumFrames;
-(float)	filter:(float)sample;
-(void)		clear;
-(void)		setParamControls:(id)pC;

@end
