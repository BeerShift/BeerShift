/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */
#import "TiModule.h"

#ifdef USE_TI_FILESYSTEM

@interface FilesystemModule : TiModule {

}

@property(nonatomic,readonly) NSString *resourcesDirectory;
@property(nonatomic,readonly) NSString *applicationDirectory;
@property(nonatomic,readonly) NSString *applicationDataDirectory;
@property(nonatomic,readonly) NSString *tempDirectory;
@property(nonatomic,readonly) NSString *separator;
@property(nonatomic,readonly) NSString *lineEnding;

@property(nonatomic,readonly) NSNumber *MODE_APPEND;
@property(nonatomic,readonly) NSNumber *MODE_WRITE;
@property(nonatomic,readonly) NSNumber *MODE_READ;


@end

#endif