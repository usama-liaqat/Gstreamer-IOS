//
//  RTSPServer.m
//  RemmieHealth
//
//  Created by Usama Liaqat on 27/03/2023.
//

#import <Foundation/Foundation.h>
#import "RTSPServer.h"
#include <gst/gst.h>
#include <gst/app/gstappsink.h>
#include <gst/rtsp-server/rtsp-server.h>


@implementation RTSPServer

- (void)runServer:(NSString*)uri withCallback:(void (^)(BOOL))live_status {
    GstRTSPServer *server;
    GstRTSPMountPoints *mounts;
    GstRTSPMediaFactory *factory;
    gchar *launch_string;
    gchar *Port = "554";
    gchar *url = (gchar *)[uri UTF8String];;
    
    gst_init(0, nil);
    
    self.serverLoop = g_main_loop_new (NULL, FALSE);
    
    server = gst_rtsp_server_new ();
    g_object_set (server, "service", Port, NULL);
    mounts = gst_rtsp_server_get_mount_points (server);

    factory = gst_rtsp_media_factory_new ();
    launch_string = g_strdup_printf("( rtspsrc location=%s ! rtph264depay ! h264parse ! rtph264pay name=pay0 pt=96 )", url);
    gst_rtsp_media_factory_set_launch(factory, launch_string);
    gst_rtsp_media_factory_set_shared (factory, TRUE);
    gst_rtsp_media_factory_set_enable_rtcp (factory, TRUE);
    gst_rtsp_mount_points_add_factory(mounts, "/live", factory);
    
    g_object_unref (mounts);
    
    gst_rtsp_server_attach (server, NULL);
    
    self.local_rtsp_url = g_strdup_printf("rtsp://127.0.0.1:%s/live", Port);
    
    g_print("stream ready at %s\n", self.local_rtsp_url);
    
    live_status(true);
    g_main_loop_run (self.serverLoop);
    live_status(false);
    g_print("RTSP Server Stopped");
}

- (void)stopServer {
    g_main_loop_quit(self.serverLoop);
}

- (void)startPublishing:(NSString*)uri {}

- (void)stopPublishing {
    g_main_loop_quit(self.publisherLoop);
}

@end
