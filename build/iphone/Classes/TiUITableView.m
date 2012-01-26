/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */
#ifdef USE_TI_UITABLEVIEW

#import "TiUITableView.h"
#import "TiUtils.h"
#import "Webcolor.h"
#import "WebFont.h"
#import "ImageLoader.h"
#import "TiProxy.h"
#import "TiViewProxy.h"
#import "TiUITableViewProxy.h"
#import "TiApp.h"
#import "TiLayoutQueue.h"

#define DEFAULT_SECTION_HEADERFOOTER_HEIGHT 20.0

@implementation TiUITableViewCell
@synthesize hitPoint,proxy;
#pragma mark Touch event handling

// TODO: Replace callback cells with blocks by changing fireEvent: to take special-case
// code which will allow better interactions with UIControl elements (such as buttons)
// and table rows/cells.
-(id)initWithStyle:(UITableViewCellStyle)style_ reuseIdentifier:(NSString *)reuseIdentifier_ row:(TiUITableViewRowProxy *)row_
{
	if (self = [super initWithStyle:style_ reuseIdentifier:reuseIdentifier_]) {
		proxy = [row_ retain];
		[proxy setCallbackCell:self];
		self.exclusiveTouch = YES;
	}
	
	return self;
}

-(void)dealloc
{
    [proxy setCallbackCell:nil];
    
    RELEASE_TO_NIL(proxy);
	RELEASE_TO_NIL(gradientLayer);
	RELEASE_TO_NIL(backgroundGradient);
	RELEASE_TO_NIL(selectedBackgroundGradient);
	[super dealloc];
}

-(void)setProxy:(TiUITableViewRowProxy *)proxy_
{
    if (proxy == proxy_) {
        return;
    }
    
    if ([proxy callbackCell] == self) {
        [proxy setCallbackCell:nil];
    }
    [proxy release];
    proxy = [proxy_ retain];
}

-(CGSize)computeCellSize
{
    CGFloat width = 0;
    if ([proxy table] != nil) {
        width = [proxy sizeWidthForDecorations:[[proxy table] tableView].bounds.size.width forceResizing:YES];        
    }
	CGFloat height = [proxy rowHeight:width];
	height = [[proxy table] tableRowHeight:height];
    
    // If there is a separator, then it's included as part of the row height as the system, so remove the pixel for it
    // from our cell size
    if ([[[proxy table] tableView] separatorStyle] == UITableViewCellSeparatorStyleSingleLine) {
        height -= 1;
    }
    
    return CGSizeMake(width, height);
}

-(void)prepareForReuse
{
	[self setProxy:nil];
	[super prepareForReuse];
	
	// TODO: HACK: In the case of abnormally large table view cells, we have to reset the size.
	// This is because the view drawing subsystem takes the cell frame to be the sandbox bounds when drawing views,
	// and if its frame is too big... the view system allocates way too much memory/pixels and doesn't appear to let
	// them go.

	CGRect oldFrame = [[self contentView] frame];
    CGSize cellSize = [self computeCellSize];
    
	[[self contentView] setFrame:CGRectMake(oldFrame.origin.x, oldFrame.origin.y, cellSize.width, cellSize.height)];
}

- (UIView *)hitTest:(CGPoint) point withEvent:(UIEvent *)event 
{
	hitPoint = point;
	return [super hitTest:point withEvent:event];
}

-(void)setHighlighted:(BOOL)yn animated:(BOOL)animated
{
	[super setHighlighted:yn animated:animated];
	if (yn) 
	{
		if ([proxy _hasListeners:@"touchstart"])
		{
			[proxy fireEvent:@"touchstart" withObject:[proxy createEventObject:nil] propagate:YES];
		}
	}
	else
	{
		if ([proxy _hasListeners:@"touchend"]) {
			[proxy fireEvent:@"touchend" withObject:[proxy createEventObject:nil] propagate:YES];
		}
	}
	[self updateGradientLayer:yn|[self isSelected]];
}

-(void)handleEvent:(NSString*)type
{
	if ([type isEqual:@"touchstart"]) {
		[super setHighlighted:YES animated:NO];
	}
	else if ([type isEqual:@"touchend"]) {
		[super setHighlighted:NO animated:YES];
	}
}

-(void)layoutSubviews
{
	[super layoutSubviews];
	[gradientLayer setFrame:[self bounds]];
    
    // In order to avoid ugly visual behavior, whenever a cell is laid out, we MUST relayout the
    // row concurrently.
    [TiLayoutQueue layoutProxy:proxy];
}

-(BOOL) selectedOrHighlighted
{
	return [self isSelected] || [self isHighlighted];
}


-(void) updateGradientLayer:(BOOL)useSelected
{
	TiGradient * currentGradient = useSelected?selectedBackgroundGradient:backgroundGradient;

	if(currentGradient == nil)
	{
		[gradientLayer removeFromSuperlayer];
		//Because there's the chance that the other state still has the gradient, let's keep it around.
		return;
	}
	
	CALayer * ourLayer = [self layer];
	
	if(gradientLayer == nil)
	{
		gradientLayer = [[TiGradientLayer alloc] init];
		[gradientLayer setNeedsDisplayOnBoundsChange:YES];
		[gradientLayer setFrame:[self bounds]];
	}

	[gradientLayer setGradient:currentGradient];
	if([gradientLayer superlayer] != ourLayer)
	{
        CALayer* contentLayer = [[self contentView] layer];
		[ourLayer insertSublayer:gradientLayer below:contentLayer];
        
        // If we're working with a row that just has a label drawn on it, we need to
        // set the background color of the label explicitly
        if ([[self textLabel] text] != nil) {
            [[self textLabel] setBackgroundColor:[UIColor clearColor]];
        }
	}
	[gradientLayer setNeedsDisplay];
}

-(void)setHighlighted:(BOOL)yn
{
	[self setHighlighted:yn animated:NO];
}

-(void)setSelected:(BOOL)yn
{
    [super setSelected:yn];
	[super setHighlighted:yn];
	[self updateGradientLayer:yn|[self isHighlighted]];
}

-(void) setBackgroundGradient_:(TiGradient *)newGradient
{
	if(newGradient == backgroundGradient)
	{
		return;
	}
	[backgroundGradient release];
	backgroundGradient = [newGradient retain];
	
	if(![self selectedOrHighlighted])
	{
		[self updateGradientLayer:NO];
	}
}

-(void) setSelectedBackgroundGradient_:(TiGradient *)newGradient
{
	if(newGradient == selectedBackgroundGradient)
	{
		return;
	}
	[selectedBackgroundGradient release];
	selectedBackgroundGradient = [newGradient retain];
	
	if([self selectedOrHighlighted])
	{
		[self updateGradientLayer:YES];
	}
}



@end

@interface TiUITableView ()
@property (nonatomic,copy,readwrite) NSString * searchString;
- (void)updateSearchResultIndexes;

@end

@implementation TiUITableView
#pragma mark Internal 
@synthesize searchString;

-(id)init
{
	if (self = [super init])
	{
		filterCaseInsensitive = YES; // defaults to true on search
		searchString = @"";
	}
	return self;
}

-(void)dealloc
{
	if (searchField!=nil)
	{
		[searchField setDelegate:nil];
		RELEASE_TO_NIL(searchField);
	}
	RELEASE_TO_NIL(tableController);
    
    searchController.searchResultsDataSource =  nil;
    searchController.searchResultsDelegate = nil;
    searchController.delegate = nil;
	RELEASE_TO_NIL(searchController);
    
    tableview.delegate = nil;
    tableview.dataSource = nil;
	RELEASE_TO_NIL(tableview);
    
	RELEASE_TO_NIL(sectionIndex);
	RELEASE_TO_NIL(sectionIndexMap);
	RELEASE_TO_NIL(tableHeaderView);
	RELEASE_TO_NIL(searchScreenView);
	RELEASE_TO_NIL(filterAttribute);
	RELEASE_TO_NIL(searchResultIndexes);
	RELEASE_TO_NIL(initialSelection);
	RELEASE_TO_NIL(tableHeaderPullView);
	[searchString release];
	[super dealloc];
}

-(BOOL)isScrollable
{
	return [TiUtils boolValue:[self.proxy valueForUndefinedKey:@"scrollable"] def:YES];
}

-(CGFloat)tableRowHeight:(CGFloat)height
{
	if (TiDimensionIsPixels(rowHeight))
	{
		if (rowHeight.value > height)
		{
			height = rowHeight.value;
		}
	}
	if (TiDimensionIsPixels(minRowHeight))
	{
		height = MAX(minRowHeight.value,height);
	}
	if (TiDimensionIsPixels(maxRowHeight))
	{
		height = MIN(maxRowHeight.value,height);
	}
	return height < 1 ? tableview.rowHeight : height;
}

-(void)setBackgroundColor:(TiColor*)color onTable:(UITableView*)table
{
	UIColor* defaultColor = [table style] == UITableViewStylePlain ? [UIColor whiteColor] : [UIColor groupTableViewBackgroundColor];
	UIColor* bgColor = [color _color];
	
	// WORKAROUND FOR APPLE BUG: 4.2 and lower don't like setting background color for grouped table views on iPad.
	// So, we check the table style and device, and if they match up wrong, we replace the background view with our own.
	if ([table style] == UITableViewStyleGrouped && [TiUtils isIPad]) {
		UIView* bgView = [[[UIView alloc] initWithFrame:[table frame]] autorelease];
		[table setBackgroundView:bgView];
	}

	[table setBackgroundColor:(bgColor != nil ? bgColor : defaultColor)];
	[[table backgroundView] setBackgroundColor:[table backgroundColor]];
	
	[table setOpaque:![[table backgroundColor] isEqual:[UIColor clearColor]]];
}

-(UITableView*)tableView
{
	if (tableview==nil)
	{
		id styleObject = [self.proxy valueForKey:@"style"];
		UITableViewStyle style = [TiUtils intValue:styleObject def:UITableViewStylePlain];
#ifdef VERBOSE
		NSLog(@"[DEBUG] Generating a new tableView, and style for %@ is %d",[self.proxy valueForKey:@"style"],style);
		if(styleObject == nil)
		{
			NSLog(@"[WARN] No style object!");
		}
#endif
		tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [self bounds].size.width, [self bounds].size.height) style:style];
		tableview.delegate = self;
		tableview.dataSource = self;
		tableview.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		if (TiDimensionIsPixels(rowHeight))
		{
			[tableview setRowHeight:rowHeight.value];
		}		
		[self setBackgroundColor:[TiUtils colorValue:[[self proxy] valueForKey:@"backgroundColor"]] onTable:tableview];
		
		[self updateSearchView];
	}
	if ([tableview superview] != self)
	{
		[self addSubview:tableview];
	}
	
	return tableview;
}

-(NSInteger)indexForRow:(TiUITableViewRowProxy*)row
{
	return [(TiUITableViewProxy *)[self proxy] indexForRow:row];
}

-(NSInteger)sectionIndexForIndex:(NSInteger)theindex
{
	return [(TiUITableViewProxy *)[self proxy] sectionIndexForIndex:theindex];
}

-(TiUITableViewRowProxy*)rowForIndex:(NSInteger)index section:(NSInteger*)section
{
	return [(TiUITableViewProxy *)[self proxy] rowForIndex:index section:section];
}

-(NSIndexPath *)indexPathFromInt:(NSInteger)index
{
	return [(TiUITableViewProxy *)[self proxy] indexPathFromInt:index];
}

-(void)reloadDataFromCount:(int)oldCount toCount:(int)newCount animation:(UITableViewRowAnimation)animation
{
	UITableView *table = [self tableView];
    
    // Apple kindly forces animations whenever we're inserting/deleting in a no-animation
    // way, meaning that we have to explicitly reload the whole visible table to get
    // the "right" behavior.
    if (animation == UITableViewRowAnimationNone) {
        if (![NSThread isMainThread]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [table reloadData];
            });
        }
        else {
            [table reloadData];            
        }
        return;
    }
    
	//Table views hate having 0 sections, so we have to act like it has at least 1.
	oldCount = MAX(1,oldCount);
	newCount = MAX(1,newCount);

	int commonality = MIN(oldCount,newCount);
	oldCount -= commonality;
	newCount -= commonality;
    
	[tableview beginUpdates];
	if (commonality > 0)
	{
		[table reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, commonality)]
				withRowAnimation:animation];
	}
	if (oldCount > 0)
	{
		[table deleteSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(commonality,oldCount)]
				withRowAnimation:animation];
	}
	if (newCount > 0)
	{
		[table insertSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(commonality,newCount)]
				withRowAnimation:animation];
	}
	[tableview endUpdates];
}

-(void)replaceData:(NSMutableArray*)data animation:(UITableViewRowAnimation)animation
{ 
	//Technically, we should assert that sections is non-nil, but this code
	//won't have any problems in the case that it is actually nil.	
	TiUITableViewProxy * ourProxy = (TiUITableViewProxy *)[self proxy];

	int oldCount = [(TiUITableViewProxy *)[self proxy] sectionCount];
	
	for (TiUITableViewSectionProxy *section in [(TiUITableViewProxy *)[self proxy] sections])
	{
		if ([section parent] == ourProxy)
		{
			[section setTable:nil];
			[section setParent:nil];
			[self.proxy forgetProxy:section];
		}
	}
	
    // Make sure that before we update the section count, the table has been created;
    // this prevents consistency errors on loading the initial dataset when it contains
    // more than one section.
    if (tableview == nil) {
        [self tableView];
    }
    
	[ourProxy setSections:data];

	int newCount = 0;	//Since we're iterating anyways, we might as well not get count.

	for (TiUITableViewSectionProxy *section in [(TiUITableViewProxy *)[self proxy] sections])
	{
		[section setTable:self];
		[section setParent:ourProxy];
		[section setSection:newCount ++];
		[section reorderRows];
		//TODO: Shouldn't this be done by Section itself? Doesn't it already?
		for (TiUITableViewRowProxy *row in section)
		{
			row.section = section;
			row.parent = section;
		}
		[self.proxy rememberProxy:section];

	}

	[self reloadDataFromCount:oldCount toCount:newCount animation:animation];
}

//Assertions no longer are needed; we ensure that the sections are not nil.
-(void)updateRow:(TiUITableViewRowProxy*)row
{
	row.table = self;
	NSMutableArray *rows = [row.section rows];
	
	if ([rows count] > row.row) {
		TiUITableViewRowProxy* oldRow = [rows objectAtIndex:row.row];
		[oldRow retain];
		oldRow.table = nil;
		oldRow.section = nil;
		oldRow.parent = nil;
		[row.section forgetProxy:oldRow];
		[oldRow release];
	}	
	[row.section rememberProxy:row];
	[rows replaceObjectAtIndex:row.row withObject:row];
	[row.section reorderRows];
}

-(void)insertRow:(TiUITableViewRowProxy*)row before:(TiUITableViewRowProxy*)before 
{
	row.table = self;
	row.section = before.section;
	NSMutableArray *rows = [row.section rows];
	[rows insertObject:row atIndex:row.row];
	[row.section rememberProxy:row];
	[row.section reorderRows];
}

-(void)insertRow:(TiUITableViewRowProxy*)row after:(TiUITableViewRowProxy*)after 
{
	row.table = self;
	row.section = after.section;
	NSMutableArray *rows = [row.section rows];
	if (after.row + 1 == [rows count])
	{
		[rows addObject:row];
	}
	else
	{
		[rows insertObject:row atIndex:after.row+1];
	}
	[row.section rememberProxy:row];
	[row.section reorderRows];
}

-(void)deleteRow:(TiUITableViewRowProxy*)row
{
	[[row retain] autorelease];
	NSMutableArray *rows = [row.section rows];
#ifdef DEBUG
	ENSURE_VALUE_CONSISTENCY([rows containsObject:row],YES);
#endif
	[rows removeObject:row];
	[row.section forgetProxy:row];
	[row.section reorderRows];
}

-(void)appendRow:(TiUITableViewRowProxy*)row 
{
	row.table = self;
	TiUITableViewSectionProxy *section = row.section;
    [section add:row];
	[row.section rememberProxy:row];
	[row.section reorderRows];
}

//Because UITableView does not like having 0 sections, we MUST maintain the facade of having at least one section,
//albeit with 0 rows. Because of this, we might come across several times where this fictional first section will
//be asked about. Because we don't want the sections array throwing range exceptions, sectionForIndex MUST be used
//for this protection.
-(TiUITableViewSectionProxy *)sectionForIndex:(NSInteger) index
{
	NSArray * sections = [(TiUITableViewProxy *)[self proxy] sections];
	if(index >= [sections count])
	{
		return nil;
	}
	return [sections objectAtIndex:index];
}

-(void)dispatchAction:(TiUITableViewAction*)action
{
	ENSURE_UI_THREAD(dispatchAction,action);
	
	NSMutableArray * sections = [(TiUITableViewProxy *)[self proxy] sections];
    BOOL reloadSearch = NO;
	switch (action.type)
	{
		case TiUITableViewActionRowReload:
		{
			TiUITableViewRowProxy* row = (TiUITableViewRowProxy*)action.obj;
			NSIndexPath *path = [NSIndexPath indexPathForRow:row.row inSection:row.section.section];
			[tableview reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:action.animation];
			break;
		}
		case TiUITableViewActionUpdateRow:
		{
			TiUITableViewRowProxy* row = (TiUITableViewRowProxy*)action.obj;			
			[self updateRow:row];
			NSIndexPath *path = [NSIndexPath indexPathForRow:row.row inSection:row.section.section];
			[tableview reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:action.animation];
			break;
		}
		case TiUITableViewActionSectionReload:
		{
			TiUITableViewSectionProxy* section = action.obj;
			NSIndexSet *path = [NSIndexSet indexSetWithIndex:section.section];
			[tableview reloadSections:path withRowAnimation:action.animation];
			break;
		}
		case TiUITableViewActionInsertRowBefore:
		{
			TiUITableViewRowProxy* row = (TiUITableViewRowProxy*)action.obj;						
			int index = row.row;
			TiUITableViewRowProxy *oldrow = [[row.section rows] objectAtIndex:index];
			[self insertRow:row before:oldrow];
			NSIndexPath *path = [NSIndexPath indexPathForRow:row.row inSection:row.section.section];
			[tableview insertRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:action.animation];
			break;
		}
        case TiUITableViewActionInsertSectionBefore:
        {
			TiUITableViewRowProxy* row = (TiUITableViewRowProxy*)action.obj;									
            int newSectionIndex = row.section.section;
            int rowIndex = row.row;
            row.row = 0;
            TiUITableViewSectionProxy* newSection = row.section;

			int updateSectionIndex = (rowIndex == 0) ? newSectionIndex : newSectionIndex - 1;
            TiUITableViewSectionProxy* updateSection = [self sectionForIndex:updateSectionIndex];;
            
            NSMutableArray* addRows = [NSMutableArray array];
			
			// If we're inserting before the first row, we can (and should!) skip all this stuff.
			if (rowIndex != 0) {
				NSMutableArray* removeRows = [NSMutableArray array];
				int numrows = [[updateSection rows] count];
				for (int i=rowIndex; i < numrows; i++) {
					// Because rows are being bumped off, we need to keep grabbing the one in the initial index
					TiUITableViewRowProxy* moveRow = [[[updateSection rows] objectAtIndex:rowIndex] retain];
					
					[removeRows addObject:[NSIndexPath indexPathForRow:i inSection:updateSectionIndex]];
					[self deleteRow:moveRow];
					
					moveRow.section = newSection;
					moveRow.row = (i-rowIndex)+1;
					moveRow.parent = newSection;
					
					[addRows addObject:moveRow];
					[moveRow release];
				}
				
				[tableview deleteRowsAtIndexPaths:removeRows withRowAnimation:UITableViewRowAnimationNone];
			}

			[sections insertObject:newSection atIndex:newSectionIndex];
            [self appendRow:row];
            for (TiUITableViewRowProxy* moveRow in addRows) {
                [self appendRow:moveRow];
            }
            [tableview insertSections:[NSIndexSet indexSetWithIndex:newSectionIndex] withRowAnimation:action.animation];
            
            break;
        }
		case TiUITableViewActionInsertRowAfter:
		{
			TiUITableViewRowProxy* row = (TiUITableViewRowProxy*)action.obj;												
			int index = row.row-1;
			TiUITableViewRowProxy *oldrow = nil;
			if (index < [[row.section rows] count])
			{
				oldrow = [[row.section rows] objectAtIndex:index];
			}
			[self insertRow:row after:oldrow];
			NSIndexPath *path = [NSIndexPath indexPathForRow:row.row inSection:row.section.section];
			[tableview insertRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:action.animation];
			break;
		}
        case TiUITableViewActionInsertSectionAfter:
        {
			TiUITableViewRowProxy* row = (TiUITableViewRowProxy*)action.obj;															
            int newSectionIndex = row.section.section;
            int rowIndex = row.row; // Get the index of rows which will come after the new row
            row.row = 0; // Reset the row index to the right place
            TiUITableViewSectionProxy* newSection = row.section;
            
            // Move ALL of the rows after the row we're inserting after to the new section
            TiUITableViewSectionProxy* previousSection = [sections objectAtIndex:newSectionIndex-1];
            int numRows = [[previousSection rows] count];
            
            NSMutableArray* removeRows = [NSMutableArray array];
            NSMutableArray* addRows = [NSMutableArray array];
            for (int i=rowIndex; i < numRows; i++) {
                // Have to hold onto the row while we're moving it
                TiUITableViewRowProxy* moveRow = [[[previousSection rows] objectAtIndex:rowIndex] retain];
                [removeRows addObject:[NSIndexPath indexPathForRow:i inSection:newSectionIndex-1]];
                [self deleteRow:moveRow];
                
                moveRow.section = newSection;
                moveRow.row = (i-rowIndex)+1;
                moveRow.parent = newSection;
                
                [addRows addObject:moveRow];
                [moveRow release];
            }
            // 1st stage of update: Remove all those nasty old rows.
            [tableview deleteRowsAtIndexPaths:removeRows withRowAnimation:UITableViewRowAnimationNone];
            
            // 2nd stage of update: Add in those shiny new rows and update the section.
            [sections insertObject:newSection atIndex:newSectionIndex];
            [self appendRow:row];
            for (TiUITableViewRowProxy* moveRow in addRows) {
                [self appendRow:moveRow];
            }
            [tableview insertSections:[NSIndexSet indexSetWithIndex:newSectionIndex] withRowAnimation:action.animation];
            
            break;
        }
		case TiUITableViewActionDeleteRow:
		{
			TiUITableViewRowProxy* row = (TiUITableViewRowProxy*)action.obj;
			[self deleteRow:row];
			NSIndexPath *path = [NSIndexPath indexPathForRow:row.row inSection:row.section.section];
			[tableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:action.animation];
			break;
		}
		case TiUITableViewActionSetData:
		{
			[self replaceData:action.obj animation:action.animation];
            reloadSearch = YES;
			break;
		}
		case TiUITableViewActionAppendRow:
		{
			TiUITableViewRowProxy* row = (TiUITableViewRowProxy*)action.obj;
			[self appendRow:action.obj];
			NSIndexPath *path = [NSIndexPath indexPathForRow:row.row inSection:row.section.section];
			[tableview insertRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:action.animation];
			break;
		}
        case TiUITableViewActionAppendRowWithSection:
        {
			TiUITableViewRowProxy* row = (TiUITableViewRowProxy*)action.obj;			
            [sections addObject:row.section];
            [self appendRow:action.obj];
            [tableview insertSections:[NSIndexSet indexSetWithIndex:[sections count]-1] withRowAnimation:action.animation];
            break;
        }
	}

	if ([searchController searchResultsTableView] != nil) {
        [self updateSearchResultIndexes];
        
        // Because -[UITableView reloadData] queues on the main runloop, we need to sync the search
        // table reload to the same method. The only time we reloadData, though, is when setting the
        // data, so toggle a flag to indicate what the search should do.
        if (reloadSearch) {
            [[searchController searchResultsTableView] reloadData];
        }
        else {
            [[searchController searchResultsTableView] reloadSections:[NSIndexSet indexSetWithIndex:0]
                                                     withRowAnimation:UITableViewRowAnimationFade];
        }
	}
}

-(UIView*)titleViewForText:(NSString*)text footer:(BOOL)footer
{
	CGSize maxSize = CGSizeMake(320, 1000);
	UIFont *font = [[WebFont defaultBoldFont] font];
	CGSize size = [text sizeWithFont:font constrainedToSize:maxSize lineBreakMode:UILineBreakModeTailTruncation];
	
	UITableViewStyle style = [[self tableView] style];
	int x = (style==UITableViewStyleGrouped) ? 15 : 10;
	int y = 10;
	int y2 = (footer) ? 0 : 10;
	UIView *containerView = [[[UIView alloc] initWithFrame:CGRectMake(0, y, size.width, size.height+10)] autorelease];
    UILabel *headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(x, y2, size.width, size.height)] autorelease];

    headerLabel.text = text;
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.shadowColor = [UIColor whiteColor];
    headerLabel.shadowOffset = CGSizeMake(0, 1);
	headerLabel.font = font;
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.numberOfLines = 0;
    [containerView addSubview:headerLabel];
	
	return containerView;
}

-(TiUITableViewRowProxy*)rowForIndexPath:(NSIndexPath*)indexPath
{
	TiUITableViewSectionProxy *section = [self sectionForIndex:[indexPath section]];
	return [section rowAtIndex:[indexPath row]];
}

-(void)changeEditing:(BOOL)yn
{
	editing = yn;
	[self.proxy replaceValue:NUMBOOL(yn) forKey:@"editing" notification:NO];
}

-(void)changeMoving:(BOOL)yn
{
	moving = yn;
	[self.proxy replaceValue:NUMBOOL(yn) forKey:@"moving" notification:NO];
}

-(NSInteger)indexForIndexPath:(NSIndexPath *)path
{
	return [(TiUITableViewProxy *)[self proxy] indexForIndexPath:path];
}

- (void)triggerActionForIndexPath:(NSIndexPath *)indexPath fromPath:(NSIndexPath*)fromPath tableView:(UITableView*)ourTableView wasAccessory: (BOOL)accessoryTapped search:(BOOL)viaSearch name:(NSString*)name
{
	NSIndexPath* index = indexPath;
	if (viaSearch) {
		index = [self indexPathFromSearchIndex:[indexPath row]];
	}
	int sectionIdx = [index section];
	NSArray * sections = [(TiUITableViewProxy *)[self proxy] sections];
	TiUITableViewSectionProxy *section = [self sectionForIndex:sectionIdx];
	
	int rowIndex = [index row];
	int dataIndex = 0;
	int c = 0;
	TiUITableViewRowProxy *row = [section rowAtIndex:rowIndex];
	
	// unfortunately, we have to scan to determine our row index
	for (TiUITableViewSectionProxy *section in sections)
	{
		if (c == sectionIdx)
		{
			dataIndex += rowIndex;
			break;
		}
		dataIndex += [section rowCount];
		c++;
	}
	
	NSMutableDictionary * eventObject = [NSMutableDictionary dictionaryWithObjectsAndKeys:
										 section,@"section",
										 NUMINT(dataIndex),@"index",
										 row,@"row",
										 NUMBOOL(accessoryTapped),@"detail",
										 NUMBOOL(viaSearch),@"searchMode",
										 row,@"rowData",
										 nil];

	if (fromPath!=nil)
	{
		NSNumber *fromIndex = [NSNumber numberWithInt:[self indexForIndexPath:fromPath]];
		[eventObject setObject:fromIndex forKey:@"fromIndex"];
		[eventObject setObject:[NSNumber numberWithInt:[fromPath row]] forKey:@"fromRow"];
		[eventObject setObject:[NSNumber numberWithInt:[fromPath section]] forKey:@"fromSection"];
	}
	
	// fire it to our row since the row, section and table are
	// in a hierarchy and it will bubble up from there...

	UITableViewCell * thisCell = [ourTableView cellForRowAtIndexPath:indexPath];
	
	CGPoint point = [(TiUITableViewCell*)thisCell hitPoint];
	TiProxy * target = [row touchedViewProxyInCell:thisCell atPoint:&point];

	[eventObject setObject:NUMFLOAT(point.x) forKey:@"x"];
	[eventObject setObject:NUMFLOAT(point.y) forKey:@"y"];

	CGPoint globalPoint = [thisCell convertPoint:point toView:nil];
	[eventObject setObject:[TiUtils pointToDictionary:globalPoint] forKey:@"globalPoint"];

	if ([target _hasListeners:name])
	{
		[target fireEvent:name withObject:eventObject];
	}	
	
	if (viaSearch) {
		[self hideSearchScreen:nil];
	}
}

#pragma mark Overloaded view handling
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
	UIView * result = [super hitTest:point withEvent:event];
	if(result == self)
	{	//There is no valid reason why the TiUITableView will get an
		//touch event; it should ALWAYS be a child view.
		return nil;
	}
	return result;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
	// iOS idiom seems to indicate that you should never be able to interact with a table
	// while the 'delete' button is showing for a row, but touchesBegan:withEvent: is still triggered.
	// Turn it into a no-op while we're editing
	if (!editing && !moving) {
		[super touchesBegan:touches withEvent:event];
	}
}

#pragma mark Searchbar-related accessors

- (UIButton *) searchScreenView
{
	if (searchScreenView == nil) 
	{
		searchScreenView = [[UIButton alloc] init];
		[searchScreenView addTarget:self action:@selector(hideSearchScreen:) forControlEvents:UIControlEventTouchUpInside];
		[searchScreenView setShowsTouchWhenHighlighted:NO];
		[searchScreenView setAdjustsImageWhenDisabled:NO];
		[searchScreenView setOpaque:NO];
		[searchScreenView setBackgroundColor:[UIColor blackColor]];
	}
	return searchScreenView;
}


#pragma mark Searchbar helper methods

- (NSIndexPath *) indexPathFromSearchIndex: (int) index
{
	int asectionIndex = 0;
	for (NSIndexSet * thisSet in searchResultIndexes) 
	{
		int thisSetCount = [thisSet count];
		if(index < thisSetCount)
		{
			int rowIndex = [thisSet firstIndex];
			while (index > 0) 
			{
				rowIndex = [thisSet indexGreaterThanIndex:rowIndex];
				index --;
			}
			return [NSIndexPath indexPathForRow:rowIndex inSection:asectionIndex];
		}
		asectionIndex++;
		index -= thisSetCount;
	}
	return nil;
}

- (void)updateSearchResultIndexes
{
	NSEnumerator * searchResultIndexEnumerator;
	if(searchResultIndexes == nil)
	{
		searchResultIndexes = [[NSMutableArray alloc] initWithCapacity:[(TiUITableViewProxy *)[self proxy] sectionCount]];
		searchResultIndexEnumerator = nil;
	} 
	else 
	{
		searchResultIndexEnumerator = [searchResultIndexes objectEnumerator];
	}
	
	//TODO: If the search is adding letters to the previous search string, do it by elimination instead of adding.
	
	NSString * ourSearchAttribute = filterAttribute;
	if(ourSearchAttribute == nil)
	{
		ourSearchAttribute = @"title";
	}
	
	NSStringCompareOptions searchOpts = (filterCaseInsensitive ? NSCaseInsensitiveSearch : 0);
	
	for (TiUITableViewSectionProxy * thisSection in [(TiUITableViewProxy *)[self proxy] sections]) 
	{
		NSMutableIndexSet * thisIndexSet = [searchResultIndexEnumerator nextObject];
		if (thisIndexSet == nil)
		{
			searchResultIndexEnumerator = nil; //Make sure we don't use the enumerator anymore. 
			thisIndexSet = [NSMutableIndexSet indexSet];
			[searchResultIndexes addObject:thisIndexSet];
		} 
		else 
		{
			[thisIndexSet removeAllIndexes];
		}
		int cellIndex = 0;
		for (TiUITableViewRowProxy *row in [thisSection rows]) 
		{
			id value = [row valueForKey:ourSearchAttribute];
			if (value!=nil && [[TiUtils stringValue:value] rangeOfString:searchString options:searchOpts].location!=NSNotFound)
			{
				[thisIndexSet addIndex:cellIndex];
			}
			cellIndex ++;
		}
	}
}

-(void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds
{
	if (searchHidden)
	{
		if (searchField!=nil && searchHiddenSet)
		{
			[self performSelector:@selector(hideSearchScreen:) withObject:self];
		}
	}
	else 
	{
		if (tableview!=nil && searchField!=nil)
		{
			[tableview setContentOffset:CGPointMake(0,0)];
		}
	}

	[super frameSizeChanged:frame bounds:bounds];
	
	if (tableHeaderPullView!=nil)
	{
		tableHeaderPullView.frame = CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.tableView.bounds.size.width, self.tableView.bounds.size.height);
		TiViewProxy *proxy = [self.proxy valueForUndefinedKey:@"headerPullView"];
		[TiUtils setView:[proxy view] positionRect:[tableHeaderPullView bounds]];
		[proxy windowWillOpen];
		[proxy layoutChildren:NO];
	}
	
	if ([tableview tableHeaderView]!=nil)
	{
		TiViewProxy *proxy = [self.proxy valueForUndefinedKey:@"headerView"];
		if (proxy!=nil)
		{
			[proxy windowWillOpen];
			[proxy layoutChildren:NO];
		}
	}

	if ([tableview tableFooterView]!=nil)
	{
		TiViewProxy *proxy = [self.proxy valueForUndefinedKey:@"footerView"];
		if (proxy!=nil)
		{
			[proxy windowWillOpen];
			[proxy layoutChildren:NO];
		}
	}
	
    // Since the header proxy is not properly attached to a view proxy in the _beershift
    // system, we have to reposition it here.  Resetting the table header view
    // is because there's a charming bug in UITableView that doesn't respect redisplay
    // for headers/footers when the frame changes.
    UIView* headerView = [[self tableView] tableHeaderView];
    if ([headerView isKindOfClass:[TiUIView class]]) {
        [(TiViewProxy*)[(TiUIView*)headerView proxy] reposition];
        [[self tableView] setTableHeaderView:headerView];
    }
    
    // ... And we have to do the same thing for the footer.
    UIView* footerView = [[self tableView] tableFooterView];
    if ([footerView isKindOfClass:[TiUIView class]]) {
        [(TiViewProxy*)[(TiUIView*)footerView proxy] reposition];
        [[self tableView] setTableFooterView:footerView];
    }
	
    if (tableview!=nil && 
        !CGRectIsEmpty(self.bounds) && 
        [tableview superview]!=nil)
	{
		
		if([NSThread isMainThread])
		{
			[tableview reloadData];
		}
		else
		{
			[tableview performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
		}
	}
}

#pragma mark Searchbar-related IBActions

- (IBAction) hideSearchScreen: (id) sender
{
	// check to make sure we're not in the middle of a layout, in which case we 
	// want to try later or we'll get weird drawing animation issues
	if (tableview.frame.size.width==0)
	{
		[self performSelector:@selector(hideSearchScreen:) withObject:sender afterDelay:0.1];
		return;
	}
	
	[[searchField view] resignFirstResponder];
	[self makeRootViewFirstResponder];
	[self.proxy replaceValue:NUMBOOL(YES) forKey:@"searchHidden" notification:NO];
	[searchController setActive:NO animated:YES];
	
	[tableview reloadRowsAtIndexPaths:[tableview indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationNone];

	if (sender==nil)
	{
		[UIView beginAnimations:@"searchy" context:nil];
	}
	if (searchHidden)
	{
		[tableview setContentOffset:CGPointMake(0,MAX(TI_NAVBAR_HEIGHT,searchField.view.frame.size.height)) animated:NO];
	}
	if (sender==nil)
	{
		[UIView commitAnimations];
	}
}

-(void)scrollToTop:(NSInteger)top animated:(BOOL)animated
{
	[tableview setContentOffset:CGPointMake(0,top) animated:animated];
}

- (IBAction) showSearchScreen: (id) sender
{
	if ([(TiUITableViewProxy *)[self proxy] sectionCount]>0)
	{
		[tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
						 atScrollPosition:UITableViewScrollPositionBottom animated:NO];
	}
	
	CGRect screenRect = [TiUtils viewPositionRect:tableview];
	CGFloat searchHeight = [[tableview tableHeaderView] bounds].size.height;
	
	screenRect.origin.y += searchHeight;
	screenRect.size.height -= searchHeight;
	
	UIView * wrapperView = [tableview superview];
	
	[UIView beginAnimations:@"searchy" context:nil];
	[tableview setContentOffset:CGPointMake(0,0)];
	[UIView commitAnimations];
}

-(void)updateSearchView
{
	if (tableview == nil)
	{
		return;
	}
	
	ENSURE_UI_THREAD_0_ARGS;
	if (searchField == nil)
	{
		[tableview setTableHeaderView:nil];
		RELEASE_TO_NIL(tableHeaderView);
		RELEASE_TO_NIL(searchScreenView);
		RELEASE_TO_NIL(searchResultIndexes);
		return;
	}
	
	UIView * searchView = [searchField view];

	if (tableHeaderView == nil)
	{
		CGRect wrapperFrame = CGRectMake(0, 0, [tableview bounds].size.width, TI_NAVBAR_HEIGHT);
		tableHeaderView = [[UIView alloc] initWithFrame:wrapperFrame];
		[TiUtils setView:searchView positionRect:wrapperFrame];
		[tableHeaderView addSubview:searchView];
		[tableview setTableHeaderView:tableHeaderView];
		[searchView sizeToFit];
	}
}

#pragma mark Search Bar Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	// called when text starts editing
	[self showSearchScreen:nil];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	[self setSearchString:searchText];
	// called when text changes (including clear)
	if([searchText length]==0)
	{
		// Redraw visible cells
        [tableview reloadRowsAtIndexPaths:[tableview indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationNone];
		return;
	}
	[self updateSearchResultIndexes];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar                    
{
	// called when keyboard search button pressed
	[searchBar resignFirstResponder];
	[self makeRootViewFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
	// called when cancel button pressed
	[searchBar setText:nil];
	[self hideSearchScreen:nil];
}

#pragma mark Section Header / Footer

-(TiUIView*)sectionView:(NSInteger)section forLocation:(NSString*)location section:(TiUITableViewSectionProxy**)sectionResult
{
	TiUITableViewSectionProxy *proxy = [self sectionForIndex:section];
	//In the event that proxy is nil, this all flows out to returning nil safely anyways.
	if (sectionResult!=nil)
	{
		*sectionResult = proxy;
	}
	TiViewProxy* viewproxy = [proxy valueForKey:location];
	if (viewproxy!=nil && [viewproxy isKindOfClass:[TiViewProxy class]])
	{
		[viewproxy windowWillOpen];
		return [viewproxy view];
	}
	return nil;
}

#pragma mark Public APIs

-(void)scrollToIndex:(NSInteger)index position:(UITableViewScrollPosition)position animated:(BOOL)animated
{
	UITableView *table = [self tableView];
	NSIndexPath *path = [self indexPathFromInt:index];
	[table scrollToRowAtIndexPath:path atScrollPosition:position animated:animated];
}

-(void)setBackgroundColor_:(id)arg
{
	[[self proxy] replaceValue:arg forKey:@"backgroundColor" notification:NO];
	if (tableview != nil) {
		[self setBackgroundColor:[TiUtils colorValue:arg] onTable:[self tableView]];
	}
}

-(void)setBackgroundImage_:(id)arg
{
	NSURL *url = [TiUtils toURL:arg proxy:(TiProxy*)self.proxy];
	UIImage *image = [[ImageLoader sharedLoader] loadImmediateImage:url];
	[[self tableView] setBackgroundColor:[UIColor colorWithPatternImage:image]];
    
    self.backgroundImage = arg;
}

-(void)setAllowsSelection_:(id)arg
{
	allowsSelectionSet = [TiUtils boolValue:arg];
	[[self tableView] setAllowsSelection:allowsSelectionSet];
}

-(void)setAllowsSelectionDuringEditing_:(id)arg
{
	[[self tableView] setAllowsSelectionDuringEditing:[TiUtils boolValue:arg def:NO]];
}

-(void)setSeparatorStyle_:(id)arg
{
	[[self tableView] setSeparatorStyle:[TiUtils intValue:arg]];
}

-(void)setSeparatorColor_:(id)arg
{
	TiColor *color = [TiUtils colorValue:arg];
	[[self tableView] setSeparatorColor:[color _color]];
}

-(void)setHeaderTitle_:(id)args
{
	[[self tableView] setTableHeaderView:[self titleViewForText:[TiUtils stringValue:args] footer:NO]];
}

-(void)setFooterTitle_:(id)args
{
	[[self tableView] setTableFooterView:[self titleViewForText:[TiUtils stringValue:args] footer:YES]];
}

-(void)setHeaderView_:(id)args
{
	ENSURE_SINGLE_ARG_OR_NIL(args,TiViewProxy);
	if (args!=nil)
	{
		TiUIView *view = (TiUIView*) [args view];
		UITableView *table = [self tableView];
		[table setTableHeaderView:view];
	}
	else
	{
		[[self tableView] setTableHeaderView:nil];
	}
}

-(void)setFooterView_:(id)args
{
	ENSURE_SINGLE_ARG_OR_NIL(args,TiViewProxy);
	if (args!=nil)
	{
		[args windowWillOpen];
		UIView *view = [args view];
		[[self tableView] setTableFooterView:view];
	}
	else
	{
		[[self tableView] setTableFooterView:nil];
	}
}

-(void)setSearch_:(id)search
{
	ENSURE_TYPE_OR_NIL(search,TiUISearchBarProxy);
	if (searchField!=nil)
	{
		[searchField setDelegate:nil];
	}
	RELEASE_TO_NIL(searchField);
	RELEASE_TO_NIL(tableController);
	RELEASE_TO_NIL(searchController);
	
	if (search!=nil)
	{
		//TODO: now that we're using the search controller, we can move away from
		//doing our own custom search screen since the controller gives this to us
		//for free
		searchField = [search retain];
		[searchField windowWillOpen];
		[searchField setDelegate:self];
		tableController = [[UITableViewController alloc] init];
		tableController.tableView = [self tableView];
		searchController = [[UISearchDisplayController alloc] initWithSearchBar:[search searchBar] contentsController:tableController];
		searchController.searchResultsDataSource = self;
		searchController.searchResultsDelegate = self;
		searchController.delegate = self;
		
		[self updateSearchView];

		if (searchHiddenSet==NO)
		{
			return;
		}
		
		if (searchHidden)
		{
			[self hideSearchScreen:nil];
			return;
		}
		searchHidden = NO;
		[self.proxy replaceValue:NUMBOOL(NO) forKey:@"searchHidden" notification:NO];
	}
	else 
	{
		searchHidden = YES;
		[self.proxy replaceValue:NUMBOOL(NO) forKey:@"searchHidden" notification:NO];
		[self updateSearchView];
	}
}

-(void)setShowVerticalScrollIndicator_:(id)value
{
	[[self tableView] setShowsVerticalScrollIndicator:[TiUtils boolValue:value]];
}

-(void)configurationSet
{
	[super configurationSet];
	
	if ([self.proxy valueForUndefinedKey:@"searchHidden"]==nil && 
		[self.proxy valueForUndefinedKey:@"search"]==nil)
	{
		searchHidden = YES;
		[self.proxy replaceValue:NUMBOOL(YES) forKey:@"searchHidden" notification:NO];
	}
}

-(void)setSearchHidden_:(id)hide
{
	searchHiddenSet = YES;
	
	if ([TiUtils boolValue:hide])
	{
		searchHidden=YES;
		if (searchField)
		{
			[self hideSearchScreen:nil];
		}
	}
	else 
	{
		searchHidden=NO;
		if (searchField)
		{
			[self showSearchScreen:nil];
		}
	}
}

- (void)setFilterAttribute_:(id)newFilterAttribute
{
	ENSURE_STRING_OR_NIL(newFilterAttribute);
	if (newFilterAttribute == filterAttribute) 
	{
		return;
	}
	RELEASE_TO_NIL(filterAttribute);
	filterAttribute = [newFilterAttribute copy];
}

-(void)setIndex_:(NSArray*)index_
{
	RELEASE_TO_NIL(sectionIndex);
	RELEASE_TO_NIL(sectionIndexMap);
	
	sectionIndex = [[NSMutableArray alloc] initWithCapacity:[index_ count]];
	sectionIndexMap = [[NSMutableDictionary alloc] init];
	
	for (NSDictionary *entry in index_)
	{
		ENSURE_DICT(entry);
		
		NSString *title = [entry objectForKey:@"title"];
		id theindex = [entry objectForKey:@"index"];
		[sectionIndex addObject:title];
		[sectionIndexMap setObject:[NSNumber numberWithInt:[TiUtils intValue:theindex]] forKey:title];
	}
    
	int sectionCount = [self numberOfSectionsInTableView:tableview]-1;

    // Instead of calling back through our mechanism to reload specific sections, because the entire index of the table
    // has been regenerated, we can assume it's okay to just reload the whole dataset.
    if ([NSThread isMainThread]) {
        [[self tableView] reloadData];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self tableView] reloadData];
        });
    }
}

-(void)setFilterCaseInsensitive_:(id)caseBool
{
	filterCaseInsensitive = [TiUtils boolValue:caseBool];
}

-(void)setEditable_:(id)args
{
	editable = [TiUtils boolValue:args];
}

-(void)setMoveable_:(id)args
{
	moveable = [TiUtils boolValue:args];
}

-(void)setScrollable_:(id)args
{
	UITableView *table = [self tableView];
	[table setScrollEnabled:[TiUtils boolValue:args]];
}

-(void)setEditing_:(id)args withObject:(id)properties
{
	[self changeEditing:[TiUtils boolValue:args]];
	UITableView *table = [self tableView];
	BOOL animated = [TiUtils boolValue:@"animated" properties:properties def:YES];
	[table beginUpdates];
	[table setEditing:moving||editing animated:animated];
	[table endUpdates];
}

-(void)setMoving_:(id)args withObject:(id)properties
{
	[self changeMoving:[TiUtils boolValue:args]];
	UITableView *table = [self tableView];
	BOOL animated = [TiUtils boolValue:@"animated" properties:properties def:YES];
	[table beginUpdates];
	[table setEditing:moving||editing animated:animated];
	[table endUpdates];
}

-(void)setRowHeight_:(id)height
{
	rowHeight = [TiUtils dimensionValue:height];
	if (TiDimensionIsPixels(rowHeight))
	{
		[tableview setRowHeight:rowHeight.value];
	}	
}

-(void)setMinRowHeight_:(id)height
{
	minRowHeight = [TiUtils dimensionValue:height];
}

-(void)setMaxRowHeight_:(id)height
{
	maxRowHeight = [TiUtils dimensionValue:height];
}

-(void)setHeaderPullView_:(id)value
{
	ENSURE_TYPE_OR_NIL(value,TiViewProxy);
	if (value==nil)
	{
		[tableHeaderPullView removeFromSuperview];
		RELEASE_TO_NIL(tableHeaderPullView);
	}
	else 
	{
		tableHeaderPullView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.tableView.bounds.size.width, self.tableView.bounds.size.height)];
		tableHeaderPullView.backgroundColor = [UIColor lightGrayColor];
		UIView *view = [value view];
		[[self tableView] addSubview:tableHeaderPullView];
		[tableHeaderPullView addSubview:view];
		[TiUtils setView:view positionRect:[tableHeaderPullView bounds]];
		CGRect bounds = view.bounds;
		bounds.origin.x = 0;
		bounds.origin.y = self.tableView.bounds.size.height - view.bounds.size.height;
		view.bounds = bounds;
	}
}

-(void)setContentInsets_:(id)value withObject:(id)props
{
	UIEdgeInsets insets = [TiUtils contentInsets:value];
	BOOL animated = [TiUtils boolValue:@"animated" properties:props def:NO];
	if (animated)
	{
		[UIView beginAnimations:nil context:nil];
		double duration = [TiUtils doubleValue:@"duration" properties:props def:300]/1000;
		[UIView setAnimationDuration:duration];
	}
	[[self tableView] setContentInset:insets];
	if (animated)
	{
		[UIView commitAnimations];
	}
}

#pragma mark Datasource 


#define RETURN_IF_SEARCH_TABLE_VIEW(result)	\
if(ourTableView != tableview)	\
{	\
	return result;	\
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	if(table != tableview)
	{
		int rowCount = 0;
		for (NSIndexSet * thisSet in searchResultIndexes) 
		{
			rowCount += [thisSet count];
		}
		return rowCount;
	}
	
	TiUITableViewSectionProxy *sectionProxy = [self sectionForIndex:section];
	return sectionProxy.rowCount;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)ourTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSIndexPath* index = indexPath;
	if (ourTableView != tableview) {
		index = [self indexPathFromSearchIndex:[indexPath row]];
	}
	
	TiUITableViewRowProxy *row = [self rowForIndexPath:index];
	[row triggerAttach];
	
	// the classname for all rows that have the same substainal layout will be the same
	// we reuse them for speed
	UITableViewCell *cell = [ourTableView dequeueReusableCellWithIdentifier:row.tableClass];
	if (cell == nil)
	{
		cell = [[[TiUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:row.tableClass row:row] autorelease];
        CGSize cellSize = [(TiUITableViewCell*)cell computeCellSize];
		[cell setBounds:CGRectMake(0, 0, cellSize.width,cellSize.height)];
        [[cell contentView] setBounds:[cell bounds]];
	}
	else
	{
		// TODO: Right now, reproxying, redrawing, reloading, etc. is SLOWER than simply drawing in the new cell contents!
		// So what we're going to do with this cell is clear its contents out, then redraw it as if it were a new cell.
		// Keeps the cell pool small and reusable.
		[TiUITableViewRowProxy clearTableRowCell:cell];
        
        // Have to reset the proxy on the cell, and the row's callback cell, as it may have been cleared in reuse operations (or reassigned)
        [(TiUITableViewCell*)cell setProxy:row];
        [row setCallbackCell:(TiUITableViewCell*)cell];
	}
	[row initializeTableViewCell:cell];
	
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)ourTableView
{
	RETURN_IF_SEARCH_TABLE_VIEW(1);
// One quirk of UITableView is that it really hates having 0 sections. Instead, supply 1 section, no rows.
	int result = [(TiUITableViewProxy *)[self proxy] sectionCount];
	return MAX(1,result);
}

- (NSString *)tableView:(UITableView *)ourTableView titleForHeaderInSection:(NSInteger)section
{
	RETURN_IF_SEARCH_TABLE_VIEW(nil);
	TiUITableViewSectionProxy *sectionProxy = [self sectionForIndex:section];
	return [sectionProxy headerTitle];
}

- (NSString *)tableView:(UITableView *)ourTableView titleForFooterInSection:(NSInteger)section
{
	RETURN_IF_SEARCH_TABLE_VIEW(nil);
	TiUITableViewSectionProxy *sectionProxy = [self sectionForIndex:section];
	return [sectionProxy footerTitle];
}

// After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
- (void)tableView:(UITableView *)ourTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	RETURN_IF_SEARCH_TABLE_VIEW();
	if (editingStyle==UITableViewCellEditingStyleDelete)
	{
		TiUITableViewSectionProxy *section = [self sectionForIndex:[indexPath section]];
		NSInteger index = [self indexForIndexPath:indexPath];
		UITableView *table = [self tableView];
		NSIndexPath *path = [self indexPathFromInt:index];
		
		// note, trigger action before the update since on the last delete it will be gone..
		[self triggerActionForIndexPath:indexPath fromPath:nil tableView:ourTableView wasAccessory:NO search:NO name:@"delete"];
		
		[[section rows] removeObjectAtIndex:[indexPath row]];
        
        // If the section is empty, we want to remove it as well.
        BOOL emptySection = ([[section rows] count] == 0);
        if (emptySection) {
            [[(TiUITableViewProxy *)[self proxy] sections] removeObjectAtIndex:[indexPath section]];
        }

		[table beginUpdates];
        if (emptySection)
		{
			NSIndexSet * thisSectionSet = [NSIndexSet indexSetWithIndex:[indexPath section]];
			if([(TiUITableViewProxy *)[self proxy] sectionCount] > 0)
			{
				[table deleteSections:thisSectionSet withRowAnimation:UITableViewRowAnimationFade];
			}
			else	//There always must be at least one section. So instead, we have it reload to clear out the header and footer, etc.
			{
				[table reloadSections:thisSectionSet withRowAnimation:UITableViewRowAnimationFade];
			}

        }
		else
		{
			[table deleteRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationFade];
		}

		[table endUpdates];
	}
}

// Individual rows can opt out of having the -editing property set for them. If not implemented, all rows are assumed to be editable.
- (BOOL)tableView:(UITableView *)ourTableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	RETURN_IF_SEARCH_TABLE_VIEW(NO);
	
	TiUITableViewRowProxy *row = [self rowForIndexPath:indexPath];

	//If editable, then this is always true.
	if ([TiUtils boolValue:[row valueForKey:@"editable"] def:editable])
	{
		return YES;
	}

	//Elsewhise, when not editing nor moving, return NO, so that swipes don't trigger.

	if (!editing && !moving)
	{
		return NO;
	}

	//Otherwise, when editing or moving, make sure that both can be done.
	
	return [TiUtils boolValue:[row valueForKey:@"moveable"] def:moving || moveable] || [TiUtils boolValue:[row valueForKey:@"editable"] def:editing];
	
	//Why are we checking editable twice? Well, once it's with the default of editable. The second time with the default of editing.
	//Effectively, editable is being tri-state.
}

- (BOOL)tableView:(UITableView *)ourTableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	RETURN_IF_SEARCH_TABLE_VIEW(NO);
	TiUITableViewRowProxy *row = [self rowForIndexPath:indexPath];

	return [TiUtils boolValue:[row valueForKey:@"indentOnEdit"] def:editing];
}

// Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:
- (BOOL)tableView:(UITableView *)ourTableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
	RETURN_IF_SEARCH_TABLE_VIEW(NO);

	TiUITableViewRowProxy *row = [self rowForIndexPath:indexPath];
	return [TiUtils boolValue:[row valueForKey:@"moveable"] def:moving || moveable];
}

// Allows customization of the editingStyle for a particular cell located at 'indexPath'. If not implemented, all editable cells will have UITableViewCellEditingStyleDelete set for them when the table has editing property set to YES.
- (UITableViewCellEditingStyle)tableView:(UITableView *)ourTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	RETURN_IF_SEARCH_TABLE_VIEW(UITableViewCellEditingStyleNone);
	TiUITableViewRowProxy *row = [self rowForIndexPath:indexPath];

	//Yes, this looks similar to canEdit, but here we need to make the distinction between moving and editing.
	
	//Actually, it's easier than that. editable or editing causes this to default true. Otherwise, it's the editable flag.
	if ([TiUtils boolValue:[row valueForKey:@"editable"] def:editable || editing])
	{
		return UITableViewCellEditingStyleDelete;
	}
	return UITableViewCellEditingStyleNone;
}


- (void)tableView:(UITableView *)ourTableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
	RETURN_IF_SEARCH_TABLE_VIEW();
	int fromSectionIndex = [sourceIndexPath section];
	int toSectionIndex = [destinationIndexPath section];
	
	TiUITableViewSectionProxy *fromSection = [self sectionForIndex:fromSectionIndex];
	TiUITableViewSectionProxy *toSection = fromSectionIndex!=toSectionIndex ? [self sectionForIndex:toSectionIndex] : fromSection;
	
	TiUITableViewRowProxy *fromRow = [fromSection rowAtIndex:[sourceIndexPath row]];
	TiUITableViewRowProxy *toRow = [toSection rowAtIndex:[destinationIndexPath row]];
	
	// hold during the move in case the array is the last guy holding the retain count
	[fromRow retain];
	[toRow retain];
	
	[[fromSection rows] removeObjectAtIndex:[sourceIndexPath row]];
	[[toSection rows] insertObject:fromRow atIndex:[destinationIndexPath row]];
	
	// rewire our properties
	fromRow.section = toSection;
	toRow.section = fromSection;
	
	fromRow.row = [destinationIndexPath row];
	toRow.row = [sourceIndexPath row];
	
	// now we can release from our retain above
	[fromRow autorelease];
	[toRow autorelease];
	
	[self triggerActionForIndexPath:destinationIndexPath fromPath:sourceIndexPath tableView:ourTableView wasAccessory:NO search:NO name:@"move"];
}

#pragma mark Collation

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)ourTableView
{
	RETURN_IF_SEARCH_TABLE_VIEW(nil);
	if (sectionIndex!=nil && editing==NO)
	{
		return sectionIndex;
	}
	return nil;
}

- (NSInteger)tableView:(UITableView *)ourTableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
	if (sectionIndexMap!=nil)
	{
		// get the section for the row index
		int index = [[sectionIndexMap objectForKey:title] intValue];
		return [self sectionIndexForIndex:index];
	}
	return 0;
}

-(void)selectRow:(id)args
{
	NSInteger index = [TiUtils intValue:[args objectAtIndex:0]];
	NSIndexPath *path = [self indexPathFromInt:index];
	if (initiallyDisplayed==NO)
	{
		RELEASE_TO_NIL(initialSelection);
		initialSelection = [path retain];
		return;
	}
	NSDictionary *dict = [args count] > 1 ? [args objectAtIndex:1] : nil;
	BOOL animated = [TiUtils boolValue:@"animated" properties:dict def:YES];
	int scrollPosition = [TiUtils intValue:@"position" properties:dict def:UITableViewScrollPositionMiddle];
	[[self tableView] selectRowAtIndexPath:path animated:animated scrollPosition:scrollPosition];
}

-(void)deselectRow:(id)args
{
	NSInteger index = [TiUtils intValue:[args objectAtIndex:0]];
	NSDictionary *dict = [args count] > 1 ? [args objectAtIndex:1] : nil;
	BOOL animated = [TiUtils boolValue:@"animated" properties:dict def:YES];
	NSIndexPath *path = [self indexPathFromInt:index];
	[[self tableView] deselectRowAtIndexPath:path animated:animated];
}

#pragma mark Delegate

- (void)tableView:(UITableView *)ourTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	BOOL search = NO;
	if (allowsSelectionSet==NO || [ourTableView allowsSelection]==NO)
	{
		[ourTableView deselectRowAtIndexPath:indexPath animated:YES];
	}
	if(ourTableView != tableview)
	{
		search = YES;
	}
	[self triggerActionForIndexPath:indexPath fromPath:nil tableView:ourTableView wasAccessory:NO search:search name:@"click"];
}


-(void)tableView:(UITableView *)ourTableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSIndexPath* index = indexPath;
	if (ourTableView != tableview) {
		index = [self indexPathFromSearchIndex:[indexPath row]];
	}
	
	TiUITableViewRowProxy *row = [self rowForIndexPath:index];
	
	NSString *color = [row valueForKey:@"backgroundColor"];
	if (color==nil)
	{
		color = [self.proxy valueForKey:@"rowBackgroundColor"];
		if (color==nil)
		{
			color = [self.proxy valueForKey:@"backgroundColor"];
		}
	}
	UIColor * cellColor = [Webcolor webColorNamed:color];
	cell.backgroundColor = (cellColor != nil)?cellColor:[UIColor whiteColor];
	
	if (tableview == ourTableView) {
		TiUITableViewSectionProxy *section = [self sectionForIndex:[indexPath section]];
		if (initiallyDisplayed==NO && [indexPath section]==[(TiUITableViewProxy *)[self proxy] sectionCount]-1 && [indexPath row]==[section rowCount]-1)
		{
			// we need to track when we've initially rendered the last row
			initiallyDisplayed = YES;
			
			// trigger the initial selection
			if (initialSelection!=nil)
			{
				// we seem to have to do this after this has fully completed so we 
				// just spin off and do this just a few ms later
				NSInteger index = [self indexForIndexPath:initialSelection];
				NSDictionary *dict = [NSDictionary dictionaryWithObject:NUMBOOL(NO) forKey:@"animated"];
				NSArray *args = [NSArray arrayWithObjects:NUMINT(index),dict,nil];
				[self performSelector:@selector(selectRow:) withObject:args afterDelay:0.09];
				RELEASE_TO_NIL(initialSelection);
			}
		}
	}
}

- (NSString *)tableView:(UITableView *)ourTableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
	RETURN_IF_SEARCH_TABLE_VIEW(nil);
	TiUITableViewRowProxy * ourRow = [self rowForIndexPath:indexPath];
	NSString * result = [TiUtils stringValue:[ourRow valueForKey:@"deleteButtonTitle"]];
	if (result == nil)
	{
		result = [[self proxy] valueForKey:@"deleteButtonTitle"];
	}

	if (result == nil)
	{
		result = NSLocalizedString(@"Delete",@"Table View Delete Confirm");
	}
	return result;
}

- (void)tableView:(UITableView *)ourTableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	[self triggerActionForIndexPath:indexPath fromPath:nil tableView:ourTableView wasAccessory:YES search:NO name:@"click"];
}

- (NSInteger)tableView:(UITableView *)ourTableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
	RETURN_IF_SEARCH_TABLE_VIEW(0);

	TiUITableViewRowProxy *row = [self rowForIndexPath:indexPath];
	id indent = [row valueForKey:@"indentionLevel"];
	return indent == nil ? 0 : [TiUtils intValue:indent];
}

- (CGFloat)tableView:(UITableView *)ourTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSIndexPath* index = indexPath;
	if (ourTableView != tableview) {
		index = [self indexPathFromSearchIndex:[indexPath row]];
	}
	
	TiUITableViewRowProxy *row = [self rowForIndexPath:index];
	
	CGFloat width = [row sizeWidthForDecorations:tableview.bounds.size.width forceResizing:YES];
	CGFloat height = [row rowHeight:width];
	height = [self tableRowHeight:height];
	return height < 1 ? tableview.rowHeight : height;
}

- (UIView *)tableView:(UITableView *)ourTableView viewForHeaderInSection:(NSInteger)section
{
	RETURN_IF_SEARCH_TABLE_VIEW(nil);
	return [self sectionView:section forLocation:@"headerView" section:nil];
}

- (UIView *)tableView:(UITableView *)ourTableView viewForFooterInSection:(NSInteger)section
{
	RETURN_IF_SEARCH_TABLE_VIEW(nil);
	return [self sectionView:section forLocation:@"footerView" section:nil];
}

- (CGFloat)tableView:(UITableView *)ourTableView heightForHeaderInSection:(NSInteger)section
{
	RETURN_IF_SEARCH_TABLE_VIEW(ourTableView.sectionHeaderHeight);
	TiUITableViewSectionProxy *sectionProxy = nil;
	TiUIView *view = [self sectionView:section forLocation:@"headerView" section:&sectionProxy];
	TiViewProxy *viewProxy = (TiViewProxy *)[view proxy];
	CGFloat size = 0;
	if (viewProxy!=nil)
	{
		LayoutConstraint *viewLayout = [viewProxy layoutProperties];
		switch (viewLayout->height.type)
		{
			case TiDimensionTypePixels:
				size += viewLayout->height.value;
				break;
			case TiDimensionTypeAuto:
				size += [viewProxy autoHeightForWidth:[tableview bounds].size.width];
				break;
			default:
				size+=DEFAULT_SECTION_HEADERFOOTER_HEIGHT;
				break;
		}
	}
    /*
     * This behavior is slightly more complex between iOS 4 and iOS 5 than you might believe, and Apple's
     * documentation is once again misleading. It states that in iOS 4 this value was "ignored if
     * -[delegate tableView:viewForHeaderInSection:] returned nil" but apparently a non-nil value for
     * -[delegate tableView:titleForHeaderInSection:] is considered a valid value for height handling as well,
     * provided it is NOT the empty string.
     * 
     * So for parity with iOS 4, iOS 5 must similarly treat the empty string header as a 'nil' value and
     * return a 0.0 height that is overridden by the system.
     */
	else if ([sectionProxy headerTitle]!=nil)
	{
        if ([TiUtils isIOS5OrGreater] && [[sectionProxy headerTitle] isEqualToString:@""]) {
            return size;
        }
		size+=[tableview sectionHeaderHeight];
        
        if (size < DEFAULT_SECTION_HEADERFOOTER_HEIGHT) {
            size += DEFAULT_SECTION_HEADERFOOTER_HEIGHT;            
        }
	}
	return size;
}

- (CGFloat)tableView:(UITableView *)ourTableView heightForFooterInSection:(NSInteger)section
{
	RETURN_IF_SEARCH_TABLE_VIEW(ourTableView.sectionFooterHeight);
	TiUITableViewSectionProxy *sectionProxy = nil;
	TiUIView *view = [self sectionView:section forLocation:@"footerView" section:&sectionProxy];
	TiViewProxy *viewProxy = (TiViewProxy *)[view proxy];
	CGFloat size = 0;
	BOOL hasTitle = NO;
	if (viewProxy!=nil)
	{
		LayoutConstraint *viewLayout = [viewProxy layoutProperties];
		switch (viewLayout->height.type)
		{
			case TiDimensionTypePixels:
				size += viewLayout->height.value;
				break;
			case TiDimensionTypeAuto:
				size += [viewProxy autoHeightForWidth:[tableview bounds].size.width];
				break;
			default:
				size+=DEFAULT_SECTION_HEADERFOOTER_HEIGHT;
				break;
		}
	}
	else if ([sectionProxy footerTitle]!=nil)
	{
		hasTitle = YES;
		size+=[tableview sectionFooterHeight];
	}
	if (hasTitle && size < DEFAULT_SECTION_HEADERFOOTER_HEIGHT)
	{
		size += DEFAULT_SECTION_HEADERFOOTER_HEIGHT;
	}
	return size;
}

-(void)keyboardDidShowAtHeight:(CGFloat)keyboardTop
{
	int lastSectionIndex = [(TiUITableViewProxy *)[self proxy] sectionCount]-1;
	ENSURE_CONSISTENCY(lastSectionIndex>=0);
	CGRect minimumContentRect = [tableview rectForSection:lastSectionIndex];
	InsetScrollViewForKeyboard(tableview,keyboardTop,minimumContentRect.size.height + minimumContentRect.origin.y);
}

-(void)scrollToShowView:(TiUIView *)firstResponderView withKeyboardHeight:(CGFloat)keyboardTop
{
	int lastSectionIndex = [(TiUITableViewProxy *)[self proxy] sectionCount]-1;
	ENSURE_CONSISTENCY(lastSectionIndex>=0);
	CGRect minimumContentRect = [tableview rectForSection:lastSectionIndex];

	CGRect responderRect = [self convertRect:[firstResponderView bounds] fromView:firstResponderView];
	CGPoint offsetPoint = [tableview contentOffset];
	responderRect.origin.x += offsetPoint.x;
	responderRect.origin.y += offsetPoint.y;

	OffsetScrollViewForRect(tableview,keyboardTop,minimumContentRect.size.height + minimumContentRect.origin.y,responderRect);
}

-(void)keyboardDidShowAtHeight:(CGFloat)keyboardTop forView:(TiUIView *)firstResponderView
{
	int lastSectionIndex = [(TiUITableViewProxy *)[self proxy] sectionCount]-1;
	ENSURE_CONSISTENCY(lastSectionIndex>=0);

	lastFocusedView = firstResponderView;
	CGRect responderRect = [self convertRect:[firstResponderView bounds] fromView:firstResponderView];
	CGPoint offsetPoint = [tableview contentOffset];
	responderRect.origin.x += offsetPoint.x;
	responderRect.origin.y += offsetPoint.y;

	CGRect minimumContentRect = [tableview rectForSection:lastSectionIndex];
	ModifyScrollViewForKeyboardHeightAndContentHeightWithResponderRect(tableview,keyboardTop,minimumContentRect.size.height + minimumContentRect.origin.y,responderRect);
}

#pragma Scroll View Delegate

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView 
{
	// suspend image loader while we're scrolling to improve performance
	[[ImageLoader sharedLoader] suspend];
	return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{	
	if (scrollView.isDragging || scrollView.isDecelerating) 
	{
		if ([self.proxy _hasListeners:@"scroll"])
		{
			NSMutableDictionary *event = [NSMutableDictionary dictionary];
			[event setObject:[TiUtils pointToDictionary:scrollView.contentOffset] forKey:@"contentOffset"];
			[event setObject:[TiUtils sizeToDictionary:scrollView.contentSize] forKey:@"contentSize"];
			[event setObject:[TiUtils sizeToDictionary:tableview.bounds.size] forKey:@"size"];
			[self.proxy fireEvent:@"scroll" withObject:event];
		}
	}
}


- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView 
{
	// resume image loader when we're done scrolling
	[[ImageLoader sharedLoader] resume];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView 
{
	// suspend image loader while we're scrolling to improve performance
	[[ImageLoader sharedLoader] suspend];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate 
{
	if (decelerate==NO)
	{
		// resume image loader when we're done scrolling
		[[ImageLoader sharedLoader] resume];
	}
	if ([self.proxy _hasListeners:@"scrollEnd"])
	{
		NSMutableDictionary *event = [NSMutableDictionary dictionary];
		[event setObject:[TiUtils pointToDictionary:scrollView.contentOffset] forKey:@"contentOffset"];
		[event setObject:[TiUtils sizeToDictionary:scrollView.contentSize] forKey:@"contentSize"];
		[event setObject:[TiUtils sizeToDictionary:tableview.bounds.size] forKey:@"size"];
		[self.proxy fireEvent:@"scrollEnd" withObject:event];
	}
    // Update keyboard status to insure that any fields actively being edited remain in view
    if ([[[TiApp app] controller] keyboardVisible]) {
        [[[TiApp app] controller] performSelector:@selector(handleNewKeyboardStatus) withObject:nil afterDelay:0.0];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView 
{
	// resume image loader when we're done scrolling
	[[ImageLoader sharedLoader] resume];
}

#pragma mark Search Display Controller Delegates


- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
	[self hideSearchScreen:nil];
}

@end

#endif
