// ***************************************************************************************
//  WXDSFilterGrain
//  Created by Paul Webb on Mon Jan 03 2005.
// ***************************************************************************************
//  Granular Grain with individual filter.
//
//  The filter grain rings the filter for X samples more before stopping the grain
//  -set this with setFilterTime or in constructor
//
//  if wish to change filter settings can use [getFilter]
//  filter get defined externally then added
//
// ***************************************************************************************
#import <Foundation/Foundation.h>
#import "WXDSGrain.h"
#import "WXFilterBase.h"
// ***************************************************************************************
@interface WXDSFilterGrain : WXDSGrain {

int				filterDecayTime;
WXFilterBase*   theFilter;
}

-(id)				initWithFilter:(WXFilterBase*)filterObject filterTime:(int)filterTime;
-(void)				setFilterAs:(WXFilterBase*)filterObject;
-(void)				setFilterTime:(int)filterTime;
-(WXFilterBase*)	getFilter;

@end
