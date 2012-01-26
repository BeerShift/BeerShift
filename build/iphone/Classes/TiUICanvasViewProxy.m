/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */
#ifdef USE_TI_UICANVAS

#import "TiUICanvasViewProxy.h"
#import "TiUICanvasView.h"

@implementation TiUICanvasViewProxy

-(void)begin:(id)args
{
	TiUICanvasView *canvas = (TiUICanvasView*)[self view];
	[canvas begin];
}

-(void)commit:(id)args
{
	TiUICanvasView *canvas = (TiUICanvasView*)[self view];
	[canvas commit];
}


@end

#endif