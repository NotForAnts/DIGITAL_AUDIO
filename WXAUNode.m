// ******************************************************************************************
//  WXAUNode
//  Created by Paul Webb on Wed Nov 24 2004.
// ******************************************************************************************

#import "WXAUNode.h"


@implementation WXAUNode


// ******************************************************************************************
-(AUNode)  getNode
{
return  theNode;
}
// ******************************************************************************************
// commented out these as not working and not sure if needed
// ******************************************************************************************
-(void)		setNewNode:(AUGraph)graph cd:(ComponentDescription)cd
{
//AUGraphNewNode(graph,&cd,0,NULL,&theNode);
}
// ******************************************************************************************
-(OSErr)	AUGraphGetNodeInfo:(AUGraph)graph unit:(WXAudioUnit*)unit
{
//return AUGraphGetNodeInfo(graph,theNode,0,0,0,[unit unitPointer]);
return 0;
}
// ******************************************************************************************
-(OSErr)	AUGraphConnectNodeInput:(AUGraph)graph bus1:(UInt32)bus1 destinationNode:(WXAUNode*)dnode bus2:(UInt32)bus2
{
connectNode=dnode;
connectBus=bus2;
return AUGraphConnectNodeInput(graph,theNode,bus1,[dnode getNode],bus2);
}
// ******************************************************************************************
@end
