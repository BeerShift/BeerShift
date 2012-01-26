/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */
#import "TiBase.h"
#import "KrollBridge.h"
#import "KrollCallback.h"
#import "KrollObject.h"
#import "TiHost.h"
#import "TopTiModule.h"
#import "TiUtils.h"
#import "TiApp.h"
#import "ApplicationMods.h"
#import <libkern/OSAtomic.h>
#import "KrollContext.h"
#import "TiDebugger.h"

#ifdef KROLL_COVERAGE
# include "KrollCoverage.h"
#endif

extern BOOL const TI_APPLICATION_ANALYTICS;

NSString * BeerShift$ModuleRequireFormat = @"(function(exports){"
		"var __OXP=exports;var module={'exports':exports};%@;\n"
		"if(module.exports !== __OXP){return module.exports;}"
		"return exports;})({})";


@implementation BeerShiftObject

-(NSDictionary*)modules
{
	return modules;
}

-(id)initWithContext:(KrollContext*)context_ host:(TiHost*)host_ context:(id<TiEvaluator>)pageContext_ baseURL:(NSURL*)baseURL_
{
	TopTiModule *module = [[[TopTiModule alloc] _initWithPageContext:pageContext_] autorelease];
	[module setHost:host_];
	[module _setBaseURL:baseURL_];
	
	pageContext = pageContext_;
	
	if (self = [super initWithTarget:module context:context_])
	{
		modules = [[NSMutableDictionary alloc] init];
		host = [host_ retain];
		[(KrollBridge *)pageContext_ registerProxy:module krollObject:self];
		
		// pre-cache a few modules we always use
		TiModule *ui = [host moduleNamed:@"UI" context:pageContext_];
		[self addModule:@"UI" module:ui];
		TiModule *api = [host moduleNamed:@"API" context:pageContext_];
		[self addModule:@"API" module:api];
		
		if (TI_APPLICATION_ANALYTICS)
		{
			// force analytics to load on startup
			[host moduleNamed:@"Analytics" context:pageContext_];
		}
	}
	return self;
}

#if KROLLBRIDGE_MEMORY_DEBUG==1
-(id)retain
{
	NSLog(@"RETAIN: %@ (%d)",self,[self retainCount]+1);
	return [super retain];
}
-(oneway void)release 
{
	NSLog(@"RELEASE: %@ (%d)",self,[self retainCount]-1);
	[super release];
}
#endif

-(void)dealloc
{
	RELEASE_TO_NIL(host);
	RELEASE_TO_NIL(modules);
	RELEASE_TO_NIL(dynprops);
	[super dealloc];
}

-(void)gc
{
}

-(id)valueForKey:(NSString *)key
{
	// allow dynprops to override built-in modules
	// in case you want to re-define them
	if (dynprops!=nil)
	{
		id result = [dynprops objectForKey:key];
		if (result!=nil)
		{
			if (result == [NSNull null])
			{
				return nil;
			}
			return result;
		}
	}
	id module = [modules objectForKey:key];
	if (module!=nil)
	{
		return module;
	}
	module = [host moduleNamed:key context:pageContext];
	if (module!=nil)
	{
		return [self addModule:key module:module];
	}
	//go against module
	return [super valueForKey:key];
}

-(void)setValue:(id)value forKey:(NSString *)key
{
	if (dynprops==nil)
	{
		dynprops = [[NSMutableDictionary dictionary] retain];
	}
	if (value == nil)
	{
		value = [NSNull null];
	}
	[dynprops setValue:value forKey:key];
}

- (id) valueForUndefinedKey: (NSString *) key
{
	if ([key isEqualToString:@"toString"] || [key isEqualToString:@"valueOf"])
	{
		return [self description];
	}
	if (dynprops != nil)
	{
		return [dynprops objectForKey:key];
	}
	//NOTE: we need to return nil here since in JS you can ask for properties
	//that don't exist and it should return undefined, not an exception
	return nil;
}

-(KrollObject*)addModule:(NSString*)name module:(TiModule*)module
{
	KrollObject *ko = [pageContext registerProxy:module];
	if (ko == nil)
	{
		return nil;
	}
	[self noteKrollObject:ko forKey:name];	
	[modules setObject:ko forKey:name];
	return ko;
}

-(TiModule*)moduleNamed:(NSString*)name context:(id<TiEvaluator>)context
{
	return [modules objectForKey:name];
}

@end

OSSpinLock krollBridgeRegistryLock = OS_SPINLOCK_INIT;
CFMutableSetRef	krollBridgeRegistry = nil;

@implementation KrollBridge

+(void)initialize
{
	if (krollBridgeRegistry == nil)
	{
		CFSetCallBacks doNotRetain = kCFTypeSetCallBacks;
		doNotRetain.retain = NULL;
		doNotRetain.release = NULL;
		krollBridgeRegistry = CFSetCreateMutable(NULL, 3, &doNotRetain);
	}
}
@synthesize currentURL;

-(void)registerForMemoryWarning
{
	WARN_IF_BACKGROUND_THREAD_OBJ;	//NSNotificationCenter is not threadsafe!
	[[NSNotificationCenter defaultCenter] addObserver:self
			selector:@selector(didReceiveMemoryWarning:)
			name:UIApplicationDidReceiveMemoryWarningNotification  
			object:nil]; 
}

-(void)unregisterForMemoryWarning
{
	WARN_IF_BACKGROUND_THREAD_OBJ;	//NSNotificationCenter is not threadsafe!
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}

-(id)init
{
	if (self = [super init])
	{
#if KROLLBRIDGE_MEMORY_DEBUG==1
		NSLog(@"INIT: %@",self);
#endif		
		modules = [[NSMutableDictionary alloc] init];
		proxyLock = OS_SPINLOCK_INIT;
		OSSpinLockLock(&krollBridgeRegistryLock);
		CFSetAddValue(krollBridgeRegistry, self);
		OSSpinLockUnlock(&krollBridgeRegistryLock);
		[self performSelectorOnMainThread:@selector(registerForMemoryWarning) withObject:nil waitUntilDone:NO];
	}
	return self;
}

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
    OSSpinLockLock(&proxyLock);
    if (registeredProxies == NULL) {
        OSSpinLockUnlock(&proxyLock);
        [self gc];
        return;
    }
    
    BOOL keepWarning = YES;    
    int proxiesCount = CFDictionaryGetCount(registeredProxies);
    OSSpinLockUnlock(&proxyLock);
        
    //During a memory panic, we may not get the chance to copy proxies.
    while (keepWarning)
    {
        keepWarning = NO;
        
        for (id proxy in (NSDictionary *)registeredProxies)
        {
            [proxy didReceiveMemoryWarning:notification];
            
            OSSpinLockLock(&proxyLock);
            if (registeredProxies == NULL) {
                OSSpinLockUnlock(&proxyLock);
                break;
            }
            
            int newCount = CFDictionaryGetCount(registeredProxies);
            OSSpinLockUnlock(&proxyLock);

            if (newCount != proxiesCount)
            {
                proxiesCount = newCount;
                keepWarning = YES;
                break;
            }
        }
    }
	
	[self gc];
}


#if KROLLBRIDGE_MEMORY_DEBUG==1
-(id)retain
{
	NSLog(@"RETAIN: %@ (%d)",self,[self retainCount]+1);
	return [super retain];
}
-(oneway void)release 
{
	NSLog(@"RELEASE: %@ (%d)",self,[self retainCount]-1);
	[super release];
}
#endif

-(void)removeProxies
{
	OSSpinLockLock(&proxyLock);
	CFDictionaryRef oldProxies = registeredProxies;
	registeredProxies = NULL;
	OSSpinLockUnlock(&proxyLock);
	
	for (id thisProxy in (NSDictionary *)oldProxies)
	{
		KrollObject * thisKrollObject = (id)CFDictionaryGetValue(oldProxies, thisProxy);
		[thisProxy contextShutdown:self];
		[thisKrollObject unprotectJsobject];
	}

	if (oldProxies != NULL)
	{
		CFRelease(oldProxies);
	}

	for (NSString * thisModuleKey in modules) {
		id thisModule = [modules objectForKey:thisModuleKey];
		if ([thisModule respondsToSelector:@selector(unprotectJsobject)]) {
			[thisModule unprotectJsobject];
		}
	}
	RELEASE_TO_NIL(modules);
}

-(void)dealloc
{
#if KROLLBRIDGE_MEMORY_DEBUG==1
	NSLog(@"DEALLOC: %@",self);
#endif
		
	[self removeProxies];
	RELEASE_TO_NIL(preload);
	RELEASE_TO_NIL(context);
	RELEASE_TO_NIL(_beershift);
	OSSpinLockLock(&krollBridgeRegistryLock);
	CFSetRemoveValue(krollBridgeRegistry, self);
	OSSpinLockUnlock(&krollBridgeRegistryLock);
	[super dealloc];
}

- (TiHost*)host
{
	return host;
}

- (KrollContext*) krollContext
{
	return context;
}

- (id)preloadForKey:(id)key name:(id)name
{
	if (preload!=nil)
	{
		NSDictionary* dict = [preload objectForKey:name];
		if (dict!=nil)
		{
			return [dict objectForKey:key];
		}
	}
	return nil;
}

- (void)boot:(id)callback url:(NSURL*)url_ preload:(NSDictionary*)preload_
{
	preload = [preload_ retain];
	[super boot:callback url:url_ preload:preload_];
	context = [[KrollContext alloc] init];
	context.delegate = self;
	[context start];
}

- (void)evalJSWithoutResult:(NSString*)code
{
	[context evalJS:code];
}

// NOTE: this must only be called on the JS thread or an exception will be raised
- (id)evalJSAndWait:(NSString*)code
{
	return [context evalJSAndWait:code];
}

- (void)scriptError:(NSString*)message
{
    evaluationError = YES;
	[[TiApp app] showModalError:message];
}

-(BOOL)evaluationError
{
    return evaluationError;
}

- (void)evalFileOnThread:(NSString*)path context:(KrollContext*)context_ 
{
	NSError *error = nil;
	TiValueRef exception = NULL;
	
	TiContextRef jsContext = [context_ context];
	
	NSURL *url_ = [path hasPrefix:@"file:"] ? [NSURL URLWithString:path] : [NSURL fileURLWithPath:path];
	
	if (![path hasPrefix:@"/"] && ![path hasPrefix:@"file:"])
	{
		url_ = [NSURL URLWithString:path relativeToURL:url];
	}
	
	NSString *jcode = nil;
	
	if ([url_ isFileURL])
	{
		NSData *data = [TiUtils loadAppResource:url_];
		if (data==nil)
		{
			jcode = [NSString stringWithContentsOfFile:[url_ path] encoding:NSUTF8StringEncoding error:&error];
		}
		else
		{
			jcode = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
		}
	}
	else
	{
		jcode = [NSString stringWithContentsOfURL:url_ encoding:NSUTF8StringEncoding error:&error];
	}
	
	if (error!=nil)
	{
		NSLog(@"[ERROR] error loading path: %@, %@",path,error);
		
		// check for file not found a give a friendlier message
		if ([error code]==260 && [error domain]==NSCocoaErrorDomain)
		{
			[self scriptError:[NSString stringWithFormat:@"Could not find the file %@",[path lastPathComponent]]];
		}
		else 
		{
			[self scriptError:[NSString stringWithFormat:@"Error loading script %@. %@",[path lastPathComponent],[error description]]];
		}
		return;
	}
	
	const char *urlCString = [[url_ absoluteString] UTF8String];
	
	TiStringRef jsCode = TiStringCreateWithCFString((CFStringRef) jcode);
	TiStringRef jsURL = TiStringCreateWithUTF8CString(urlCString);
	
	// validate script
	// TODO: we do not need to do this in production app
	if (!TiCheckScriptSyntax(jsContext,jsCode,jsURL,1,&exception))
	{
		id excm = [KrollObject toID:context value:exception];
		NSLog(@"[ERROR] Syntax Error = %@",[TiUtils exceptionMessage:excm]);
		[self scriptError:[TiUtils exceptionMessage:excm]];
	}
	
	// only continue if we don't have any exceptions from above
	if (exception == NULL)
	{
        if ([[self host] debugMode]) {
            TiDebuggerBeginScript(context_,urlCString);
        }
		
		TiEvalScript(jsContext, jsCode, NULL, jsURL, 1, &exception);
		
        if ([[self host] debugMode]) {
            TiDebuggerEndScript(context_);
        }

		if (exception!=NULL)
		{
			id excm = [KrollObject toID:context value:exception];
			NSLog(@"[ERROR] Script Error = %@.",[TiUtils exceptionMessage:excm]);
			[self scriptError:[TiUtils exceptionMessage:excm]];
		}
        else {
            evaluationError = NO;
        }
	}
	
	TiStringRelease(jsCode);
	TiStringRelease(jsURL);
}

- (void)evalFile:(NSString*)path callback:(id)callback selector:(SEL)selector
{
	[context invokeOnThread:self method:@selector(evalFileOnThread:context:) withObject:path callback:callback selector:selector];
}

- (void)evalFile:(NSString *)file
{
	[context invokeOnThread:self method:@selector(evalFileOnThread:context:) withObject:file condition:nil];
}

- (void)fireEvent:(id)listener withObject:(id)obj remove:(BOOL)yn thisObject:(TiProxy*)thisObject_
{
	if (![listener isKindOfClass:[KrollCallback class]])
	{
		NSLog(@"[ERROR] listener callback is of a non-supported type: %@",[listener class]);
		return;
	}

	KrollEvent *event = [[KrollEvent alloc] initWithCallback:listener eventObject:obj thisObject:thisObject_];
	[context enqueue:event];
	[event release];
}

-(void)enqueueEvent:(NSString*)type forProxy:(TiProxy *)proxy withObject:(id)obj withSource:(id)source
{
	KrollObject * eventKrollObject = [self krollObjectForProxy:proxy];
	KrollObject * sourceObject = [self krollObjectForProxy:source];
	if (sourceObject == nil)
	{
		sourceObject = eventKrollObject;
	}
	KrollEvent * newEvent = [[KrollEvent alloc] initWithType:type ForKrollObject:eventKrollObject
			 eventObject:obj thisObject:sourceObject];
	[context enqueue:newEvent];
	[newEvent release];
}

-(void)injectPatches
{
	// called to inject any BeerShift patches in JS before a context is loaded... nice for 
	// setting up backwards compat type APIs
	
	NSMutableString *js = [[NSMutableString alloc] init];
	[js appendString:@"function alert(msg) { Ti.UI.createAlertDialog({title:'Alert',message:msg}).show(); };"];
	[self evalJSWithoutResult:js];
	[js release];
}

-(void)shutdown:(NSCondition*)condition
{
#if KROLLBRIDGE_MEMORY_DEBUG==1
	NSLog(@"DESTROY: %@",self);
#endif
	
	if (shutdown==NO)
	{
		shutdownCondition = [condition retain];
		shutdown = YES;
		// fire a notification event to our listeners
		WARN_IF_BACKGROUND_THREAD_OBJ;	//NSNotificationCenter is not threadsafe!
		NSNotification *notification = [NSNotification notificationWithName:kTiContextShutdownNotification object:self];
		[[NSNotificationCenter defaultCenter] postNotification:notification];
		
		[context stop];
	}
	else
	{
		[condition lock];
		[condition signal];
		[condition unlock];
	}
}

-(void)gc
{
	[context gc];
	[_beershift gc];
}

#pragma mark Delegate

-(void)willStartNewContext:(KrollContext*)kroll
{
	[self retain]; // Hold onto ourselves as long as the context needs us
}

-(void)didStartNewContext:(KrollContext*)kroll
{
	// create BeerShift global object
	NSString *basePath = (url==nil) ? [TiHost resourcePath] : [[[url path] stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"."];
	_beershift = [[BeerShiftObject alloc] initWithContext:kroll host:host context:self baseURL:[NSURL fileURLWithPath:basePath]];
	
	TiContextRef jsContext = [kroll context];
	TiValueRef tiRef = [KrollObject toValue:kroll value:_beershift];
	
	NSString *_beershiftNS = [NSString stringWithFormat:@"T%sanium","it"];
	TiStringRef prop = TiStringCreateWithCFString((CFStringRef) _beershiftNS);
	TiStringRef prop2 = TiStringCreateWithCFString((CFStringRef) [NSString stringWithFormat:@"%si","T"]);
	TiObjectRef globalRef = TiContextGetGlobalObject(jsContext);
	TiObjectSetProperty(jsContext, globalRef, prop, tiRef, NULL, NULL);
	TiObjectSetProperty(jsContext, globalRef, prop2, tiRef, NULL, NULL);
	TiStringRelease(prop);
	TiStringRelease(prop2);	
	
	//if we have a preload dictionary, register those static key/values into our namespace
	if (preload!=nil)
	{
		for (NSString *name in preload)
		{
			KrollObject *ti = (KrollObject*)[_beershift valueForKey:name];
			NSDictionary *values = [preload valueForKey:name];
			for (id key in values)
			{
				id target = [values objectForKey:key];
				KrollObject *ko = [self krollObjectForProxy:target];
				if (ko==nil)
				{
					ko = [self registerProxy:target];
				}
				[ti noteKrollObject:ko forKey:key];
				[ti setStaticValue:ko forKey:key purgable:NO];
			}
		}
		[self injectPatches];
		[self evalFile:[url path] callback:self selector:@selector(booted)];	
	}
	else 
	{
		// now load the app.js file and get started
		NSURL *startURL = [host startURL];
		[self injectPatches];
		[self evalFile:[startURL absoluteString] callback:self selector:@selector(booted)];
	}
}

-(void)willStopNewContext:(KrollContext*)kroll
{
	if (shutdown==NO)
	{
		shutdown = YES;
		// fire a notification event to our listeners
		WARN_IF_BACKGROUND_THREAD_OBJ;	//NSNotificationCenter is not threadsafe!
		NSNotification *notification = [NSNotification notificationWithName:kTiContextShutdownNotification object:self];
		[[NSNotificationCenter defaultCenter] postNotification:notification];
	}
	[_beershift gc];
	
	if (shutdownCondition)
	{
		[shutdownCondition lock];
		[shutdownCondition signal];
		[shutdownCondition unlock];
		RELEASE_TO_NIL(shutdownCondition);
	}
}

-(void)didStopNewContext:(KrollContext*)kroll
{
	[self performSelectorOnMainThread:@selector(unregisterForMemoryWarning) withObject:nil waitUntilDone:NO];
	[self removeProxies];
	RELEASE_TO_NIL(_beershift);
	RELEASE_TO_NIL(context);
	RELEASE_TO_NIL(preload);
	[self autorelease]; // Safe to release now that the context is done
}

-(void)registerProxy:(id)proxy krollObject:(KrollObject *)ourKrollObject
{
	OSSpinLockLock(&proxyLock);
	if (registeredProxies==NULL)
	{
		registeredProxies = CFDictionaryCreateMutable(NULL, 10, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
	}
	//NOTE: Do NOT treat registeredProxies like a mutableDictionary; mutable dictionaries copy keys,
	//CFMutableDictionaryRefs only retain keys, which lets them work with proxies properly.

	CFDictionaryAddValue(registeredProxies, proxy, ourKrollObject);	
	OSSpinLockUnlock(&proxyLock);
	[proxy boundBridge:self withKrollObject:ourKrollObject];
}

- (id)registerProxy:(id)proxy 
{
	KrollObject * ourKrollObject = [self krollObjectForProxy:proxy];
	
	if (ourKrollObject != nil)
	{
		return ourKrollObject;
	}

	if (![context isKJSThread])
	{
		return nil;
	}

#ifdef KROLL_COVERAGE
	ourKrollObject = [[KrollCoverageObject alloc] initWithTarget:proxy context:context];
#else
	ourKrollObject = [[KrollObject alloc] initWithTarget:proxy context:context];
#endif

	[self registerProxy:proxy krollObject:ourKrollObject];
	return [ourKrollObject autorelease];
}

- (void)unregisterProxy:(id)proxy
{
	OSSpinLockLock(&proxyLock);
	if (registeredProxies != NULL)
	{
		CFDictionaryRemoveValue(registeredProxies, proxy);
		//Don't bother with removing the empty registry. It's small and leaves on dealloc anyways.
	}
	OSSpinLockUnlock(&proxyLock);
	[proxy unboundBridge:self];
}

- (BOOL)usesProxy:(id)proxy
{
	if (proxy == nil)
	{
		return NO;
	}
	BOOL result=NO;
	OSSpinLockLock(&proxyLock);
	
	if (registeredProxies != NULL)
	{
		result = (CFDictionaryGetCountOfKey(registeredProxies, proxy) != 0);
	}
	OSSpinLockUnlock(&proxyLock);
	return result;
}

- (id)krollObjectForProxy:(id)proxy
{
	id result=nil;
	OSSpinLockLock(&proxyLock);
	if (registeredProxies != NULL)
	{
		result = (id)CFDictionaryGetValue(registeredProxies, proxy);
	}
	OSSpinLockUnlock(&proxyLock);
	return result;
}

-(id)loadCommonJSModule:(NSString*)code withPath:(NSString*)path
{
	NSString *js = [[NSString alloc] initWithFormat:BeerShift$ModuleRequireFormat,code];

	/* This most likely should be integrated with normal code flow, but to
	 * minimize impact until a in-depth reconsideration of KrollContext can be
	 * done, we should have as little footprint 
	 */
	KrollEval *eval = [[KrollEval alloc] initWithCode:js];
	TiValueRef exception = NULL;
	TiValueRef resultRef = [eval jsInvokeInContext:context exception:&exception];
	[js release];
	[eval release];
	
	if (exception != NULL) {
		id excm = [KrollObject toID:context value:exception];
		NSLog(@"[ERROR] Script Error = %@",[TiUtils exceptionMessage:excm]);
		fflush(stderr);
		@throw excm;
	}
	/*
	 *	In order to work around the underlying issue of TIMOB-2392, we must
	 *	use KrollWrapper as a JS wrapper instead of converting it to a proxy
	 */

	KrollWrapper * result = [[KrollWrapper alloc] init];
	[result setBridge:self];
	[result setJsobject:(TiObjectRef)resultRef];
	[result protectJsobject];
	
	return [result autorelease];
}

-(NSString*)pathToModuleClassName:(NSString*)path
{
	//TODO: switch to use ApplicationMods
	
	NSArray *tokens = [path componentsSeparatedByString:@"."];
	NSMutableString *modulename = [NSMutableString string];
	for (NSString *token in tokens)
	{
		[modulename appendFormat:@"%@%@",[[token substringToIndex:1] uppercaseString],[token substringFromIndex:1]];
	}
	[modulename appendString:@"Module"];
	return modulename;
}

-(id)require:(KrollContext*)kroll path:(NSString*)path
{
	TiModule* module = nil;
	NSData *data = nil;
	NSString *filepath = nil;
	
	// first check to see if we've already loaded the module
	// and if so, return it
	if (modules!=nil)
	{
		module = [modules objectForKey:path];
		if (module!=nil)
		{
			return module;
		}
	}
	
	//If it's a relative path or has folder path bits, it cannot
	//be a class name.
	if (![path hasPrefix:@"."] && ([path rangeOfString:@"/"].location == NSNotFound)) {
		// now see if this is a plus module that we need to dynamically
		// load and create
		NSString *moduleClassName = [self pathToModuleClassName:path];
		id moduleClass = NSClassFromString(moduleClassName);
		if (moduleClass!=nil)
		{
			module = [[moduleClass alloc] _initWithPageContext:self];
			// we might have a module that's simply a JS native module wrapper
			// in which case we simply load it and don't register our native module
			if ([module isJSModule])
			{
				data = [module moduleJS];
			}
			else
			{
				[module setHost:host];
				[module _setName:moduleClassName];
				// register it
				[modules setObject:module forKey:path];
			}
			[module autorelease];
		}
	}
	
	if (data==nil)
	{
		filepath = [NSString stringWithFormat:@"%@.js",path];
		NSURL *url_ = [TiHost resourceBasedURL:filepath baseURL:NULL];
		data = [TiUtils loadAppResource:url_];
		if (data==nil)
		{
			data = [NSData dataWithContentsOfURL:url_];
		}
	}

	// we found data, now create the common js module proxy
	if (data!=nil)
	{
        NSString* urlPath = (filepath != nil) ? filepath : path;
		NSURL *url_ = [TiHost resourceBasedURL:urlPath baseURL:NULL];
       	const char *urlCString = [[url_ absoluteString] UTF8String];
        if ([[self host] debugMode]) {
            TiDebuggerBeginScript([self krollContext],urlCString);
        }
        
		NSString * dataContents = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		module = [self loadCommonJSModule:dataContents withPath:path];
        [dataContents release];
		
        if ([[self host] debugMode]) {
            TiDebuggerEndScript([self krollContext]);
        }
        
		if (![module respondsToSelector:@selector(replaceValue:forKey:notification:)]) {
			@throw [NSException exceptionWithName:@"org.beershift.kroll" reason:[NSString stringWithFormat:@"Module \"%@\" failed to leave a valid exports object",path] userInfo:nil];
		}
		
		// register it
		[modules setObject:module forKey:path];
		if (filepath!=nil && module!=nil)
		{
			// uri is optional but we point it to where we loaded it
			[module replaceValue:[NSString stringWithFormat:@"app://%@",filepath] forKey:@"uri" notification:NO];
		}
	}
	
	if (module!=nil)
	{
		// spec says you must have a read-only id property - we don't
		// currently support readonly in kroll so this is probably OK for now
		[module replaceValue:path forKey:@"id" notification:NO];
		return module;
	}
	
	@throw [NSException exceptionWithName:@"org.beershift.kroll" reason:[NSString stringWithFormat:@"Couldn't find module: %@",path] userInfo:nil];
}

+ (NSArray *)krollBridgesUsingProxy:(id)proxy
{
	NSMutableArray * results = nil;

	OSSpinLockLock(&krollBridgeRegistryLock);
	int bridgeCount = CFSetGetCount(krollBridgeRegistry);
	KrollBridge * registryObjects[bridgeCount];
	CFSetGetValues(krollBridgeRegistry, (const void **)registryObjects);
	
	for (int currentBridgeIndex = 0; currentBridgeIndex < bridgeCount; currentBridgeIndex++)
	{
		KrollBridge * currentBridge = registryObjects[currentBridgeIndex];
		if (![currentBridge usesProxy:proxy])
		{
			continue;
		}
		if (results == nil)
		{
			results = [NSMutableArray arrayWithObject:currentBridge];
			continue;
		}
		[results addObject:currentBridge];
	}

	//Why do we wait so long? In case someone tries to dealloc the krollBridge while we're looking at it.
	//registryObjects nor the registry does a retain here!
	OSSpinLockUnlock(&krollBridgeRegistryLock);
	return results;
}

+ (BOOL)krollBridgeExists:(KrollBridge *)bridge
{
	if(bridge == nil)
	{
		return NO;
	}

	bool result=NO;
	OSSpinLockLock(&krollBridgeRegistryLock);
	int bridgeCount = CFSetGetCount(krollBridgeRegistry);
	KrollBridge * registryObjects[bridgeCount];
	CFSetGetValues(krollBridgeRegistry, (const void **)registryObjects);
	for (int currentBridgeIndex = 0; currentBridgeIndex < bridgeCount; currentBridgeIndex++)
	{
		KrollBridge * currentBridge = registryObjects[currentBridgeIndex];
		if (currentBridge == bridge)
		{
			result = YES;
			break;
		}
	}
	//Why not CFSetContainsValue? Because bridge may not be a valid pointer, and SetContainsValue
	//will ask it for a hash!
	OSSpinLockUnlock(&krollBridgeRegistryLock);

	return result;
}

+ (KrollBridge *)krollBridgeForThreadName:(NSString *)threadName;
{
	if(threadName == nil)
	{
		return nil;
	}

	KrollBridge * result=nil;
	OSSpinLockLock(&krollBridgeRegistryLock);
	int bridgeCount = CFSetGetCount(krollBridgeRegistry);
	KrollBridge * registryObjects[bridgeCount];
	CFSetGetValues(krollBridgeRegistry, (const void **)registryObjects);
	for (int currentBridgeIndex = 0; currentBridgeIndex < bridgeCount; currentBridgeIndex++)
	{
		KrollBridge * currentBridge = registryObjects[currentBridgeIndex];
		if ([[[currentBridge krollContext] threadName] isEqualToString:threadName])
		{
			result = [[currentBridge retain] autorelease];
			break;
		}
	}
	OSSpinLockUnlock(&krollBridgeRegistryLock);

	return result;
}


-(int)forceGarbageCollectNow;
{
	[context gc];
	//Actually forcing garbage collect now will cause a deadlock.
	return 0;
}

-(BOOL)shouldDebugContext
{
    return [[self host] debugMode];
}

@end