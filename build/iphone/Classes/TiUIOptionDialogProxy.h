/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */
#ifdef USE_TI_UIOPTIONDIALOG

#import "TiProxy.h"
@class TiViewProxy;

@interface TiUIOptionDialogProxy : TiProxy<UIActionSheetDelegate> {

	UIActionSheet *actionSheet;
//We need to hold onto this information for whenever the status bar rotates.
	TiViewProxy *dialogView;
	CGRect dialogRect;
	BOOL animated;

}

@property(nonatomic,retain,readwrite)	TiViewProxy *dialogView;

-(void)updateOptionDialog:(NSNotification *)notification;
-(void)updateOptionDialogNow;

@end

#endif