// ******************************************************************************************
//  WXAUNode
//  Created by Paul Webb on Wed Nov 24 2004.
//
//  Wrapper for AUNode - will be done later 
//
// ******************************************************************************************
#import <Foundation/Foundation.h>
#import "AudioToolBox/AUGraph.h"
#import "WXAudioUnit.h"
// ******************************************************************************************

@interface WXAUNode : NSObject {

AUNode		theNode;

WXAUNode*   connectNode;
UInt32		connectBus;
}

-(AUNode)	getNode;
-(void)		setNewNode:(AUGraph)graph cd:(ComponentDescription)cd;
-(OSErr)	AUGraphGetNodeInfo:(AUGraph)graph unit:(WXAudioUnit*)unit;
-(OSErr)	AUGraphConnectNodeInput:(AUGraph)graph bus1:(UInt32)bus1 destinationNode:(WXAUNode*)dnode bus2:(UInt32)bus2;

// ******************************************************************************************

@end
