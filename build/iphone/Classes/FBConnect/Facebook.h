/*
 * Copyright 2010 Facebook
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0

 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#ifdef USE_TI_FACEBOOK
#import "FBLoginDialog.h"
#import "FBRequest.h"
#import "Facebook.h"

@protocol FBSessionDelegate2;

/**
 * Main Facebook interface for interacting with the Facebook developer API.
 * Provides methods to log in and log out a user, make requests using the REST
 * and Graph APIs, and start user interface interactions (such as
 * pop-ups promoting for credentials, permissions, stream posts, etc.)
 */
@interface Facebook : NSObject<FBLoginDialogDelegate2>{
  NSString* _accessToken;
  NSDate* _expirationDate;
  id<FBSessionDelegate2> _sessionDelegate;
  FBRequest2* _request;
  FBDialog2* _loginDialog;
  FBDialog2* _fbDialog;
  NSString* _appId;
  NSString* _urlSchemeSuffix;
  NSArray* _permissions;
  BOOL appSupportsBackgrounding;
	BOOL forceDialog;
}

@property(nonatomic, copy) NSString* accessToken;

@property(nonatomic, copy) NSDate* expirationDate;

@property(nonatomic, assign) id<FBSessionDelegate2> sessionDelegate;
@property(nonatomic, copy) NSString* urlSchemeSuffix;

//Properties added to restore older functionality in the new facebook API:
//We can now add appIds after the fact, and force a dialog to open
@property(nonatomic, copy) NSString* appId;
@property(nonatomic, assign) BOOL forceDialog;

- (id)initWithAppId:(NSString *)appId
        andDelegate:(id<FBSessionDelegate2>)delegate;

- (id)initWithAppId:(NSString *)appId
    urlSchemeSuffix:(NSString *)urlSchemeSuffix
        andDelegate:(id<FBSessionDelegate2>)delegate;

- (void)authorize:(NSArray *)permissions;

- (BOOL)handleOpenURL:(NSURL *)url;

- (void)logout:(id<FBSessionDelegate2>)delegate;

- (FBRequest2*)requestWithParams:(NSMutableDictionary *)params
                    andDelegate:(id <FBRequestDelegate2>)delegate;

- (FBRequest2*)requestWithMethodName:(NSString *)methodName
                          andParams:(NSMutableDictionary *)params
                      andHttpMethod:(NSString *)httpMethod
                        andDelegate:(id <FBRequestDelegate2>)delegate;

- (FBRequest2*)requestWithGraphPath:(NSString *)graphPath
                       andDelegate:(id <FBRequestDelegate2>)delegate;

- (FBRequest2*)requestWithGraphPath:(NSString *)graphPath
                         andParams:(NSMutableDictionary *)params
                       andDelegate:(id <FBRequestDelegate2>)delegate;

- (FBRequest2*)requestWithGraphPath:(NSString *)graphPath
                         andParams:(NSMutableDictionary *)params
                     andHttpMethod:(NSString *)httpMethod
                       andDelegate:(id <FBRequestDelegate2>)delegate;

- (void)dialog:(NSString *)action
   andDelegate:(id<FBDialogDelegate2>)delegate;

- (void)dialog:(NSString *)action
     andParams:(NSMutableDictionary *)params
   andDelegate:(id <FBDialogDelegate2>)delegate;

- (BOOL)isSessionValid;

@end

////////////////////////////////////////////////////////////////////////////////

/**
 * Your application should implement this delegate to receive session callbacks.
 */
@protocol FBSessionDelegate2 <NSObject>

@optional

/**
 * Called when the user successfully logged in.
 */
- (void)fbDidLogin;

/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)fbDidNotLogin:(BOOL)cancelled;

/**
 * Called when the user logged out.
 */
- (void)fbDidLogout;

@end

extern NSString* kRedirectURL;
#endif