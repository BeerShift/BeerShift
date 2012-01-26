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
#import "FBDialog.h"
#import "FBLoginDialog.h"
#import "Facebook.h"

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation FBLoginDialog2

///////////////////////////////////////////////////////////////////////////////////////////////////
// public 

/*
 * initialize the FBLoginDialog with url and parameters
 */
- (id)initWithURL:(NSString*) loginURL 
      loginParams:(NSMutableDictionary*) params 
         delegate:(id <FBLoginDialogDelegate2>) delegate{
  
  self = [super init];
  _serverURL = [loginURL retain];
  _params = [params retain];
  _loginDelegate = delegate;
  return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// FBDialog

/**
 * Override FBDialog : to call when the webView Dialog did succeed
 */
- (void) dialogDidSucceed:(NSURL*)url {
  NSString *q = [url absoluteString];
  NSString *token = [self getStringFromUrl:q needle:@"access_token="];
  NSString *expTime = [self getStringFromUrl:q needle:@"expires_in="];
  NSDate *expirationDate =nil;
  
  if (expTime != nil) {
    int expVal = [expTime intValue];
    if (expVal == 0) {
      expirationDate = [NSDate distantFuture];
    } else {
      expirationDate = [NSDate dateWithTimeIntervalSinceNow:expVal];
    } 
  } 
  
  if ((token == (NSString *) [NSNull null]) || (token.length == 0)) {
    [self dialogDidCancel:url];
    [self dismissWithSuccess:NO animated:YES];
  } else {
    if ([_loginDelegate respondsToSelector:@selector(fbDialogLogin:expirationDate:)]) {
      [_loginDelegate fbDialogLogin:token expirationDate:expirationDate];
    }
    [self dismissWithSuccess:YES animated:YES];
  }
  
}

/**
 * Override FBDialog : to call with the login dialog get canceled 
 */
- (void)dialogDidCancel:(NSURL *)url {
  [self dismissWithSuccess:NO animated:YES];
  if ([_loginDelegate respondsToSelector:@selector(fbDialogNotLogin:)]) {
    [_loginDelegate fbDialogNotLogin:YES];
  }
}

/** 
 * SPT HOTFIX: Special thanks to http://stackoverflow.com/questions/4299403/how-to-handle-app-urls-in-a-uiwebview.
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	NSURL* url = [request URL];
	if (![[url scheme] isEqual:@"http"] && ![[url scheme] isEqual:@"https"]) {
		// Check for one of two conditions:
		// 1. URL is a redirect to our app
		// 2. URL is the legacy fbconnect://... type
		if (([[UIApplication sharedApplication] canOpenURL:url] &&
			 [[UIApplication sharedApplication] openURL:url]) ||
			[[url absoluteString] rangeOfString:kRedirectURL].location != NSNotFound) {
			[self dialogDidSucceed:url];
			return NO;
		}
	}
	return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  if (!(([error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == -999) ||
        ([error.domain isEqualToString:@"WebKitErrorDomain"] && error.code == 102))) {
    [super webView:webView didFailLoadWithError:error];
    if ([_loginDelegate respondsToSelector:@selector(fbDialogNotLogin:)]) {
      [_loginDelegate fbDialogNotLogin:NO];
    }
  }
}

@end
#endif