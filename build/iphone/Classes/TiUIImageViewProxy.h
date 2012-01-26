/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */
#ifdef USE_TI_UIIMAGEVIEW

#import "TiViewProxy.h"
#import "ImageLoader.h"

@interface TiUIImageViewProxy : TiViewProxy<ImageLoaderDelegate> {
	ImageLoaderRequest *urlRequest;
    NSURL* imageURL;
}
@property (nonatomic,retain) NSURL* imageURL;

-(void)cancelPendingImageLoads;
-(void)startImageLoad:(NSURL *)url;

@end

#endif