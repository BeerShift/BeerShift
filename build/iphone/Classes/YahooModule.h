/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */
#ifdef USE_TI_YAHOO

#import "TiModule.h"
#import "KrollCallback.h"

@interface YahooModule : TiModule {
@private
}

@end


@interface YQLCallback : NSObject {
@private
	YahooModule *module;
	KrollCallback *callback;
}

-(id)initWithCallback:(KrollCallback*)callback module:(YahooModule*)module;

@end

#endif