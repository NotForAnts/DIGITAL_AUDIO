// ************************************************************************************************
//  WXGrainFilterEnvelope.h
//  Created by Paul Webb on Tue Jan 04 2005.
// ************************************************************************************************
//  this filter grain fades out the filter ring with linear decay envelope in X samples 
//  which starts when grain envelope has reaches zero. The fade out operates on the gain
//
//
// ************************************************************************************************
#import <Foundation/Foundation.h>
#import "WXDSGrain.h"
#import "WXFilterBase.h"
// ***************************************************************************************
@interface WXGrainFilterEnvelope : WXDSGrain {

int				filterDecayTime;
WXFilterBase*   theFilter;
float			filterGainDelta;
}

-(id)				initWithFilter:(WXFilterBase*)filterObject filterTime:(int)filterTime;
-(void)				setFilterAs:(WXFilterBase*)filterObject;
-(void)				setFilterTime:(int)filterTime;
-(WXFilterBase*)	getFilter;

@end
