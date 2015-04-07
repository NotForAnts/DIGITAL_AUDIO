// ***************************************************************************************
//  WXDSFilterSeries
//  Created by Paul Webb on Thu Dec 30 2004.
// ***************************************************************************************
//
//  this creates a series (or chain) of filters which can be added externally to create a
//
//  input--->F1-->F2-->F3-->output
//  from a [filterSeries filter]
//
// ***************************************************************************************
#import <Foundation/Foundation.h>



@interface WXDSFilterSeries : NSObject {

NSMutableArray*		filterSeries;
}

-(void)		setParamControls:(int)index control:(id)control;
-(void)		addObject:(id)filter;
-(void)		removeAllObjects;
-(float)	filter:(float)input;
-(void)		filterChunk:(float*)ioData frame:(UInt32)inNumFrames;
-(id)		filterAtIndex:(int)index;
-(int)		seriesSize;

@end
