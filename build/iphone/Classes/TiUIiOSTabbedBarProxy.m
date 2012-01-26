/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */
#if defined(USE_TI_UIIOSTABBEDBAR) || defined(USE_TI_UITABBEDBAR)
#import "TiUIiOSTabbedBarProxy.h"
#import "TiUIButtonBar.h"

@implementation TiUIiOSTabbedBarProxy

NSArray* tabbedKeySequence;

-(NSArray*)keySequence
{
	if (tabbedKeySequence == nil) {
		tabbedKeySequence = [[NSArray alloc] initWithObjects:@"labels",@"style",nil];
	}
	return tabbedKeySequence;
}

-(TiUIView*)newView
{
	TiUIButtonBar * result = [[TiUIButtonBar alloc] init];
	[result setTabbedBar:YES];
	return result;
}

USE_VIEW_FOR_AUTO_WIDTH
USE_VIEW_FOR_AUTO_HEIGHT

@end
#endif