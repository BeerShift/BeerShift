/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */
#ifdef USE_TI_MEDIA
#import "TiMediaMusicPlayer.h"
#import "MediaModule.h"

@implementation TiMediaMusicPlayer

#pragma mark Internal

// Has to happen on main thread or notifications screw up
-(void)initializePlayer
{
	WARN_IF_BACKGROUND_THREAD_OBJ;	//NSNotificationCenter is not threadsafe!
	NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(stateDidChange:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:player];
	[nc addObserver:self selector:@selector(playingDidChange:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:player];
	[nc addObserver:self selector:@selector(volumeDidChange:) name:MPMusicPlayerControllerVolumeDidChangeNotification object:player];
	
	[player beginGeneratingPlaybackNotifications];	
}

-(id)_initWithPageContext:(id<TiEvaluator>)context player:(MPMusicPlayerController*)player_
{
	if (self = [super _initWithPageContext:context]) {
		player = player_;
		WARN_IF_BACKGROUND_THREAD_OBJ;	//NSNotificationCenter is not threadsafe!
		NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
		[nc addObserver:self selector:@selector(stateDidChange:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:player];
		[nc addObserver:self selector:@selector(playingDidChange:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:player];
		[nc addObserver:self selector:@selector(volumeDidChange:) name:MPMusicPlayerControllerVolumeDidChangeNotification object:player];
		
		[player beginGeneratingPlaybackNotifications];	

		/*
		if (![NSThread isMainThread]) {
			[self performSelectorOnMainThread:@selector(initializePlayer) withObject:nil waitUntilDone:YES];
		}
		else {
			[self initializePlayer];
		}
		 */
	}
	return self;
}

-(void)dealloc
{
	WARN_IF_BACKGROUND_THREAD_OBJ;	//NSNotificationCenter is not threadsafe!
	NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:player];
	[nc removeObserver:self name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:player];
	[nc removeObserver:self name:MPMusicPlayerControllerVolumeDidChangeNotification object:player];
	
	[player endGeneratingPlaybackNotifications];
	
	[super dealloc];
}

#pragma mark Queue management

// Future-proofing for more sophisticated queue management
-(NSArray*)itemsFromArg:(id)args
{
	id arg = args;
	if ([args isKindOfClass:[NSArray class]]) {
		arg = [args objectAtIndex:0];
	}
	NSMutableArray* items = [NSMutableArray array];
	if ([arg isKindOfClass:[NSDictionary class]]) {
		for (TiMediaItem* item in [arg objectForKey:@"items"]) {
			[items addObject:[item item]];
		}
	}
	else if ([arg isKindOfClass:[NSArray class]]) {
		for (TiMediaItem* item in arg) {
			[items addObject:[item item]];
		}
	}
	else if ([arg isKindOfClass:[TiMediaItem class]]) {
		[items addObject:[arg item]];
	}
	else {
		[self throwException:[NSString stringWithFormat:@"Invalid object type %@ for player queue",[arg class]]
				   subreason:nil
					location:CODELOCATION];
	}
	
	return items;
}

-(void)setQueue:(id)arg
{
	[player setQueueWithItemCollection:[MPMediaItemCollection collectionWithItems:[self itemsFromArg:arg]]];
}

#pragma mark Playback management

-(void)play:(id)unused
{
	[player play];
}

-(void)pause:(id)unused
{
	[player pause];
}

-(void)stop:(id)unused
{
	[player stop];
}

-(void)seekForward:(id)unused
{
	[player beginSeekingForward];
}

-(void)seekBackward:(id)unusued
{
	[player beginSeekingBackward];
}

-(void)stopSeeking:(id)unused
{
	[player endSeeking];
}

-(void)skipToNext:(id)unused
{
	[player skipToNextItem];
}

-(void)skipToBeginning:(id)unused
{
	[player skipToBeginning];
}

-(void)skipToPrevious:(id)unused
{
	[player skipToPreviousItem];
}

#pragma mark Property handlers

-(NSNumber*)currentPlaybackTime
{
	return NUMDOUBLE([player currentPlaybackTime]);
}

-(void)setCurrentPlaybackTime:(NSNumber*)time
{
	[player setCurrentPlaybackTime:[time doubleValue]];
}

-(NSNumber*)playbackState
{
	return NUMINT([player playbackState]);
}

-(TiMediaItem*)nowPlaying
{
	return [[[TiMediaItem alloc] _initWithPageContext:[self pageContext] item:[player nowPlayingItem]] autorelease];
}

-(NSNumber*)repeatMode
{
	return NUMINT([player repeatMode]);
}

-(void)setRepeatMode:(NSNumber*)mode
{
	// Sanity check
	switch ([mode intValue]) {
		case MPMusicRepeatModeAll:
		case MPMusicRepeatModeDefault:
		case MPMusicRepeatModeNone:
		case MPMusicRepeatModeOne:
			break;
		default:
			[self throwException:@"Invalid repeat mode" 
					   subreason:nil
						location:CODELOCATION];
	}
	[player setRepeatMode:[mode intValue]];
}

-(NSNumber*)shuffleMode
{
	return NUMINT([player shuffleMode]);
}

-(void)setShuffleMode:(NSNumber*)mode
{
	// Sanity check
	switch ([mode intValue]) {
		case MPMusicShuffleModeOff:
		case MPMusicShuffleModeSongs:
		case MPMusicShuffleModeDefault:
		case MPMusicShuffleModeAlbums:
			break;
		default:
			[self throwException:@"Invalid shuffle mode" 
					   subreason:nil
						location:CODELOCATION];
	}
	[player setShuffleMode:[mode intValue]];
}

-(NSNumber*)volume
{
	return NUMFLOAT([player volume]);
}

-(void)setVolume:(NSNumber*)vol
{
	[player setVolume:[vol floatValue]];
}

#pragma mark Notifications

// TODO: Change to KrollCallback properties for faster response times?
-(void)stateDidChange:(NSNotification*)note
{
	if ([self _hasListeners:@"stateChange"]) {
		[self fireEvent:@"stateChange"];
	}
}

-(void)playingDidChange:(NSNotification*)note
{
	if ([self _hasListeners:@"playingChange"]) {
		[self fireEvent:@"playingChange"];
	}
}

-(void)volumeDidChange:(NSNotification*)note
{
	if ([self _hasListeners:@"volumeChange"]) {
		[self fireEvent:@"volumeChange"];
	}
}

@end
#endif