/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */
#import "TiProxy.h"

#ifdef USE_TI_APP


@interface TiAppPropertiesProxy : TiProxy 
{
@private
	NSUserDefaults *defaultsObject;
}

-(id)getBool:(id)args;
-(id)getDouble:(id)args;
-(id)getInt:(id)args;
-(id)getString:(id)args;
-(id)getList:(id)args;
-(void)setBool:(id)args;
-(void)setDouble:(id)args;
-(void)setInt:(id)args;
-(void)setString:(id)args;
-(void)setList:(id)args;
-(void)removeProperty:(id)args;
-(void)removeAllProperties;
-(id)hasProperty:(id)args;
-(id)listProperties:(id)args;

@end

#endif