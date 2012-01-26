/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */
#ifdef USE_TI_UITABLEVIEW

#ifndef USE_TI_UISEARCHBAR
#define USE_TI_UISEARCHBAR
#endif

#include "TiViewProxy.h"

@class TiUITableViewRowProxy;
@interface TiUITableViewProxy : TiViewProxy
{
	NSMutableArray *sections;
}
-(void)setData:(id)args withObject:(id)properties;
-(NSArray*)data;

//Sections is private. Data is the sanitized version.
@property(nonatomic,readwrite,retain) NSMutableArray *sections;
-(int)sectionCount;

-(NSInteger)indexForRow:(TiUITableViewRowProxy*)row;
-(NSInteger)sectionIndexForIndex:(NSInteger)theindex;
-(TiUITableViewRowProxy*)rowForIndex:(NSInteger)index section:(NSInteger*)section;
-(NSIndexPath *)indexPathFromInt:(NSInteger)index;
-(NSInteger)indexForIndexPath:(NSIndexPath *)path;


@end

#endif
