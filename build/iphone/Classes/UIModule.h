/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */
#import "TiModule.h"

#ifdef USE_TI_UI

// because alert is linked in Kroll and the user can use that
// in their code instead of the full API, we need to create
// an explicit compile time dependency to UI
#import "TiUIAlertDialogProxy.h"

@interface UIModule : TiModule {

@private
#ifdef USE_TI_UIIPHONE
	TiProxy *iphone;
#endif
#ifdef USE_TI_UIIPAD
	TiProxy *ipad;
#endif
#ifdef USE_TI_UIIOS
	TiProxy *ios;
#endif
#ifdef USE_TI_UICLIPBOARD	
	TiProxy *clipboard;
#endif
}

//TODO: review these, maybe they need to go on iPhone Animation Style - however, they are platform generic

@property(nonatomic,readonly) NSNumber *ANIMATION_CURVE_EASE_IN_OUT;
@property(nonatomic,readonly) NSNumber *ANIMATION_CURVE_EASE_IN;
@property(nonatomic,readonly) NSNumber *ANIMATION_CURVE_EASE_OUT;
@property(nonatomic,readonly) NSNumber *ANIMATION_CURVE_LINEAR;

@property(nonatomic,readonly) NSNumber *TEXT_ALIGNMENT_LEFT;
@property(nonatomic,readonly) NSNumber *TEXT_ALIGNMENT_CENTER;
@property(nonatomic,readonly) NSNumber *TEXT_ALIGNMENT_RIGHT;

@property(nonatomic,readonly) NSNumber *TEXT_VERTICAL_ALIGNMENT_TOP;
@property(nonatomic,readonly) NSNumber *TEXT_VERTICAL_ALIGNMENT_CENTER;
@property(nonatomic,readonly) NSNumber *TEXT_VERTICAL_ALIGNMENT_BOTTOM;

@property(nonatomic,readonly) NSNumber *RETURNKEY_DEFAULT;
@property(nonatomic,readonly) NSNumber *RETURNKEY_GO;
@property(nonatomic,readonly) NSNumber *RETURNKEY_GOOGLE;
@property(nonatomic,readonly) NSNumber *RETURNKEY_JOIN;
@property(nonatomic,readonly) NSNumber *RETURNKEY_NEXT;
@property(nonatomic,readonly) NSNumber *RETURNKEY_ROUTE;
@property(nonatomic,readonly) NSNumber *RETURNKEY_SEARCH;
@property(nonatomic,readonly) NSNumber *RETURNKEY_SEND;
@property(nonatomic,readonly) NSNumber *RETURNKEY_YAHOO;
@property(nonatomic,readonly) NSNumber *RETURNKEY_DONE;
@property(nonatomic,readonly) NSNumber *RETURNKEY_EMERGENCY_CALL;

@property(nonatomic,readonly) NSNumber *KEYBOARD_DEFAULT;
@property(nonatomic,readonly) NSNumber *KEYBOARD_ASCII;
@property(nonatomic,readonly) NSNumber *KEYBOARD_NUMBERS_PUNCTUATION;
@property(nonatomic,readonly) NSNumber *KEYBOARD_URL;
@property(nonatomic,readonly) NSNumber *KEYBOARD_NUMBER_PAD;
@property(nonatomic,readonly) NSNumber *KEYBOARD_DECIMAL_PAD;
@property(nonatomic,readonly) NSNumber *KEYBOARD_PHONE_PAD;
@property(nonatomic,readonly) NSNumber *KEYBOARD_NAMEPHONE_PAD;
@property(nonatomic,readonly) NSNumber *KEYBOARD_EMAIL;

@property(nonatomic,readonly) NSNumber *KEYBOARD_APPEARANCE_DEFAULT;
@property(nonatomic,readonly) NSNumber *KEYBOARD_APPEARANCE_ALERT;

@property(nonatomic,readonly) NSNumber *TEXT_AUTOCAPITALIZATION_NONE;
@property(nonatomic,readonly) NSNumber *TEXT_AUTOCAPITALIZATION_WORDS;
@property(nonatomic,readonly) NSNumber *TEXT_AUTOCAPITALIZATION_SENTENCES;
@property(nonatomic,readonly) NSNumber *TEXT_AUTOCAPITALIZATION_ALL;

@property(nonatomic,readonly) NSNumber *INPUT_BUTTONMODE_NEVER;
@property(nonatomic,readonly) NSNumber *INPUT_BUTTONMODE_ALWAYS;
@property(nonatomic,readonly) NSNumber *INPUT_BUTTONMODE_ONFOCUS;
@property(nonatomic,readonly) NSNumber *INPUT_BUTTONMODE_ONBLUR;

@property(nonatomic,readonly) NSNumber *INPUT_BORDERSTYLE_NONE;
@property(nonatomic,readonly) NSNumber *INPUT_BORDERSTYLE_LINE;
@property(nonatomic,readonly) NSNumber *INPUT_BORDERSTYLE_BEZEL;
@property(nonatomic,readonly) NSNumber *INPUT_BORDERSTYLE_ROUNDED;

@property(nonatomic,readonly) NSNumber *PORTRAIT;
@property(nonatomic,readonly) NSNumber *LANDSCAPE_LEFT;
@property(nonatomic,readonly) NSNumber *LANDSCAPE_RIGHT;
@property(nonatomic,readonly) NSNumber *UPSIDE_PORTRAIT;
@property(nonatomic,readonly) NSNumber *UNKNOWN;
@property(nonatomic,readonly) NSNumber *FACE_UP;
@property(nonatomic,readonly) NSNumber *FACE_DOWN;

@property(nonatomic,readonly) NSNumber *PICKER_TYPE_PLAIN;
@property(nonatomic,readonly) NSNumber *PICKER_TYPE_DATE_AND_TIME;
@property(nonatomic,readonly) NSNumber *PICKER_TYPE_DATE;
@property(nonatomic,readonly) NSNumber *PICKER_TYPE_TIME;
@property(nonatomic,readonly) NSNumber *PICKER_TYPE_COUNT_DOWN_TIMER;

@property(nonatomic,readonly) NSNumber *BLEND_MODE_NORMAL;
@property(nonatomic,readonly) NSNumber *BLEND_MODE_MULTIPLY;
@property(nonatomic,readonly) NSNumber *BLEND_MODE_SCREEN;
@property(nonatomic,readonly) NSNumber *BLEND_MODE_OVERLAY;
@property(nonatomic,readonly) NSNumber *BLEND_MODE_DARKEN;
@property(nonatomic,readonly) NSNumber *BLEND_MODE_LIGHTEN;
@property(nonatomic,readonly) NSNumber *BLEND_MODE_COLOR_DODGE;
@property(nonatomic,readonly) NSNumber *BLEND_MODE_COLOR_BURN;
@property(nonatomic,readonly) NSNumber *BLEND_MODE_SOFT_LIGHT;
@property(nonatomic,readonly) NSNumber *BLEND_MODE_HARD_LIGHT;
@property(nonatomic,readonly) NSNumber *BLEND_MODE_DIFFERENCE;
@property(nonatomic,readonly) NSNumber *BLEND_MODE_EXCLUSION;
@property(nonatomic,readonly) NSNumber *BLEND_MODE_HUE;
@property(nonatomic,readonly) NSNumber *BLEND_MODE_SATURATION;
@property(nonatomic,readonly) NSNumber *BLEND_MODE_COLOR;
@property(nonatomic,readonly) NSNumber *BLEND_MODE_LUMINOSITY;
@property(nonatomic,readonly) NSNumber *BLEND_MODE_CLEAR;
@property(nonatomic,readonly) NSNumber *BLEND_MODE_COPY;
@property(nonatomic,readonly) NSNumber *BLEND_MODE_SOURCE_IN;
@property(nonatomic,readonly) NSNumber *BLEND_MODE_SOURCE_OUT;
@property(nonatomic,readonly) NSNumber *BLEND_MODE_SOURCE_ATOP;
@property(nonatomic,readonly) NSNumber *BLEND_MODE_DESTINATION_OVER;
@property(nonatomic,readonly) NSNumber *BLEND_MODE_DESTINATION_IN;
@property(nonatomic,readonly) NSNumber *BLEND_MODE_DESTINATION_OUT;
@property(nonatomic,readonly) NSNumber *BLEND_MODE_DESTINATION_ATOP;
@property(nonatomic,readonly) NSNumber *BLEND_MODE_XOR;
@property(nonatomic,readonly) NSNumber *BLEND_MODE_PLUS_DARKER;
@property(nonatomic,readonly) NSNumber *BLEND_MODE_PLUS_LIGHTER;

@property(nonatomic,readonly) NSNumber *AUTODETECT_NONE;
@property(nonatomic,readonly) NSNumber *AUTODETECT_ALL;
@property(nonatomic,readonly) NSNumber *AUTODETECT_PHONE;
@property(nonatomic,readonly) NSNumber *AUTODETECT_LINK;
@property(nonatomic,readonly) NSNumber *AUTODETECT_ADDRESS;
@property(nonatomic,readonly) NSNumber *AUTODETECT_CALENDAR;



#ifdef USE_TI_UI2DMATRIX
-(id)create2DMatrix:(id)args;
#endif

#ifdef USE_TI_UIANIMATION
-(id)createAnimation:(id)args;
#endif

#ifdef USE_TI_UIIPHONE
@property(nonatomic,readonly)			TiProxy* iPhone;
#endif

#ifdef USE_TI_UIIPAD
@property(nonatomic,readonly)			TiProxy* iPad;
#endif

#ifdef USE_TI_UIIOS
@property(nonatomic,readonly)			TiProxy* iOS;
#endif

#ifdef USE_TI_UICLIPBOARD
@property(nonatomic,readonly)			TiProxy* Clipboard;
#endif

@end


#endif