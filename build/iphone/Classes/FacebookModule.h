/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2011 by BeerShift, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */
#ifdef USE_TI_FACEBOOK
#import "TiModule.h"
#import "Facebook.h"

@protocol TiFacebookStateListener
@required
-(void)login;
-(void)logout;
@end


@interface FacebookModule : TiModule <FBSessionDelegate2, FBRequestDelegate2>
{
	Facebook *facebook;
	BOOL loggedIn;
	NSString *uid;
	NSString *url;
	NSString *appid;
	NSArray *permissions;
	NSMutableArray *stateListeners;
    BOOL forceDialogAuth;
}

@property(nonatomic,readonly) Facebook *facebook;
@property(nonatomic,readonly) NSNumber *BUTTON_STYLE_NORMAL;	  	
@property(nonatomic,readonly) NSNumber *BUTTON_STYLE_WIDE;

-(BOOL)isLoggedIn;
-(void)addListener:(id<TiFacebookStateListener>)listener;
-(void)removeListener:(id<TiFacebookStateListener>)listener;

-(void)authorize:(id)args;
-(void)logout:(id)args;


@end
#endif