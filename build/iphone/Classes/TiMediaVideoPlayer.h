/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */
#ifdef USE_TI_MEDIA

#import "TiUIView.h"
#import <MediaPlayer/MediaPlayer.h>

@interface TiMediaVideoPlayer : TiUIView {
@private
	MPMoviePlayerController *controller;
	UIActivityIndicatorView *spinner;
	
	BOOL loaded;
}

-(id)initWithPlayer:(MPMoviePlayerController*)controller proxy:(TiProxy*)proxy loaded:(BOOL)loaded_;
-(void)setMovie:(MPMoviePlayerController*)controller;
-(void)movieLoaded;

@end


#endif
