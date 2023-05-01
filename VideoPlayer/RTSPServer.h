//
//  RTSPServer.h
//  VideoPlayer
//
//  Created by Usama Liaqat on 19/04/2023.
//

#ifndef RTSPServer_h
#define RTSPServer_h

#import <Foundation/Foundation.h>
#include <gst/gst.h>
#include <ffmpegkit/FFmpegKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface RTSPServer : NSObject
@property (nonatomic) GMainLoop *serverLoop;
@property (nonatomic) GstElement *publishPipeline;
@property (nonatomic) GMainLoop *publishLoop;
@property (nonatomic) gchar *local_rtsp_url;
@property (nonatomic) FFmpegSession *session;


- (void)runServer:(NSString*)uri withCallback:(void (^)(BOOL))live_status;
- (void)stopServer;
- (void)startPublishing:(NSString*)uri withCallback:(void (^)(BOOL))live_status;
- (void)stopPublishing;

@end

NS_ASSUME_NONNULL_END



#endif /* RTSPServer_h */
