/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */
#ifdef USE_TI_PLATFORM

#import "TiPlatformDisplayCaps.h"
#import "TiUtils.h"

@implementation TiPlatformDisplayCaps



// NOTE: device capabilities currently are hardcoded for iPad, while high/low
// display density is now detected for iPhone / iPod Touch under iOS 4.

- (id)density
{
	if ([TiUtils isRetinaDisplay] && ![TiUtils isIPad])
	{
		return @"high";
	}
	return @"medium";
}

- (id)dpi
{
	if ([TiUtils isIPad])
	{
		return [NSNumber numberWithInt:130];
	}
	else if ([TiUtils isRetinaDisplay])
	{
		return [NSNumber numberWithInt:320];
	}
	else
	{
		return [NSNumber numberWithInt:160];
	}
}

- (BOOL)isDevicePortrait
{
	UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
	return  (orientation == UIDeviceOrientationPortrait || 
			 orientation == UIDeviceOrientationPortraitUpsideDown || 
			 orientation == UIDeviceOrientationUnknown);
}

-(BOOL)isUIPortrait
{
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
	return  UIInterfaceOrientationIsPortrait(orientation);
}


- (NSNumber*) platformWidth
{
	if ([self isUIPortrait])
	{
		return [NSNumber numberWithFloat:[[UIScreen mainScreen] bounds].size.width];	
	}
	else
	{
		return [NSNumber numberWithFloat:[[UIScreen mainScreen] bounds].size.height];	
	}
}

- (NSNumber*) platformHeight
{
	if ([self isUIPortrait] == NO)
	{
		return [NSNumber numberWithFloat:[[UIScreen mainScreen] bounds].size.width];	
	}
	else
	{
		return [NSNumber numberWithFloat:[[UIScreen mainScreen] bounds].size.height];	
	}
}

@end

#endif