/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */

#import "TiRange.h"
#import "TiUtils.h"


@implementation TiRange

-(id)initWithRange:(NSRange)range_
{
	if (self = [super init])
	{
		range = range_;
	}
	return self;
}

-(NSNumber*)location
{
	return [NSNumber numberWithInt:range.location];
}

-(void)setLocation:(id)location
{
	range.location = [TiUtils intValue:location];
}

-(NSNumber*)length
{
	return [NSNumber numberWithInt:range.length];
}

-(void)setLength:(id)length
{
	range.length = [TiUtils intValue:length];
}

@end
