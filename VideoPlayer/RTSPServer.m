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



static gboolean bus_call(GstBus *bus, GstMessage *msg, gpointer data) {
    GMainLoop *loop = (GMainLoop *)data;
    gboolean should_stop = FALSE;

    switch (GST_MESSAGE_TYPE(msg)) {
        case GST_MESSAGE_EOS:
            g_print("End of stream\n");
            should_stop = TRUE;
            break;
        case GST_MESSAGE_ERROR: {
            gchar *debug;
            GError *error;
            gst_message_parse_error(msg, &error, &debug);
            g_free(debug);
            g_print("Error: %s\n", error->message);
            g_error_free(error);
            should_stop = TRUE;
            break;
        }
        default:
            break;
    }

    if (should_stop) {
        g_main_loop_quit(loop);
    }

    return TRUE;
}


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

- (void)startPublishing:(NSString*)uri withCallback:(void (^)(BOOL))live_status {
//    GstBus *bus;
//    gchar *launch_string;
//    gchar *url = (gchar *)[uri UTF8String];;
//
//
//    self.publishLoop = g_main_loop_new(NULL, FALSE);
//    gst_init(0, nil);
//
//    launch_string = g_strdup_printf("rtspsrc location=%s ! parsebin ! queue ! rtspclientsink location=%s", self.local_rtsp_url, url);
//
//    g_print(launch_string);
//    self.publishPipeline = gst_parse_launch(launch_string, nil);
//
//
//    gst_element_set_state(self.publishPipeline, GST_STATE_PLAYING);
//
//    live_status(true);
//    bus = gst_pipeline_get_bus(GST_PIPELINE(self.publishPipeline));
//    gst_bus_add_watch(bus, bus_call, self.publishLoop);
//    gst_object_unref(bus);
//    g_main_loop_run(self.publishLoop);
//
//    gst_element_set_state(self.publishPipeline, GST_STATE_NULL);
//    gst_object_unref(self.publishPipeline);
//
//    live_status(false);
    
    NSString *local_rtsp_url = [NSString stringWithUTF8String:self.local_rtsp_url];
    NSString *command = [NSString stringWithFormat:@"-f rtsp -i %@ -c:v copy -f rtsp -rtsp_transport tcp %@", local_rtsp_url, uri];

    live_status(true);
    self.session = [FFmpegKit execute:command];
    
    ReturnCode *returnCode = [self.session getReturnCode];
    if ([ReturnCode isSuccess:returnCode]) {
        
        // SUCCESS

    } else if ([ReturnCode isCancel:returnCode]) {
        live_status(false);
        // CANCEL

    } else {
        live_status(false);
        // FAILURE
        NSLog(@"Command failed with state %@ and rc %@.%@", [FFmpegKitConfig sessionStateToString:[self.session getState]], returnCode, [self.session getFailStackTrace]);

    }
}

- (void)stopPublishing {
//    gst_element_set_state(self.publishPipeline, GST_STATE_NULL);
//    g_main_loop_quit(self.publishLoop);
    long sessionId = [self.session getSessionId];
    [FFmpegKit cancel:sessionId];
}

@end
