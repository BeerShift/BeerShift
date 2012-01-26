/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */
#ifdef USE_TI_UITABLEVIEW

#import "TiUIView.h"
#import "TiUITableViewRowProxy.h"
#import "TiUITableViewSectionProxy.h"
#import "TiUITableViewAction.h"
#import "TiUISearchBarProxy.h"
#import "TiDimension.h"

@class TiGradientLayer;

// Overloads hilighting to send touchbegin/touchend events
@interface TiUITableViewCell : UITableViewCell
{
	TiUITableViewRowProxy* proxy;
	TiGradientLayer * gradientLayer;
	TiGradient * backgroundGradient;
	TiGradient * selectedBackgroundGradient;
	CGPoint hitPoint;
}
@property (nonatomic,readonly) CGPoint hitPoint;
@property (nonatomic,readwrite,retain) TiUITableViewRowProxy* proxy;

-(id)initWithStyle:(UITableViewCellStyle)style_ reuseIdentifier:(NSString *)reuseIdentifier_ row:(TiUITableViewRowProxy*)row_;

-(void)handleEvent:(NSString*)type;

-(void) setBackgroundGradient_:(TiGradient *)newGradient;
-(void) setSelectedBackgroundGradient_:(TiGradient *)newGradient;

-(void) updateGradientLayer:(BOOL)useSelected;
-(CGSize)computeCellSize;

@end

@interface TiUITableView : TiUIView<UISearchDisplayDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,TiUIScrollView> {
@private
	UITableView *tableview;
	BOOL moving;
	BOOL editing;
	BOOL searchHidden;
	BOOL editable;
	BOOL moveable;
	BOOL initiallyDisplayed;
	NSIndexPath *initialSelection;
	NSMutableArray * sectionIndex;
	NSMutableDictionary * sectionIndexMap;
	TiDimension rowHeight;
	TiDimension minRowHeight;
	TiDimension maxRowHeight;
	TiUISearchBarProxy * searchField;
	UIView * tableHeaderView;
	UIView * tableHeaderPullView;
	UIButton * searchScreenView;
	NSString * filterAttribute;
	NSString * searchString;
	NSMutableArray * searchResultIndexes;
	BOOL filterCaseInsensitive;
	BOOL allowsSelectionSet;
	id	lastFocusedView; //DOES NOT RETAIN.	
	UITableViewController *tableController;
	UISearchDisplayController *searchController;
	BOOL searchHiddenSet;
	NSInteger frameChanges;
}

#pragma mark Framework
-(CGFloat)tableRowHeight:(CGFloat)height;
-(NSInteger)indexForRow:(TiUITableViewRowProxy*)row;
-(TiUITableViewRowProxy*)rowForIndex:(NSInteger)index section:(NSInteger*)section;
-(void)updateSearchView;
-(void)replaceData:(NSArray*)data animation:(UITableViewRowAnimation)animation;

-(void)dispatchAction:(TiUITableViewAction*)action;
-(void)scrollToIndex:(NSInteger)index position:(UITableViewScrollPosition)position animated:(BOOL)animated;
-(void)scrollToTop:(NSInteger)top animated:(BOOL)animated;
-(NSIndexPath*)indexPathFromSearchIndex:(int)index;
-(IBAction)hideSearchScreen:(id)sender;
-(UITableView*)tableView;
-(CGFloat)tableRowHeight:(CGFloat)height;

@end

#endif