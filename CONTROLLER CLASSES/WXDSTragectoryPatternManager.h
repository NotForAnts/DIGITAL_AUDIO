// ***************************************************************************************
//  WXDSTragectoryPatternManager
//  Created by Paul Webb on Tue Sep 20 2005.
// ***************************************************************************************
//  With morpholgies of the sound it is good to have patterns repeat themselves
//  and perhaps be varied slightly in time. This is what this class is for.
// ***************************************************************************************
//  THIS CAN STORE COPIES OF WXDSTragectoryManager ( sets of tragectories)
//  THEN PUT THEM INTO A WXDSTragectoryManager
//
//
// ***************************************************************************************

#import <Foundation/Foundation.h>
#import "WXDSTragectoryManager.h"
#import "WXDSTragectoryObject.h"

// ***************************************************************************************

@interface WXDSTragectoryPatternManager : NSObject {

int storeSize;
NSMutableArray  *tragectoryStore;
}

-(int)  count;
-(void) makeNewStore;
-(void) makeRealTimeCopyScale:(int)patt index:(int)index dest:(WXDSTragectoryManager*)dest scale:(float)scale;
-(void) makeRealTimeCopy:(int)patt index:(int)index dest:(WXDSTragectoryManager*)dest;
-(void) addToLast:(WXDSTragectoryManager*)source;
-(void) copySource;


@end
