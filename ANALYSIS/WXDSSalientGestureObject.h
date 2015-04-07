// ********************************************************************************************
//  WXDSSalientGestureObject
//  Created by veronica ibarra on 10/10/2006.
// *********************************************************************************************

#import <Cocoa/Cocoa.h>
#import "WXUsefullCode.h"
// *********************************************************************************************

@interface WXDSSalientGestureObject : NSObject {


NSMutableArray				*salientFreqArray;
NSMutableArray				*salientLevelArray;

}

-(id)		init;
-(void)		setGestureUsing:(NSMutableArray*)freq levels:(NSMutableArray*)levels;

-(id)		freqArray;
-(id)		levelArray;
-(void)		showSalientGesture;

// *********************************************************************************************

@end
