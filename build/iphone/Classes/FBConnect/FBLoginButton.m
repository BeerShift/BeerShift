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
#import "FBLoginButton.h"
#import "Facebook.h"


///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation FBLoginButton2

@synthesize isLoggedIn = _isLoggedIn;
@synthesize style = _style;

///////////////////////////////////////////////////////////////////////////////////////////////////
// private

/**
 * return the regular button image according to the login status
 */
- (UIImage*)buttonImage 
{
  if (_isLoggedIn) 
  {
	  return [UIImage imageNamed:@"modules/facebook/images/LogoutNormal.png"];
  } 
  else 
  {
	  if (_style == FB_LOGIN_BUTTON_NORMAL)
	  {
		  return [UIImage imageNamed:@"modules/facebook/images/LoginNormal.png"];
	  }
	  else
	  {
		  return [UIImage imageNamed:@"modules/facebook/images/LoginWithFacebookNormal.png"];
	  }
  }
}

/**
 * return the highlighted button image according to the login status
 */
- (UIImage*)buttonHighlightedImage 
{
  if (_isLoggedIn) 
  {
    return [UIImage imageNamed:@"modules/facebook/images/LogoutPressed.png"];
  } 
  else 
  {
	  if (_style == FB_LOGIN_BUTTON_NORMAL)
	  {
		  return [UIImage imageNamed:@"modules/facebook/images/LoginPressed.png"];
	  }
	  else 
	  {
		  return [UIImage imageNamed:@"modules/facebook/images/LoginWithFacebookPressed.png"];
	  }
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////
// public

/**
 * To be called whenever the login status is changed
 */
- (void)updateImage {
  self.imageView.image = [self buttonImage];
  [self setImage: [self buttonImage]
                  forState: UIControlStateNormal];

  [self setImage: [self buttonHighlightedImage]
                  forState: UIControlStateHighlighted |UIControlStateSelected];

}

@end 
#endif