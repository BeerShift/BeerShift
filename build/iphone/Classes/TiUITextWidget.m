/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */
#if defined(USE_TI_UITEXTWIDGET) || defined(USE_TI_UITEXTAREA) || defined(USE_TI_UITEXTFIELD)

#import "TiUITextWidget.h"

#import "TiViewProxy.h"
#import "TiApp.h"
#import "TiUtils.h"

@implementation TiUITextWidget

- (id) init
{
	self = [super init];
	if (self != nil)
	{
		suppressReturn = YES;
	}
	return self;
}


-(void)setSuppressReturn_:(id)value
{
	suppressReturn = [TiUtils boolValue:value def:YES];
}

- (void) dealloc
{
	[textWidgetView performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
	[textWidgetView	performSelectorOnMainThread:@selector(release) withObject:nil waitUntilDone:NO];
	//Because text fields MUST be played with on main thread, we cannot release if there's the chance we're on a BG thread
	textWidgetView = nil;	//Wasted action, yes.
	[super dealloc];
}

-(BOOL)hasTouchableListener
{
	// since this guy only works with touch events, we always want them
	// just always return YES no matter what listeners we have registered
	return YES;
}

#pragma mark Must override
-(BOOL)hasText
{
	return NO;
}

-(UIView *)textWidgetView
{
	return nil;
}

#pragma mark Common values

-(void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds
{
	[textWidgetView setFrame:[self bounds]];
}

-(void)setColor_:(id)color
{
	UIColor * newColor = [[TiUtils colorValue:color] _color];
	[(id)[self textWidgetView] setTextColor:(newColor != nil)?newColor:[UIColor darkTextColor]];
}

-(void)setFont_:(id)font
{
	[(id)[self textWidgetView] setFont:[[TiUtils fontValue:font] font]];
}

// <0.9 is textAlign
-(void)setTextAlign_:(id)alignment
{
	[(id)[self textWidgetView] setTextAlignment:[TiUtils textAlignmentValue:alignment]];
}

-(void)setReturnKeyType_:(id)value
{
	[[self textWidgetView] setReturnKeyType:[TiUtils intValue:value]];
}

-(void)setEnableReturnKey_:(id)value
{
	[[self textWidgetView] setEnablesReturnKeyAutomatically:[TiUtils boolValue:value]];
}

-(void)setKeyboardType_:(id)value
{
	[[self textWidgetView] setKeyboardType:[TiUtils intValue:value]];
}

-(void)setAutocorrect_:(id)value
{
	[[self textWidgetView] setAutocorrectionType:[TiUtils boolValue:value] ? UITextAutocorrectionTypeYes : UITextAutocorrectionTypeNo];
}

#pragma mark Responder methods
//These used to be blur/focus, but that's moved to the proxy only.
//The reason for that is so checking the toolbar can use UIResponder methods.

-(BOOL)resignFirstResponder
{
	if (![textWidgetView isFirstResponder])
	{
		return NO;
	}
	return [[self textWidgetView] resignFirstResponder];
}

-(BOOL)becomeFirstResponder
{
	if ([textWidgetView isFirstResponder])
	{
		return NO;
	}
	
	return [[self textWidgetView] becomeFirstResponder];
}

-(BOOL)isFirstResponder
{
	return [textWidgetView isFirstResponder];
}

-(void)setPasswordMask_:(id)value
{
	[[self textWidgetView] setSecureTextEntry:[TiUtils boolValue:value]];
}

-(void)setAppearance_:(id)value
{
	[[self textWidgetView] setKeyboardAppearance:[TiUtils intValue:value]];
}

-(void)setAutocapitalization_:(id)value
{
	[[self textWidgetView] setAutocapitalizationType:[TiUtils intValue:value]];
}

-(void)setValue_:(id)text
{
	[(id)[self textWidgetView] setText:[TiUtils stringValue:text]];
}

#pragma mark Keyboard Delegates

-(void)textWidget:(UIView<UITextInputTraits>*)tw didFocusWithText:(NSString *)value
{
	TiViewProxy * ourProxy = (TiViewProxy *)[self proxy];
	[[TiApp controller] didKeyboardFocusOnProxy:(TiViewProxy<TiKeyboardFocusableView> *)ourProxy];

	if ([ourProxy _hasListeners:@"focus"])
	{
		[ourProxy fireEvent:@"focus" withObject:[NSDictionary dictionaryWithObject:value forKey:@"value"] propagate:NO];
	}
}

-(void)textWidget:(UIView<UITextInputTraits>*)tw didBlurWithText:(NSString *)value
{
	TiViewProxy * ourProxy = (TiViewProxy *)[self proxy];

	[[TiApp controller] didKeyboardBlurOnProxy:(TiViewProxy<TiKeyboardFocusableView> *)ourProxy];

	if ([ourProxy _hasListeners:@"blur"])
	{
		[ourProxy fireEvent:@"blur" withObject:[NSDictionary dictionaryWithObject:value forKey:@"value"] propagate:NO];
	}
	
	// In order to capture gestures properly, we need to force the root view to become the first responder.
	[self makeRootViewFirstResponder];
}

@end

#endif