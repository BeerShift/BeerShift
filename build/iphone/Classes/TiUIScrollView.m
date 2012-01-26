/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */
#ifdef USE_TI_UISCROLLVIEW

#import "TiUIScrollView.h"
#import "TiUIScrollViewProxy.h"
#import "TiUtils.h"

@implementation TiUIScrollView

- (void) dealloc
{
	RELEASE_TO_NIL(wrapperView);
	RELEASE_TO_NIL(scrollView);
	[super dealloc];
}

-(UIView *)wrapperView
{
	if (wrapperView == nil)
	{
		CGRect wrapperFrame;
		wrapperFrame.size = [[self scrollView] contentSize];
		wrapperFrame.origin = CGPointZero;
		wrapperView = [[UIView alloc] initWithFrame:wrapperFrame];
		[wrapperView setUserInteractionEnabled:YES];
		[scrollView addSubview:wrapperView];
	}
	return wrapperView;
}

-(UIScrollView *)scrollView
{
	if(scrollView == nil)
	{
		scrollView = [[UIScrollView alloc] initWithFrame:[self bounds]];
		[scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
		[scrollView setBackgroundColor:[UIColor clearColor]];
		[scrollView setShowsHorizontalScrollIndicator:NO];
		[scrollView setShowsVerticalScrollIndicator:NO];
		[scrollView setDelegate:self];
		[self addSubview:scrollView];
	}
	return scrollView;
}

-(void)setNeedsHandleContentSizeIfAutosizing
{
	if (TiDimensionIsAuto(contentWidth) || TiDimensionIsAuto(contentHeight))
	{
		[self setNeedsHandleContentSize];
	}
}

-(void)setNeedsHandleContentSize
{
	if (!needsHandleContentSize)
	{
		needsHandleContentSize = YES;
		[self performSelectorOnMainThread:@selector(handleContentSize) withObject:nil waitUntilDone:NO];
	}
}


-(BOOL)handleContentSizeIfNeeded
{
	if (needsHandleContentSize)
	{
		[self handleContentSize];
		return YES;
	}
	return NO;
}

-(void)handleContentSize
{
	CGSize newContentSize = [self bounds].size;
	CGFloat scale = [scrollView zoomScale];

	switch (contentWidth.type)
	{
		case TiDimensionTypePixels:
		{
			newContentSize.width = MAX(newContentSize.width,contentWidth.value);
			break;
		}
		case TiDimensionTypeAuto:
		{
			newContentSize.width = MAX(newContentSize.width,[(TiViewProxy *)[self proxy] autoWidthForWidth:0.0]);
			break;
		}
		default: {
			break;
		}
	}

	switch (contentHeight.type)
	{
		case TiDimensionTypePixels:
		{
			minimumContentHeight = contentHeight.value;
			break;
		}
		case TiDimensionTypeAuto:
		{
			minimumContentHeight=[(TiViewProxy *)[self proxy] autoHeightForWidth:newContentSize.width];
			break;
		}
		default:
			minimumContentHeight = newContentSize.height;
			break;
	}
	newContentSize.width *= scale;
	newContentSize.height = scale * MAX(newContentSize.height,minimumContentHeight);

	[scrollView setContentSize:newContentSize];
	CGRect wrapperBounds;
	wrapperBounds.origin = CGPointZero;
	wrapperBounds.size = newContentSize;
	[wrapperView setFrame:wrapperBounds];
	needsHandleContentSize = NO;
	[(TiViewProxy *)[self proxy] layoutChildren:NO];
}

-(void)frameSizeChanged:(CGRect)frame bounds:(CGRect)visibleBounds
{
	//Treat this as a size change
	[(TiViewProxy *)[self proxy] willChangeSize];
}

-(void)setContentWidth_:(id)value
{
	contentWidth = [TiUtils dimensionValue:value];
	[self performSelector:@selector(setNeedsHandleContentSize) withObject:nil afterDelay:.1];
}

-(void)setContentHeight_:(id)value
{
	contentHeight = [TiUtils dimensionValue:value];
	[self performSelector:@selector(setNeedsHandleContentSize) withObject:nil afterDelay:.1];
}

-(void)setShowHorizontalScrollIndicator_:(id)value
{
	[[self scrollView] setShowsHorizontalScrollIndicator:[TiUtils boolValue:value]];
}

-(void)setShowVerticalScrollIndicator_:(id)value
{
	[[self scrollView] setShowsVerticalScrollIndicator:[TiUtils boolValue:value]];
}

-(void)setScrollIndicatorStyle_:(id)value
{
	[[self scrollView] setIndicatorStyle:[TiUtils intValue:value def:UIScrollViewIndicatorStyleDefault]];
}

-(void)setDisableBounce_:(id)value
{
	[[self scrollView] setBounces:![TiUtils boolValue:value]];
}

-(void)setHorizontalBounce_:(id)value
{
	[[self scrollView] setAlwaysBounceHorizontal:[TiUtils boolValue:value]];
}

-(void)setVerticalBounce_:(id)value
{
	[[self scrollView] setAlwaysBounceVertical:[TiUtils boolValue:value]];
}

-(void)setContentOffset_:(id)value
{
	CGPoint newOffset = [TiUtils pointValue:value];
	BOOL animated = scrollView != nil;
	[[self scrollView] setContentOffset:newOffset animated:animated];
}

-(void)setZoomScale_:(id)args
{
	CGFloat scale = [TiUtils floatValue:args];
	[[self scrollView] setZoomScale:scale];
	scale = [[self scrollView] zoomScale]; //Why are we doing this? Because of minZoomScale or maxZoomScale.
	[[self proxy] replaceValue:NUMFLOAT(scale) forKey:@"scale" notification:NO];
	if ([self.proxy _hasListeners:@"scale"])
	{
		[self.proxy fireEvent:@"scale" withObject:[NSDictionary dictionaryWithObjectsAndKeys:
											NUMFLOAT(scale),@"scale",
											nil]];
	}
}

-(void)setMaxZoomScale_:(id)args
{
	[[self scrollView] setMaximumZoomScale:[TiUtils floatValue:args]];
}

-(void)setMinZoomScale_:(id)args
{
	[[self scrollView] setMinimumZoomScale:[TiUtils floatValue:args]];
}

-(void)canCancelEvents_:(id)args
{
	[[self scrollView] setCanCancelContentTouches:[TiUtils boolValue:args def:YES]];
}

#pragma mark scrollView delegate stuff


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView_               // any offset changes
{
	[(id<UIScrollViewDelegate>)[self proxy] scrollViewDidEndDecelerating:scrollView_];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView_               // any offset changes
{
	[(id<UIScrollViewDelegate>)[self proxy] scrollViewDidScroll:scrollView_];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return [self wrapperView];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView_ withView:(UIView *)view atScale:(float)scale 
{
	// scale between minimum and maximum. called after any 'bounce' animations
	[(id<UIScrollViewDelegate>)[self proxy] scrollViewDidEndZooming:scrollView withView:(UIView*)view atScale:scale];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView_  
{
	// Tells the delegate when the scroll view is about to start scrolling the content.
	[(id<UIScrollViewDelegate>)[self proxy] scrollViewWillBeginDragging:scrollView_];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView_ willDecelerate:(BOOL)decelerate
{
	//Tells the delegate when dragging ended in the scroll view.
	[(id<UIScrollViewDelegate>)[self proxy] scrollViewDidEndDragging:scrollView_ willDecelerate:decelerate];
}

#pragma mark Keyboard delegate stuff

-(void)keyboardDidShowAtHeight:(CGFloat)keyboardTop
{
	InsetScrollViewForKeyboard(scrollView,keyboardTop,minimumContentHeight);
}

-(void)scrollToShowView:(TiUIView *)firstResponderView withKeyboardHeight:(CGFloat)keyboardTop
{
	CGRect responderRect = [wrapperView convertRect:[firstResponderView bounds] fromView:firstResponderView];
	OffsetScrollViewForRect(scrollView,keyboardTop,minimumContentHeight,responderRect);
}

-(void)keyboardDidShowAtHeight:(CGFloat)keyboardTop forView:(TiUIView *)firstResponderView
{
	lastFocusedView = firstResponderView;
	CGRect responderRect = [wrapperView convertRect:[firstResponderView bounds] fromView:firstResponderView];
	
	ModifyScrollViewForKeyboardHeightAndContentHeightWithResponderRect(scrollView,keyboardTop,minimumContentHeight,responderRect);
}

@end

#endif