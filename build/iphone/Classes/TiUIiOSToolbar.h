/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */

#if defined(USE_TI_UIIOSTOOLBAR) || defined(USE_TI_UITOOLBAR)
#import "TiUIView.h"


@interface TiUIiOSToolbar : TiUIView<LayoutAutosizing> {
	UIToolbar * toolBar;
	BOOL hideTopBorder;
	BOOL showBottomBorder;
}

-(UIToolbar *)toolBar;

@end

#endif