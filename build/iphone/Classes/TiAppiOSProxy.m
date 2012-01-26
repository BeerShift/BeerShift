/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */

#import "TiAppiOSProxy.h"
#import "TiUtils.h"
#import "TiApp.h"

#ifdef USE_TI_APPIOS
#import "TiAppiOSBackgroundServiceProxy.h"
#import "TiAppiOSLocalNotificationProxy.h"

#define NOTNULL(v) ((v==nil) ? (id)[NSNull null] : v)

@implementation TiAppiOSProxy

-(void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

-(void)_listenerAdded:(NSString*)type count:(int)count
{
	if (count == 1 && [type isEqual:@"notification"])
	{
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveLocalNotification:) name:kTiLocalNotification object:nil];
	}
}

-(void)_listenerRemoved:(NSString*)type count:(int)count
{
	if (count == 0 && [type isEqual:@"notification"])
	{
		[[NSNotificationCenter defaultCenter] removeObserver:self name:kTiLocalNotification object:nil];
	}
}

-(void)_scheduleNotification:(NSArray*)arg
{
	UILocalNotification* localNotif = [arg objectAtIndex:0];
	NSDate *date = [arg objectAtIndex:1];
	
	if (date!=nil)
	{
		[[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
	}
	else
	{
		[[UIApplication sharedApplication] presentLocalNotificationNow:localNotif];
	}
	
}

#pragma mark Public

-(id)registerBackgroundService:(id)args
{
	TiAppiOSBackgroundServiceProxy *proxy = [[TiAppiOSBackgroundServiceProxy alloc] _initWithPageContext:[self executionContext] args:args];
	[[TiApp app] registerBackgroundService:proxy];
	return [proxy autorelease];
}

-(id)scheduleLocalNotification:(id)args
{
	ENSURE_SINGLE_ARG(args,NSDictionary);
	UILocalNotification *localNotif = [[UILocalNotification alloc] init];
	
	id date = [args objectForKey:@"date"];
	
	if (date!=nil)
	{
		localNotif.fireDate = date;
		localNotif.timeZone = [NSTimeZone defaultTimeZone];
	}
	
	id repeat = [args objectForKey:@"repeat"];
	if (repeat!=nil)
	{
		if ([repeat isEqual:@"weekly"])
		{
			localNotif.repeatInterval = NSWeekCalendarUnit;
		}
		else if ([repeat isEqual:@"daily"])
		{
			localNotif.repeatInterval = NSDayCalendarUnit;
		}
		else if ([repeat isEqual:@"yearly"])
		{
			localNotif.repeatInterval = NSYearCalendarUnit;
		}
		else if ([repeat isEqual:@"monthly"])
		{
			localNotif.repeatInterval = NSMonthCalendarUnit;
		}
	}
	
	id alertBody = [args objectForKey:@"alertBody"];
	if (alertBody!=nil)
	{
		localNotif.alertBody = alertBody;
	}
	id alertAction = [args objectForKey:@"alertAction"];
	if (alertAction!=nil)
	{
		localNotif.alertAction = alertAction;
	}
	id alertLaunchImage = [args objectForKey:@"alertLaunchImage"];
	if (alertLaunchImage!=nil)
	{
		localNotif.alertLaunchImage = alertLaunchImage;
	}
	
	id badge = [args objectForKey:@"badge"];
	if (badge!=nil)
	{
		localNotif.applicationIconBadgeNumber = [TiUtils intValue:badge];
	}
	
	id sound = [args objectForKey:@"sound"];
	if (sound!=nil)
	{
		if ([sound isEqual:@"default"])
		{
			localNotif.soundName = UILocalNotificationDefaultSoundName;
		}
		else
		{
			localNotif.soundName = sound;
		}
	}
	
	id userInfo = [args objectForKey:@"userInfo"];
	if (userInfo!=nil)
	{
		localNotif.userInfo = userInfo;
	}
	
	[self performSelectorOnMainThread:@selector(_scheduleNotification:) withObject:[NSArray arrayWithObjects:localNotif,date,nil] waitUntilDone:NO];
	
	TiAppiOSLocalNotificationProxy *lp = [[[TiAppiOSLocalNotificationProxy alloc] _initWithPageContext:[self executionContext]] autorelease];
	lp.notification = localNotif;

	[localNotif release];
	return lp;
}

-(void)cancelAllLocalNotifications:(id)args
{
	ENSURE_UI_THREAD(cancelAllLocalNotifications,args);
	[[UIApplication sharedApplication] cancelAllLocalNotifications];
}

-(void)cancelLocalNotification:(id)args
{
	ENSURE_UI_THREAD(cancelLocalNotification,args);
	ENSURE_SINGLE_ARG(args,NSObject);
	NSInteger theid = [TiUtils intValue:args];
	NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
	if (notifications!=nil)
	{
		UILocalNotification *notification = nil;
		
		for (notification in notifications)
		{
			id i = [[notification userInfo] objectForKey:@"id"];
			if (i!=nil)
			{
				if ([i intValue]==theid)
				{
					break;
				}
			}
			notification = nil;
		}
		if (notification!=nil)
		{
			notification.userInfo = nil;
			[[UIApplication sharedApplication] cancelLocalNotification:notification];
		}
	}
}

-(void)didReceiveLocalNotification:(NSNotification*)note
{
	UILocalNotification *notification = [note object];
	NSMutableDictionary* event = [NSMutableDictionary dictionary];
	if (notification!=nil)
	{
		[event setObject:NOTNULL([notification fireDate]) forKey:@"date"];
		[event setObject:NOTNULL([[notification timeZone] name]) forKey:@"timezone"];
		[event setObject:NOTNULL([notification alertBody]) forKey:@"alertBody"];
		[event setObject:NOTNULL([notification alertAction]) forKey:@"alertAction"];
		[event setObject:NOTNULL([notification alertLaunchImage]) forKey:@"alertLaunchImage"];
		[event setObject:NOTNULL([notification soundName]) forKey:@"sound"];
		[event setObject:NUMINT([notification applicationIconBadgeNumber]) forKey:@"badge"];
		[event setObject:NOTNULL([notification userInfo]) forKey:@"userInfo"];
	}
	[self fireEvent:@"notification" withObject:event];
}


@end

#endif
