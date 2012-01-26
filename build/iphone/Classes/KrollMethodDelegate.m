/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */

#import "KrollMethodDelegate.h"


@implementation KrollMethodDelegate

-(id)initWithTarget:(id)target_ selector:(SEL)selector_ args:(BOOL)args_
{
	if (self = [super init])
	{
		target = [target_ retain];
		selector = selector_;
		args = args_;
	}
	return self;
}

-(void)dealloc
{
	[target release];
	[super dealloc];
}

-(id)target
{
	return target;
}

-(SEL)selector
{
	return selector;
}

-(BOOL)args
{
	return args;
}


@end
