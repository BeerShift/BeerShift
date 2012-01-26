/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */

#import <UIKit/UIKit.h>

@interface Webcolor : NSObject
{
}

+(UIColor*)checkmarkColor;
+(UIColor*)webColorNamed:(NSString*)colorName;
+(UIColor*)colorForRGBFunction:(NSString*)functionString;
+(UIColor*)colorForHex:(NSString*)hexCode;
+(void)flushCache;
+(BOOL)isDarkColor:(UIColor*)color;

@end


#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


