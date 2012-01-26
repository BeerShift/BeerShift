/*
 
 File: AQRecorder.h
 Abstract: Helper class for recording audio files via the AudioQueue
 Version: 2.4
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2009 Apple Inc. All Rights Reserved.
 
 
 */

#ifdef USE_TI_MEDIA

#include <AudioToolbox/AudioToolbox.h>
#include <Foundation/Foundation.h>
#include <libkern/OSAtomic.h>

#include "CAStreamBasicDescription.h"
#include "CAXException.h"

#define kNumberRecordBuffers	3
#define kBufferDurationSeconds .5

class AQRecorder 
{
public:
	AQRecorder();
	~AQRecorder();
	
	UInt32						GetNumberChannels() const	{ return mRecordFormat.NumberChannels(); }
	CFStringRef					GetFileName() const			{ return mFileName; }
	AudioQueueRef				Queue() const				{ return mQueue; }
	CAStreamBasicDescription	DataFormat() const			{ return mRecordFormat; }
	
	void			StartRecord(CFStringRef inRecordFile,UInt32 fileFormatID);
	void			PauseRecord(); //JGH: added
	void			ResumeRecord(); //JGH: added
	void			StopRecord();		
	Boolean			IsRunning() const			{ return mIsRunning; }
	Boolean			IsPaused() const { return mIsPaused; } //JGH: added
	void			SetupAudioFormat(UInt32 inFormatID);
	
	UInt64			startTime;
	
private:
	CFStringRef					mFileName;
	AudioQueueRef				mQueue;
	AudioQueueBufferRef			mBuffers[kNumberRecordBuffers];
	AudioFileID					mRecordFile;
	SInt64						mRecordPacket; // current packet number in record file
	CAStreamBasicDescription	mRecordFormat;
	Boolean						mIsRunning;
	Boolean						mIsPaused; //JGH: added
	
	void			CopyEncoderCookieToFile();
	int				ComputeRecordBufferSize(const AudioStreamBasicDescription *format, float seconds);
	
	static void MyInputBufferHandler(	void *								inUserData,
									 AudioQueueRef						inAQ,
									 AudioQueueBufferRef					inBuffer,
									 const AudioTimeStamp *				inStartTime,
									 UInt32								inNumPackets,
									 const AudioStreamPacketDescription*	inPacketDesc);
};

#endif