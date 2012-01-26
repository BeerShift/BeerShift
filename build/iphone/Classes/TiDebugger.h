/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2011 by BeerShift, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */

#include "TiBase.h"

typedef enum {
    OUT,
    LOG_DEBUG, // Have to distinguish from the DEBUG macro
    TRACE,
    WARN,
    ERR
} DebuggerLogLevel;

#ifdef __cplusplus
#define EXTERN_FUNC extern "C"
#else
#define EXTERN_FUNC extern
#endif

EXTERN_FUNC void* TiDebuggerCreate(KrollContext*,TiObjectRef);
EXTERN_FUNC void  TiDebuggerDestroy(KrollContext*,TiObjectRef,void*);
EXTERN_FUNC void  TiDebuggerStart(NSString*,int);
EXTERN_FUNC void  TiDebuggerStop();
EXTERN_FUNC void  TiDebuggerBeginScript(KrollContext*,const char*);
EXTERN_FUNC void  TiDebuggerEndScript(KrollContext*);
EXTERN_FUNC void  TiDebuggerLogMessage(DebuggerLogLevel level,NSString* message);