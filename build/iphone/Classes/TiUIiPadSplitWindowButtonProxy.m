/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */
#import "TiBase.h"

#ifdef USE_TI_UIIPADSPLITWINDOW

#import "TiUIiPadSplitWindowButtonProxy.h"
#import "TiUtils.h"

@implementation TiUIiPadSplitWindowButtonProxy

-(id)initWithButton:(UIBarButtonItem*)button_ pageContext:(id<TiEvaluator>)pageContext_
{
	if (self = [super _initWithPageContext:pageContext_])
	{
		button = [button_ retain];
	}
	return self;
}

-(void)_destroy
{
	RELEASE_TO_NIL(button);
	[super _destroy];
}

-(void)setTitle:(id)title
{
	[button setTitle:title];
}

- (UIBarButtonItem *) barButtonItem
{
	return button;
}

-(BOOL)supportsNavBarPositioning
{
	return YES;
}

-(BOOL)isUsingBarButtonItem
{
	return YES;
}

@end

#endif
