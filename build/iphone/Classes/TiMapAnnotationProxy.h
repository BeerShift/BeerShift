/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */
#import "TiBase.h"

#ifdef USE_TI_MAP

#import "TiViewProxy.h"
#import <MapKit/MapKit.h>

@class TiMapView;

@interface TiMapAnnotationProxy : TiViewProxy<MKAnnotation> {
@private
	int tag;
	TiMapView *delegate;
	BOOL needsRefreshing;
	BOOL needsRefreshingWithSelection;
	BOOL placed;
}

// Center latitude and longitude of the annotion view.
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readwrite, assign) TiMapView *delegate;
@property (nonatomic,readonly)	BOOL needsRefreshingWithSelection;
@property (nonatomic, readwrite, assign) BOOL placed;

// Title and subtitle for use by selection UI.
- (NSString *)title;
- (NSString *)subtitle;

- (MKPinAnnotationColor)pinColor;
- (BOOL)animatesDrop;

- (UIView*)leftViewAccessory;
- (UIView*)rightViewAccessory;

- (int)tag;

@end

#endif