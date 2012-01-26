/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2011 by BeerShift, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */

#import "TiViewProxy.h"

@protocol TiUIViewController

@required

- (UIViewController *)childViewController;

- (void)viewWillAppear:(BOOL)animated;    // Called when the view is about to made visible. Default does nothing
- (void)viewDidAppear:(BOOL)animated;     // Called when the view has been fully transitioned onto the screen. Default does nothing
- (void)viewWillDisappear:(BOOL)animated; // Called when the view is dismissed, covered or otherwise hidden. Default does nothing
- (void)viewDidDisappear:(BOOL)animated;  // Called after the view was dismissed, covered or otherwise hidden. Default does nothing

@optional

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;

-(void)ignoringRotationToOrientation:(UIInterfaceOrientation)orientation;

@end


@interface TiViewController : UIViewController
{
	TiViewProxy<TiUIViewController> *proxy;
}
-(id)initWithViewProxy:(TiViewProxy<TiUIViewController>*)window;
@property(nonatomic,readwrite,assign)	TiViewProxy<TiUIViewController> *proxy;
@end
