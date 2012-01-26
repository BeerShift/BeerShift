/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */

#import <Foundation/Foundation.h>

/**
 * Operation Queue is a utility class that provides a shared queue
 * that can be used to handle background jobs and after the jobs complete
 * can call a callback either on or off the main UI thread.
 */

@interface OperationQueue : NSObject {
	NSOperationQueue *queue;
}

+(OperationQueue*)sharedQueue;

/**
 * queue an operation that targets selector on target
 * invoke after (if not nil) on when completed
 * pass YES to ui to invoke after on UI main thread
 */
-(void)queue:(SEL)selector target:(id)target arg:(id)arg after:(SEL)after on:(id)on ui:(BOOL)ui;

@end
