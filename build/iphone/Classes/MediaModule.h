/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */
#ifdef USE_TI_MEDIA

#import "TiModule.h"
#import "KrollCallback.h"
#import "TiMediaAudioSession.h"
#import "MediaPlayer/MediaPlayer.h"
#import "TiMediaMusicPlayer.h"

@interface MediaModule : TiModule
<
	UINavigationControllerDelegate,
	UIImagePickerControllerDelegate, 
	MPMediaPickerControllerDelegate
	,UIVideoEditorControllerDelegate
> {
@private
	// Camera picker
	UIImagePickerController *picker;
	BOOL autoHidePicker;
	BOOL saveToRoll;

	// Music picker
	MPMediaPickerController* musicPicker;
	
	// Music players
	TiMediaMusicPlayer* systemMusicPlayer;
	TiMediaMusicPlayer* appMusicPlayer;
	
	// Shared picker bits; OK, since they're modal (and we can perform sanity checks for the necessary bits)
	BOOL animatedPicker;
	KrollCallback *pickerSuccessCallback;
	KrollCallback *pickerErrorCallback;
	KrollCallback *pickerCancelCallback;
	
	id popover;
	
	UIVideoEditorController *editor;
	KrollCallback *editorSuccessCallback;
	KrollCallback *editorErrorCallback;
	KrollCallback *editorCancelCallback;
}

+(NSDictionary*)itemProperties;
+(NSDictionary*)filterableItemProperties;

@property(nonatomic,readonly) CGFloat volume;
@property(nonatomic,readonly) CGFloat peakMicrophonePower;
@property(nonatomic,readonly) CGFloat averageMicrophonePower;
@property(nonatomic,readonly) NSInteger audioLineType;
@property(nonatomic,readonly) BOOL audioPlaying;
@property(nonatomic,readonly) BOOL isCameraSupported;
@property(nonatomic, assign) NSNumber* audioSessionMode;
@property(nonatomic,readonly) TiMediaMusicPlayer* systemMusicPlayer;
@property(nonatomic,readonly) TiMediaMusicPlayer* appMusicPlayer;

@property(nonatomic,readonly) NSNumber* UNKNOWN_ERROR;
@property(nonatomic,readonly) NSNumber* DEVICE_BUSY;
@property(nonatomic,readonly) NSNumber* NO_CAMERA;
@property(nonatomic,readonly) NSNumber* NO_VIDEO;
@property(nonatomic,readonly) NSNumber* NO_MUSIC_PLAYER;

// these have been deprecated in 3.2 but we map them to their new values
@property(nonatomic,readonly) NSNumber* VIDEO_CONTROL_DEFAULT;
@property(nonatomic,readonly) NSNumber* VIDEO_CONTROL_VOLUME_ONLY;
@property(nonatomic,readonly) NSNumber* VIDEO_CONTROL_HIDDEN;

@property(nonatomic,readonly) NSNumber* VIDEO_SCALING_NONE;
@property(nonatomic,readonly) NSNumber* VIDEO_SCALING_ASPECT_FIT;
@property(nonatomic,readonly) NSNumber* VIDEO_SCALING_ASPECT_FILL;
@property(nonatomic,readonly) NSNumber* VIDEO_SCALING_MODE_FILL;

@property(nonatomic,readonly) NSNumber* QUALITY_HIGH;
@property(nonatomic,readonly) NSNumber* QUALITY_MEDIUM;
@property(nonatomic,readonly) NSNumber* QUALITY_LOW;
@property(nonatomic,readonly) NSNumber* QUALITY_640x480;
 
@property(nonatomic,readonly) NSArray* availableCameraMediaTypes;
@property(nonatomic,readonly) NSArray* availablePhotoMediaTypes;
@property(nonatomic,readonly) NSArray* availablePhotoGalleryMediaTypes;

@property(nonatomic,readonly) NSNumber* CAMERA_FRONT;
@property(nonatomic,readonly) NSNumber* CAMERA_REAR;
@property(nonatomic,readonly) NSArray* availableCameras;

@property(nonatomic,readonly) NSNumber* CAMERA_FLASH_OFF;
@property(nonatomic,readonly) NSNumber* CAMERA_FLASH_AUTO;
@property(nonatomic,readonly) NSNumber* CAMERA_FLASH_ON;

@property(nonatomic,readonly) NSString* MEDIA_TYPE_VIDEO;
@property(nonatomic,readonly) NSString* MEDIA_TYPE_PHOTO;

@property(nonatomic,readonly) NSNumber* AUDIO_HEADSET_INOUT;
@property(nonatomic,readonly) NSNumber* AUDIO_RECEIVER_AND_MIC;
@property(nonatomic,readonly) NSNumber* AUDIO_HEADPHONES_AND_MIC;
@property(nonatomic,readonly) NSNumber* AUDIO_LINEOUT;
@property(nonatomic,readonly) NSNumber* AUDIO_HEADPHONES;
@property(nonatomic,readonly) NSNumber* AUDIO_SPEAKER;
@property(nonatomic,readonly) NSNumber* AUDIO_MICROPHONE;
@property(nonatomic,readonly) NSNumber* AUDIO_MUTED;
@property(nonatomic,readonly) NSNumber* AUDIO_UNAVAILABLE;
@property(nonatomic,readonly) NSNumber* AUDIO_UNKNOWN;

@property(nonatomic,readonly) NSNumber* AUDIO_FORMAT_LINEAR_PCM;
@property(nonatomic,readonly) NSNumber* AUDIO_FORMAT_ULAW;
@property(nonatomic,readonly) NSNumber* AUDIO_FORMAT_ALAW;
@property(nonatomic,readonly) NSNumber* AUDIO_FORMAT_IMA4;
@property(nonatomic,readonly) NSNumber* AUDIO_FORMAT_ILBC;
@property(nonatomic,readonly) NSNumber* AUDIO_FORMAT_APPLE_LOSSLESS;
@property(nonatomic,readonly) NSNumber* AUDIO_FORMAT_AAC;

@property(nonatomic,readonly) NSNumber* AUDIO_FILEFORMAT_WAVE;
@property(nonatomic,readonly) NSNumber* AUDIO_FILEFORMAT_AIFF;
@property(nonatomic,readonly) NSNumber* AUDIO_FILEFORMAT_MP3;
@property(nonatomic,readonly) NSNumber* AUDIO_FILEFORMAT_MP4;
@property(nonatomic,readonly) NSNumber* AUDIO_FILEFORMAT_MP4A;
@property(nonatomic,readonly) NSNumber* AUDIO_FILEFORMAT_CAF;
@property(nonatomic,readonly) NSNumber* AUDIO_FILEFORMAT_3GPP;
@property(nonatomic,readonly) NSNumber* AUDIO_FILEFORMAT_3GP2;
@property(nonatomic,readonly) NSNumber* AUDIO_FILEFORMAT_AMR;

@property(nonatomic,readonly) NSNumber* AUDIO_SESSION_MODE_AMBIENT;
@property(nonatomic,readonly) NSNumber* AUDIO_SESSION_MODE_SOLO_AMBIENT;
@property(nonatomic,readonly) NSNumber* AUDIO_SESSION_MODE_PLAYBACK;
@property(nonatomic,readonly) NSNumber* AUDIO_SESSION_MODE_RECORD;
@property(nonatomic,readonly) NSNumber* AUDIO_SESSION_MODE_PLAY_AND_RECORD;

@property(nonatomic,readonly) NSNumber* MUSIC_MEDIA_TYPE_MUSIC;
@property(nonatomic,readonly) NSNumber* MUSIC_MEDIA_TYPE_PODCAST;
@property(nonatomic,readonly) NSNumber* MUSIC_MEDIA_TYPE_AUDIOBOOK;
@property(nonatomic,readonly) NSNumber* MUSIC_MEDIA_TYPE_ANY_AUDIO;
@property(nonatomic,readonly) NSNumber* MUSIC_MEDIA_TYPE_ALL;

@property(nonatomic,readonly) NSNumber* MUSIC_MEDIA_GROUP_TITLE;
@property(nonatomic,readonly) NSNumber* MUSIC_MEDIA_GROUP_ALBUM;
@property(nonatomic,readonly) NSNumber* MUSIC_MEDIA_GROUP_ARTIST;
@property(nonatomic,readonly) NSNumber* MUSIC_MEDIA_GROUP_ALBUM_ARTIST;
@property(nonatomic,readonly) NSNumber* MUSIC_MEDIA_GROUP_COMPOSER;
@property(nonatomic,readonly) NSNumber* MUSIC_MEDIA_GROUP_GENRE;
@property(nonatomic,readonly) NSNumber* MUSIC_MEDIA_GROUP_PLAYLIST;
@property(nonatomic,readonly) NSNumber* MUSIC_MEDIA_GROUP_PODCAST_TITLE;

@property(nonatomic,readonly) NSNumber* MUSIC_PLAYER_STATE_STOPPED;
@property(nonatomic,readonly) NSNumber* MUSIC_PLAYER_STATE_PLAYING;
@property(nonatomic,readonly) NSNumber* MUSIC_PLAYER_STATE_PAUSED;
@property(nonatomic,readonly) NSNumber* MUSIC_PLAYER_STATE_INTERRUPTED;
@property(nonatomic,readonly) NSNumber* MUSIC_PLAYER_STATE_SKEEK_FORWARD;
@property(nonatomic,readonly) NSNumber* MUSIC_PLAYER_STATE_SEEK_BACKWARD;

@property(nonatomic,readonly) NSNumber* MUSIC_PLAYER_REPEAT_DEFAULT;
@property(nonatomic,readonly) NSNumber* MUSIC_PLAYER_REPEAT_NONE;
@property(nonatomic,readonly) NSNumber* MUSIC_PLAYER_REPEAT_ONE;
@property(nonatomic,readonly) NSNumber* MUSIC_PLAYER_REPEAT_ALL;

@property(nonatomic,readonly) NSNumber* MUSIC_PLAYER_SHUFFLE_DEFAULT;
@property(nonatomic,readonly) NSNumber* MUSIC_PLAYER_SHUFFLE_NONE;
@property(nonatomic,readonly) NSNumber* MUSIC_PLAYER_SHUFFLE_SONGS;
@property(nonatomic,readonly) NSNumber* MUSIC_PLAYER_SHUFFLE_ALBUMS;



#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_2

// NOTE: these are introduced in 3.2
@property(nonatomic,readonly) NSNumber* VIDEO_CONTROL_NONE;			// No controls
@property(nonatomic,readonly) NSNumber* VIDEO_CONTROL_EMBEDDED;		// Controls for an embedded view
@property(nonatomic,readonly) NSNumber* VIDEO_CONTROL_FULLSCREEN;	// Controls for fullscreen playback

@property(nonatomic,readonly) NSNumber* VIDEO_MEDIA_TYPE_NONE;
@property(nonatomic,readonly) NSNumber* VIDEO_MEDIA_TYPE_VIDEO;
@property(nonatomic,readonly) NSNumber* VIDEO_MEDIA_TYPE_AUDIO;

@property(nonatomic,readonly) NSNumber* VIDEO_SOURCE_TYPE_UNKNOWN;
@property(nonatomic,readonly) NSNumber* VIDEO_SOURCE_TYPE_FILE;
@property(nonatomic,readonly) NSNumber* VIDEO_SOURCE_TYPE_STREAMING;

@property(nonatomic,readonly) NSNumber* VIDEO_PLAYBACK_STATE_STOPPED;
@property(nonatomic,readonly) NSNumber* VIDEO_PLAYBACK_STATE_PLAYING;
@property(nonatomic,readonly) NSNumber* VIDEO_PLAYBACK_STATE_PAUSED;
@property(nonatomic,readonly) NSNumber* VIDEO_PLAYBACK_STATE_INTERRUPTED;
@property(nonatomic,readonly) NSNumber* VIDEO_PLAYBACK_STATE_SEEKING_FORWARD;
@property(nonatomic,readonly) NSNumber* VIDEO_PLAYBACK_STATE_SEEKING_BACKWARD;

@property(nonatomic,readonly) NSNumber* VIDEO_LOAD_STATE_UNKNOWN;
@property(nonatomic,readonly) NSNumber* VIDEO_LOAD_STATE_PLAYABLE;
@property(nonatomic,readonly) NSNumber* VIDEO_LOAD_STATE_PLAYTHROUGH_OK;
@property(nonatomic,readonly) NSNumber* VIDEO_LOAD_STATE_STALLED;

@property(nonatomic,readonly) NSNumber* VIDEO_REPEAT_MODE_NONE;
@property(nonatomic,readonly) NSNumber* VIDEO_REPEAT_MODE_ONE;

@property(nonatomic,readonly) NSNumber* VIDEO_TIME_OPTION_NEAREST_KEYFRAME;
@property(nonatomic,readonly) NSNumber* VIDEO_TIME_OPTION_EXACT;

@property(nonatomic,readonly) NSNumber* VIDEO_FINISH_REASON_PLAYBACK_ENDED;
@property(nonatomic,readonly) NSNumber* VIDEO_FINISH_REASON_PLAYBACK_ERROR;
@property(nonatomic,readonly) NSNumber* VIDEO_FINISH_REASON_USER_EXITED;

#endif


@end

#endif