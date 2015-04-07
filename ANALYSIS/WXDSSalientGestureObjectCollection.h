// *********************************************************************************************
//  WXDSSalientGestureObjectCollection
//  Created by veronica ibarra on 10/10/2006.
// *********************************************************************************************


#import <Cocoa/Cocoa.h>
#import "WXDSSalientGestureObject.h"


// *********************************************************************************************

@interface WXDSSalientGestureObjectCollection : NSObject {

NSMutableArray		*theGestures;

}

-(void)		addGestureUsing:(NSMutableArray*)freq levels:(NSMutableArray*)levels;
-(id)		lastGesture;

// *********************************************************************************************

@end
