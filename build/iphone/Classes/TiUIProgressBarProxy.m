/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */
#ifdef USE_TI_UIPROGRESSBAR

#import "TiUIProgressBarProxy.h"
#import "TiUIProgressBar.h"
#import "TiUtils.h"

@implementation TiUIProgressBarProxy

USE_VIEW_FOR_AUTO_WIDTH
USE_VIEW_FOR_AUTO_HEIGHT

-(TiUIView*)newView
{
	id styleObj = [self valueForKey:@"style"];
	UIProgressViewStyle style = styleObj == nil ? UIProgressViewStyleDefault : [TiUtils intValue:styleObj];
	return [[TiUIProgressBar alloc] initWithStyle:style];
}

@end

#endif