#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "AWSTranscribeStreaming.h"
#import "AWSTranscribeStreamingClientDelegate.h"
#import "AWSTranscribeStreamingEventDecoder.h"
#import "AWSTranscribeStreamingModel.h"
#import "AWSTranscribeStreamingResources.h"
#import "AWSTranscribeStreamingService.h"
#import "AWSTranscribeStreamingWebSocketProvider.h"

FOUNDATION_EXPORT double AWSTranscribeStreamingVersionNumber;
FOUNDATION_EXPORT const unsigned char AWSTranscribeStreamingVersionString[];

