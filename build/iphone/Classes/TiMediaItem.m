/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */
#ifdef USE_TI_MEDIA
#import "TiMediaItem.h"
#import "MediaModule.h"


@implementation TiMediaItem

#pragma mark Internal

-(id)_initWithPageContext:(id<TiEvaluator>)context item:(MPMediaItem*)item_
{
	if (self = [super _initWithPageContext:context]) {
		item = [item_ retain];
	}
	return self;
}

-(void)dealloc
{
	RELEASE_TO_NIL(item);
	[super dealloc];
}

-(MPMediaItem*)item
{
	return item;
}

#pragma mark Properties

-(TiBlob*)artwork
{
	MPMediaItemArtwork* artwork = [item valueForProperty:MPMediaItemPropertyArtwork];
	if (artwork != nil) {
		return [[[TiBlob alloc] initWithImage:[artwork imageWithSize:[artwork imageCropRect].size]] autorelease];
	}
	return nil;
}

// This is a sleazy way of getting properties so that I don't have to write 15 functions.
-(id)valueForUndefinedKey:(NSString *)key
{
	id propertyName = [[MediaModule itemProperties] objectForKey:key];
	if (propertyName == nil) {
        propertyName = [[MediaModule filterableItemProperties] objectForKey:key];
        if (propertyName == nil) {
            return [super valueForUndefinedKey:key];
        }
	}
	return [item valueForProperty:propertyName];
}

@end

#endif