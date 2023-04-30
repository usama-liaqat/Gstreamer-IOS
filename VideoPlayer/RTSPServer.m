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

- (void)startRTSPServer {
    GMainLoop *loop;
    GstRTSPServer *server;
    GstRTSPMountPoints *mounts;
    GstRTSPMediaFactory *factory;
    gchar *Port = "554";
    
    gst_init(0, nil);
    
    loop = g_main_loop_new (NULL, FALSE);
    
    server = gst_rtsp_server_new ();
    g_object_set (server, "service", Port, NULL);
    mounts = gst_rtsp_server_get_mount_points (server);

    factory = gst_rtsp_media_factory_new ();
    gst_rtsp_media_factory_set_launch(factory, "( rtspsrc location=rtsp://192.168.64.2:554/live ! rtph264depay ! h264parse ! rtph264pay name=pay0 pt=96 )");
    gst_rtsp_media_factory_set_shared (factory, TRUE);
    gst_rtsp_media_factory_set_enable_rtcp (factory, TRUE);
    gst_rtsp_mount_points_add_factory(mounts, "/live", factory);
    
    g_object_unref (mounts);
    
    gst_rtsp_server_attach (server, NULL);
    
    g_print("stream ready at rtsp://127.0.0.1:%s/live\n", Port);
    
    g_main_loop_run (loop);
    
    g_print("RTSP Server Stopped");
}

@end
