/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */

#import <Foundation/Foundation.h>
#import "Bridge.h"
#import "Ti.h"
#import "TiEvaluator.h"
#import "TiProxy.h"
#import "KrollContext.h"
#import "KrollObject.h"
#import "TiModule.h"
#include <libkern/OSAtomic.h>

#ifdef KROLL_COVERAGE
# import "KrollCoverage.h"
@interface BeerShiftObject : KrollCoverageObject {
#else
@interface BeerShiftObject : KrollObject {
#endif
@private
	NSMutableDictionary *modules;
	TiHost *host;
	id<TiEvaluator> pageContext;
	NSMutableDictionary *dynprops;
}

-(id)initWithContext:(KrollContext*)context_ host:(TiHost*)host_ context:(id<TiEvaluator>)context baseURL:(NSURL*)baseURL_;
-(KrollObject*)addModule:(NSString*)name module:(TiModule*)module;
-(TiModule*)moduleNamed:(NSString*)name context:(id<TiEvaluator>)context;
@end

extern NSString * BeerShift$ModuleRequireFormat;

@interface KrollBridge : Bridge<TiEvaluator,KrollDelegate> {
@private
	NSURL * currentURL;

	KrollContext *context;
	NSDictionary *preload;
	NSMutableDictionary *modules;
	BeerShiftObject *_beershift;
	BOOL shutdown;
    BOOL evaluationError;
	//NOTE: Do NOT treat registeredProxies like a mutableDictionary; mutable dictionaries copy keys,
	//CFMutableDictionaryRefs only retain keys, which lets them work with proxies properly.
	CFMutableDictionaryRef registeredProxies;
	NSCondition *shutdownCondition;
	OSSpinLock proxyLock;
}
- (void)boot:(id)callback url:(NSURL*)url_ preload:(NSDictionary*)preload_;
- (void)evalJSWithoutResult:(NSString*)code;
- (id)evalJSAndWait:(NSString*)code;
- (BOOL)evaluationError;
- (void)fireEvent:(id)listener withObject:(id)obj remove:(BOOL)yn thisObject:(TiProxy*)thisObject;
- (id)preloadForKey:(id)key name:(id)name;
- (KrollContext*)krollContext;

+ (NSArray *)krollBridgesUsingProxy:(id)proxy;
+ (BOOL)krollBridgeExists:(KrollBridge *)bridge;
+ (KrollBridge *)krollBridgeForThreadName:(NSString *)threadName;

-(void)enqueueEvent:(NSString*)type forProxy:(TiProxy *)proxy withObject:(id)obj withSource:(id)source;
-(void)registerProxy:(id)proxy krollObject:(KrollObject *)ourKrollObject;
-(int)forceGarbageCollectNow;

@end

