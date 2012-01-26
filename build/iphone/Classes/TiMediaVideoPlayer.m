/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */
#ifdef USE_TI_MEDIA

#import "TiMediaVideoPlayer.h"
#import "TiViewProxy.h"
#import "TiUtils.h"
#import "Webcolor.h"


@implementation TiMediaVideoPlayer

-(id)initWithPlayer:(MPMoviePlayerController*)controller_ proxy:(TiProxy*)proxy_ loaded:(BOOL)loaded_
{
	if (self = [super init])
	{
        loaded = loaded_;
		[self setProxy:proxy_];
		[self setMovie:controller_];
	}
	return self;
}

-(void)animationCompleted:(id)note
{
	if (spinner!=nil)
	{
		[spinner stopAnimating];
		[spinner removeFromSuperview];
		RELEASE_TO_NIL(spinner);
	}
}

-(void)movieLoaded
{
	if (spinner!=nil)
	{
		[UIView beginAnimations:@"movieAnimation" context:NULL];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationCompleted:)];
		[UIView setAnimationDuration:0.7];
		[spinner setAlpha:0];
		[UIView commitAnimations];
	}
	
	loaded = YES;
}

-(void)setMovie:(MPMoviePlayerController*)controller_
{
	if (controller!=nil)
	{
		if ([controller_ isEqual:controller])
		{
			// don't add the movie more than once if the same
			return;
		}
		[[controller view] removeFromSuperview];
	}
	RELEASE_TO_NIL(controller);
	controller = [controller_ retain];
	
	[TiUtils setView:[controller view] positionRect:self.bounds];
	[self addSubview:[controller view]];
	[self sendSubviewToBack:[controller view]];
	
	TiColor *bgcolor = [TiUtils colorValue:[self.proxy valueForKey:@"backgroundColor"]];
	UIActivityIndicatorViewStyle style = UIActivityIndicatorViewStyleGray;
	if (bgcolor!=nil)
	{
		// check to see if the background is a dark color and if so, we want to 
		// show the white indicator instead
		if ([Webcolor isDarkColor:[bgcolor _color]])
		{
			style = UIActivityIndicatorViewStyleWhite;
		} 
	}

	// show a spinner while the movie is loading so that the user
	// will know something is happening...

	if (!loaded) {
		if (spinner == nil)
		{
			spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
			spinner.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
			[spinner sizeToFit];
			[spinner setHidesWhenStopped:NO];
			
			[spinner startAnimating];
			spinner.center = [[controller view] center];
			[[controller view] addSubview:spinner];
		}
		else if ([spinner activityIndicatorViewStyle] != style)
		{
			[spinner setActivityIndicatorViewStyle:style];
			[spinner sizeToFit];
		}
	}
}

-(void)dealloc
{
	if (controller!=nil)
	{
		[[controller view] removeFromSuperview];
	}
	RELEASE_TO_NIL(controller);
	RELEASE_TO_NIL(spinner);
	[super dealloc];
}

-(void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds
{
	self.frame = CGRectIntegral(self.frame);
	[TiUtils setView:[controller view] positionRect:bounds];
}

@end

#endif