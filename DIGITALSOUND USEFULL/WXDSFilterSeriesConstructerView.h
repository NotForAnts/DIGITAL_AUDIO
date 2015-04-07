// ******************************************************************************************
//  WXDSFilterSeriesConstructerView
//  Created by Paul Webb on Mon Sep 26 2005.
// ******************************************************************************************
//
//  A view (gui) used to construct and edit filter series
//  and set default parameters for them
//
// ******************************************************************************************

#import <Cocoa/Cocoa.h>

#import "WXDSFilterSeries.h"
#import "WXDisplayStrings.h"
#import "WXFactoryDSFilters.h"
// ******************************************************************************************

@interface WXDSFilterSeriesConstructerView : NSView
{

float   yTopUse,infoY;
int		maxFiltersAllowed;

WXFactoryDSFilters  *filterFactory;
NSButton			*makeButton;
NSButton			*resetButton;
NSButton			*addButton;
NSPopUpButton		*filterPopUp;

NSMutableArray  *filterTypeNames;
NSMutableArray  *filterTypeTypes;
NSMutableArray  *seriesRefNames;
NSMutableArray  *seriesRefTypes;

NSMutableArray  *madeSeriesRefNames;
NSMutableArray  *madeSeriesRefTypes;

WXDisplayStrings	*displayString;
WXDSFilterSeries	*filterSeries;
}

-(void) addGui;
-(void) setMaxFiltersAllowed:(int)mfa;
-(void) initFilterNames;
-(void) addFilterAvailableGui;
-(int)  getMadeFilterSize;
-(int)  numberParamForFilterAtIndex:(int)index;
-(NSString*) filterNameAtIndex:(int)index;
-(NSString*) paramNameAtIndex:(int)index paramIndex:(int)paramIndex;
-(id)		paramInfoAtIndex:(int)index paramIndex:(int)paramIndex;

-(IBAction) doResetAction:(id)sender;
-(IBAction) doMakeAction:(id)sender;
-(IBAction) doAddFilterAction:(id)sender;
-(void)		addFilterAtIndex:(int)type;
-(WXDSFilterSeries*)	filterSeries;
-(id)   filterFactory;
// ******************************************************************************************

@end
