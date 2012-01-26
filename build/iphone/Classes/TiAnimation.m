/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */
#import "TiAnimation.h"
#import "Ti2DMatrix.h"
#import "TiUIiOS3DMatrix.h"
#import "TiUtils.h"
#import "TiViewProxy.h"
#import "LayoutConstraint.h"
#import "KrollCallback.h"

#import <QuartzCore/QuartzCore.h>

#ifdef DEBUG 
	#define ANIMATION_DEBUG 0
#endif


@implementation TiAnimation

@synthesize delegate;
@synthesize zIndex, left, right, top, bottom, width, height;
@synthesize duration, color, backgroundColor, opacity, opaque, view;
@synthesize visible, curve, repeat, autoreverse, delay, transform, transition;
@synthesize animatedView, autoreverseView, autoreverseLayout, transformMatrix, callback;

-(id)initWithDictionary:(NSDictionary*)properties context:(id<TiEvaluator>)context_ callback:(KrollCallback*)callback_
{
	if (self = [super _initWithPageContext:context_])
	{
#define SET_FLOAT_PROP(p,d) \
{\
id v = d==nil ? nil : [d objectForKey:@#p];\
if (v!=nil && ![v isKindOfClass:[NSNull class]]) {\
 self.p = [NSNumber numberWithFloat:[TiUtils floatValue:v]];\
}\
}\

#define SET_INT_PROP(p,d) \
{\
id v = d==nil ? nil : [d objectForKey:@#p];\
if (v!=nil && ![v isKindOfClass:[NSNull class]]) {\
self.p = [NSNumber numberWithInt:[TiUtils intValue:v]];\
}\
}\

#define SET_BOOL_PROP(p,d) \
{\
id v = d==nil ? nil : [d objectForKey:@#p];\
if (v!=nil && ![v isKindOfClass:[NSNull class]]) {\
self.p = [NSNumber numberWithBool:[TiUtils boolValue:v]];\
}\
}\

#define SET_POINT_PROP(p,d) \
{\
id v = d==nil ? nil : [d objectForKey:@#p];\
if (v!=nil && ![v isKindOfClass:[NSNull class]]) {\
self.p = [[[TiPoint alloc] initWithPoint:[TiUtils pointValue:v]] autorelease];\
}\
}\

#define SET_COLOR_PROP(p,d) \
{\
id v = d==nil ? nil : [d objectForKey:@#p];\
if (v!=nil && ![v isKindOfClass:[NSNull class]]) {\
self.p = [TiUtils colorValue:v];\
}\
}\

#define SET_ID_PROP(p,d) \
{\
id v = d==nil ? nil : [d objectForKey:@#p];\
if (v!=nil && ![v isKindOfClass:[NSNull class]]) {\
self.p = v;\
}\
}\

#define SET_PROXY_PROP(p,d) \
{\
id v = d==nil ? nil : [d objectForKey:@#p];\
if (v!=nil && ![v isKindOfClass:[NSNull class]]) {\
self.p = v;\
}\
}\

		
		SET_FLOAT_PROP(zIndex,properties);
		SET_FLOAT_PROP(left,properties);
		SET_FLOAT_PROP(right,properties);
		SET_FLOAT_PROP(top,properties);
		SET_FLOAT_PROP(bottom,properties);
		SET_FLOAT_PROP(width,properties);
		SET_FLOAT_PROP(height,properties);
		SET_FLOAT_PROP(duration,properties);
		SET_FLOAT_PROP(opacity,properties);
		SET_FLOAT_PROP(delay,properties);
		SET_INT_PROP(curve,properties);
		SET_INT_PROP(repeat,properties);
		SET_BOOL_PROP(visible,properties);
		SET_BOOL_PROP(opaque,properties);
		SET_BOOL_PROP(autoreverse,properties);
		SET_POINT_PROP(center,properties);
		SET_COLOR_PROP(backgroundColor,properties);
		SET_COLOR_PROP(color,properties);
		SET_ID_PROP(transform,properties);
		SET_INT_PROP(transition,properties);
		SET_PROXY_PROP(view,properties);

		if (context_!=nil)
		{
			callback = [[ListenerEntry alloc] initWithListener:callback_ context:context_ proxy:self];
		}
	}
	return self;
}

-(id)initWithDictionary:(NSDictionary*)properties context:(id<TiEvaluator>)context_
{
	if (self = [self initWithDictionary:properties context:context_ callback:nil])
	{
	}
	return self;
}


-(void)dealloc
{
	RELEASE_TO_NIL(zIndex);
	RELEASE_TO_NIL(left);
	RELEASE_TO_NIL(right);
	RELEASE_TO_NIL(top);
	RELEASE_TO_NIL(bottom);
	RELEASE_TO_NIL(width);
	RELEASE_TO_NIL(height);
	RELEASE_TO_NIL(duration);
	RELEASE_TO_NIL(center);
	RELEASE_TO_NIL(color);
	RELEASE_TO_NIL(backgroundColor);
	RELEASE_TO_NIL(opacity);
	RELEASE_TO_NIL(opaque);
	RELEASE_TO_NIL(visible);
	RELEASE_TO_NIL(curve);
	RELEASE_TO_NIL(repeat);
	RELEASE_TO_NIL(autoreverse);
	RELEASE_TO_NIL(delay);
	RELEASE_TO_NIL(transform);
	RELEASE_TO_NIL(transition);
	RELEASE_TO_NIL(callback);
	RELEASE_TO_NIL(view);
	RELEASE_TO_NIL(autoreverseView);
	RELEASE_TO_NIL(transformMatrix);
	RELEASE_TO_NIL(animatedView);
	[super dealloc];
}

+(TiAnimation*)animationFromArg:(id)args context:(id<TiEvaluator>)context create:(BOOL)yn
{
	id arg = nil;
	BOOL isArray = NO;
	
	if ([args isKindOfClass:[TiAnimation class]])
	{
		return (TiAnimation*)args;
	}
	else if ([args isKindOfClass:[NSArray class]])
	{
		isArray = YES;
		arg = [args objectAtIndex:0];
		if ([arg isKindOfClass:[TiAnimation class]])
		{
			return (TiAnimation*)arg;
		}
	}
	else 
	{
		arg = args;
	}

	if ([arg isKindOfClass:[NSDictionary class]])
	{
		NSDictionary *properties = arg;
		KrollCallback *cb = nil;
		
		if (isArray && [args count] > 1)
		{
			cb = [args objectAtIndex:1];
			ENSURE_TYPE(cb,KrollCallback);
		}
		
		// old school animated type properties
		if ([TiUtils boolValue:@"animated" properties:properties def:NO])
		{
			float duration = [TiUtils floatValue:@"animationDuration" properties:properties def:1000];
			UIViewAnimationTransition transition = [TiUtils intValue:@"animationStyle" properties:properties def:UIViewAnimationTransitionNone];
			TiAnimation *animation = [[[TiAnimation alloc] initWithDictionary:properties context:context callback:cb] autorelease];
			animation.duration = [NSNumber numberWithFloat:duration];
			animation.transition = [NSNumber numberWithInt:transition];
			return animation;
		}
		
		return [[[TiAnimation alloc] initWithDictionary:properties context:context callback:cb] autorelease];
	}
	
	if (yn)
	{
		return [[[TiAnimation alloc] _initWithPageContext:context] autorelease];
	}
	return nil;
}

-(void)setCenter:(id)center_
{
    if (center != center_) {
        [center release];
        center = [[TiPoint alloc] initWithPoint:[TiUtils pointValue:center_]];
    }
}

-(TiPoint*)center
{
    return center;
}

-(id)description
{
	return [NSString stringWithFormat:@"[object TiAnimation<%d>]",[self hash]];
}

-(void)animationStarted:(NSString *)animationID context:(void *)context
{
#if ANIMATION_DEBUG==1	
	NSLog(@"ANIMATION: STARTING %@, %@",self,(id)context);
#endif
	
	TiAnimation* animation = (TiAnimation*)context;
	if (animation.delegate!=nil && [animation.delegate respondsToSelector:@selector(animationDidStart:)])
	{
		[animation.delegate performSelector:@selector(animationDidStart:) withObject:animation];
	}
	
	// fire the event to any listeners on the animation object
	if ([animation _hasListeners:@"start"])
	{
		[animation fireEvent:@"start" withObject:nil];
	}
}

-(void)animationCompleted:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
#if ANIMATION_DEBUG==1	
	NSLog(@"ANIMATION: COMPLETED %@, %@",self,(id)context);
#endif
	
	TiAnimation* animation = (TiAnimation*)context;
	if (animation.autoreverseView!=nil)
	{
#define REVERSE_LAYOUT_CHANGE(a) \
{\
if (!TiDimensionIsUndefined(autoreverseLayout.a)) {\
		newLayout->a = animation.autoreverseLayout.a;\
}\
}
		if (animation.transformMatrix==nil)
		{
			animation.transformMatrix = [[Ti2DMatrix alloc] init];
		}
		[animation.autoreverseView performSelector:@selector(setTransform_:) withObject:animation.transformMatrix];
		LayoutConstraint* newLayout = [(TiViewProxy *)[(TiUIView*)animation.autoreverseView proxy] layoutProperties];
		REVERSE_LAYOUT_CHANGE(left);
		REVERSE_LAYOUT_CHANGE(right);
		REVERSE_LAYOUT_CHANGE(width);
		REVERSE_LAYOUT_CHANGE(height);
		REVERSE_LAYOUT_CHANGE(top);
		REVERSE_LAYOUT_CHANGE(bottom);
		[(TiViewProxy*)[(TiUIView*)animation.autoreverseView proxy] reposition];
		
		RELEASE_TO_NIL(animation.transformMatrix);
		RELEASE_TO_NIL(animation.autoreverseView);
	}
	
	if (animation.delegate!=nil && [animation.delegate respondsToSelector:@selector(animationWillComplete:)])
	{
		[animation.delegate animationWillComplete:self];
	}	
	
	// fire the event and call the callback
	if ([animation _hasListeners:@"complete"])
	{
		[animation fireEvent:@"complete" withObject:nil];
	}
	
	if (animation.callback!=nil && [animation.callback context]!=nil)
	{
		[animation _fireEventToListener:@"animated" withObject:animation listener:[animation.callback listener] thisObject:nil];
	}
	
	// tell our view that we're done
	if ([(id)animation.animatedView isKindOfClass:[TiUIView class]])
	{
		TiUIView *v = (TiUIView*)animation.animatedView;
		[(TiViewProxy*)v.proxy animationCompleted:animation];
	}
	
	if (animation.delegate!=nil && [animation.delegate respondsToSelector:@selector(animationDidComplete:)])
	{
		[animation.delegate animationDidComplete:animation];
	}	
	
	RELEASE_TO_NIL(animation.animatedView);
	[animation release];
}

-(BOOL)isTransitionAnimation
{
	if (transition!=nil)
	{
		UIViewAnimationTransition t = [transition intValue];
		if (t!=0 && t!=UIViewAnimationTransitionNone)
		{
			return YES;
		}
	}
	return NO;
}

-(void)animate:(id)args
{
	ENSURE_UI_THREAD(animate,args);

#if ANIMATION_DEBUG==1
	NSLog(@"ANIMATION: starting %@, %@, retain: %d",self,args,[self retainCount]);
#endif
	
	UIView *theview = nil;
	
	if ([args isKindOfClass:[NSArray class]])
	{
		//
		// this is something like:
		//
		// animation.animate(view)
		//
		// vs.
		//
		// view.animate(animation)
		// 
		// which is totally fine, just hand it to the view and let him callback
		//
		theview = [args objectAtIndex:0];
		ENSURE_TYPE(theview,TiViewProxy);
		[(TiViewProxy*)theview animate:[NSArray arrayWithObject:self]];
		return;
	}
	else if ([args isKindOfClass:[TiViewProxy class]])
	{
		// called by the view to cause himself to be animated
		theview = args;
	}
	else if ([args isKindOfClass:[UIView class]])
	{
		// this is OK too
		theview = args;
	}
	
	BOOL transitionAnimation = [self isTransitionAnimation];
	
	TiUIView *view_ = transitionAnimation && view!=nil ? [view view] : [theview isKindOfClass:[TiViewProxy class]] ? [(TiViewProxy*)theview view] : (TiUIView *)theview;
	TiUIView *transitionView = transitionAnimation ? [theview isKindOfClass:[TiViewProxy class]] ? (TiUIView*)[(TiViewProxy*)theview view] : (TiUIView*)theview : nil;
	
	if (transitionView!=nil)
	{
		// we need to first make sure our new view that we're transitioning to is sized but we don't want
		// to add to the view hiearchry inside the animation block or you'll get the sizings as part of the
		// animation.. which we don't want
		TiViewProxy * ourProxy = (TiViewProxy*)[view_ proxy];
		LayoutConstraint *contraints = [ourProxy layoutProperties];
		ApplyConstraintToViewWithBounds(contraints, view_, transitionView.bounds);
		[ourProxy layoutChildren:NO];
	}
	else
	{
		CALayer * modelLayer = [view_ layer];
		CALayer * transitionLayer = [modelLayer presentationLayer];
		NSArray * animationKeys = [transitionLayer animationKeys];
		for (NSString * thisKey in animationKeys)
		{
			[modelLayer setValue:[transitionLayer valueForKey:thisKey] forKey:thisKey];
		}
	}


	// hold on to our animation during the animation and until it stops
	[self retain];
	[theview retain];
	
	animatedView = theview;
	// Have to pass self as context because if there are two or more animations going on, the wrong
	// autoreverse cleanup/view release may be applied to the animation.
	[UIView beginAnimations:[NSString stringWithFormat:@"%X",(void *)theview] context:(void*)self];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationWillStartSelector:@selector(animationStarted:context:)];
	[UIView setAnimationDidStopSelector:@selector(animationCompleted:finished:context:)];
	
	if (duration!=nil)
	{
		[UIView setAnimationDuration:[duration doubleValue]/1000];
	}
	else 
	{
		// set a reasonable small default if the developer doesn't specify one such that
		// you can do animations quickly such as during drag and drop
		[UIView setAnimationDuration: (transitionAnimation ? 1 : 0.2)];
	}
	
	BOOL autoreverses = NO;
	
	if (curve!=nil)
	{
		[UIView setAnimationCurve:[curve intValue]];
	}
	
	if (repeat!=nil)
	{
		[UIView setAnimationRepeatCount:[repeat intValue]];
	}
	
	if (autoreverse!=nil)
	{	
		autoreverses = [autoreverse boolValue];
		if (autoreverseView==nil)
		{
			autoreverseView = [view_ retain];
		}
		[UIView setAnimationRepeatAutoreverses:autoreverses];
	}
	
	if (delay!=nil)
	{
		[UIView setAnimationDelay:[delay doubleValue]/1000];
	}
	
	// NOTE: this *must* be called after the animation is setup, otherwise,
	// the attributes above won't be set in anything you do in the start
	if (delegate!=nil && [delegate respondsToSelector:@selector(animationWillStart:)])
	{
		[delegate animationWillStart:self];
	}
	
	if (transform!=nil)
	{
		if (autoreverses)
		{
			transformMatrix = [[(TiUIView*)view_ transformMatrix] retain];
		}
		
		[(TiUIView *)view_ setTransform_:transform];
	}
	
	if ([view_ isKindOfClass:[TiUIView class]])
	{	//TODO: Shouldn't we be updating the proxy's properties to reflect this?
		TiUIView *uiview = (TiUIView*)view_;
		LayoutConstraint *layoutProperties = [(TiViewProxy *)[uiview proxy] layoutProperties];
		

		BOOL doReposition = NO;
		
#define CHECK_LAYOUT_CHANGE(a) \
if (a!=nil && layoutProperties!=NULL) \
{\
		autoreverseLayout.a = layoutProperties->a; \
		layoutProperties->a = TiDimensionFromObject(a); \
		doReposition = YES;\
}\
else \
{\
		autoreverseLayout.a = TiDimensionUndefined; \
}
		CHECK_LAYOUT_CHANGE(left);
		CHECK_LAYOUT_CHANGE(right);
		CHECK_LAYOUT_CHANGE(width);
		CHECK_LAYOUT_CHANGE(height);
		CHECK_LAYOUT_CHANGE(top);
		CHECK_LAYOUT_CHANGE(bottom);
		if (center!=nil && layoutProperties != NULL)
		{
			autoreverseLayout.centerX = layoutProperties->centerX;
			autoreverseLayout.centerY = layoutProperties->centerY;
			layoutProperties->centerX = [center xDimension];
			layoutProperties->centerY = [center yDimension];
			doReposition = YES;
		}
		else
		{
			autoreverseLayout.centerX = TiDimensionUndefined;
			autoreverseLayout.centerY = TiDimensionUndefined;
		}


		if (zIndex!=nil)
		{
			[(TiViewProxy *)[uiview proxy] setZIndex:[zIndex intValue]];
		}
		
		if (doReposition)
		{
			[(TiViewProxy *)[uiview proxy] reposition];
		}
	}

	if (backgroundColor!=nil)
	{
		TiColor *color_ = [TiUtils colorValue:backgroundColor];
		[view_ setBackgroundColor:[color_ _color]];
	}
	
	if (color!=nil && [view_ respondsToSelector:@selector(setColor_:)])
	{
		[view_ performSelector:@selector(setColor_:) withObject:color];
	}
	
	if (opacity!=nil)
	{
		view_.alpha = [opacity floatValue];
	}
	
	if (opaque!=nil)
	{
		view_.opaque = [opaque boolValue];
	}
	
	if (visible!=nil)
	{
		view_.hidden = ![visible boolValue];
	}
	
	// check to see if this is a transition
	if (transitionAnimation)
	{
		BOOL perform = YES;
		
		// allow a delegate to control transitioning
		if (delegate!=nil && [delegate respondsToSelector:@selector(animationShouldTransition:)])
		{
			perform = [delegate animationShouldTransition:self];
		}
		if (perform)
		{
			[UIView setAnimationTransition:[transition intValue]
								   forView:transitionView
									 cache:NO]; //TODO: might need to make cache configurable
			
			// transitions are between 2 views so we need to remove existing views (normally only one)
			// and then we need to add our new view
			for (UIView *subview in [transitionView subviews])
			{
				if (subview != view_) {
					[subview removeFromSuperview];
				}
			}
			[transitionView addSubview:view_];
		}
	}
	
	[UIView commitAnimations];
	
#if ANIMATION_DEBUG==1	
	NSLog(@"ANIMATION: committed %@, %@",self,args);
#endif
}

@end
