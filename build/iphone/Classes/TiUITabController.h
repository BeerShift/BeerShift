/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */
#ifdef USE_TI_UITAB

#import "TiWindowProxy.h"
#import "TiUITabProxy.h"
#import "TiTabController.h"

@interface TiUITabController : TiViewController<TiTabController> {
@private
//Window is now the superclass's proxy.
	TiUITabProxy *tab;
}

-(id)initWithProxy:(TiWindowProxy*)proxy tab:(TiUITabProxy*)tab;
@property(nonatomic,readonly)	TiWindowProxy *window;
@property(nonatomic,readonly)	TiUITabProxy *tab;

@end

#endif