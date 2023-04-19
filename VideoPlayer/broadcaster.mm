//
//  broadcaster.m
//  VideoPlayer
//
//  Created by Usama Liaqat on 17/04/2023.
//

#import "broadcaster.h"

#include <gst/app/gstappsink.h>

@implementation VideoBroadcaster

static void on_rtsp_pad_created(GstElement *element, GstPad *pad, GstElement *other) {
    gchar *pad_name = gst_pad_get_name(pad);
    g_print("New RTSP source found: %s\n", pad_name);
    if (gst_element_link(element, other)) {
        g_print("Source linked.\n");
    } else {
        g_print("Source link FAILED\n");
    }
    g_free(pad_name);
}

static GstFlowReturn on_new_sample(GstElement *sink, gpointer *data) {
    GstSample *sample = NULL;
    GstBuffer *buffer = NULL;
    gpointer copy = NULL;
    gsize copy_size = 0;
    g_signal_emit_by_name (sink, "pull-sample", &sample);
    if (sample) {
        g_print("Source on_new_sample.\n");
        buffer = gst_sample_get_buffer(sample);
        if (buffer) {
            gst_buffer_extract_dup(buffer, 0, gst_buffer_get_size(buffer), &copy, &copy_size);
        }
        gst_sample_unref (sample);
    }

    return GST_FLOW_OK;
}

- (int)startSource {
    GstElement *pipeline;
    GstElement *source;
    GstElement *appsink;
    GstElement *depay;
    GstElement *filter;
    GstStateChangeReturn ret;
    
    gst_init(nil, nil);
    
    pipeline = gst_pipeline_new("rtsp-pipeline");
    source = gst_element_factory_make("rtspsrc", "rtspsrc");
    appsink = gst_element_factory_make("appsink", "appsink");
    depay = gst_element_factory_make("rtph264depay", "rtph264depay");
    filter = gst_element_factory_make("capsfilter", "capsfilter");
    
    
    
    if (!pipeline || !source || !depay || !filter || !appsink) {
        g_printerr("Not all elements could be created:\n");
        if (!pipeline) g_printerr("\tCore pipeline\n");
        if (!source) g_printerr("\trtspsrc (gst-plugins-good)\n");
        if (!depay) g_printerr("\trtph264depay (gst-plugins-good)\n");
        if (!filter) g_printerr("\tcapsfilter (gst-plugins-good)\n");
        if (!appsink) g_printerr("\tappsink (gst-plugins-base)\n");
        return 1;
    }
    GstCaps *h264_caps = gst_caps_new_simple("video/x-h264",
                                                 "stream-format", G_TYPE_STRING, "avc",
                                                 "alignment", G_TYPE_STRING, "au",
                                                 NULL);
    g_object_set(G_OBJECT (filter), "caps", h264_caps, NULL);
    gst_caps_unref(h264_caps);
    
    g_object_set(G_OBJECT (source),
                     "location", "rtsp://127.0.0.1:8554/live",
                     "short-header", true, // Necessary for target camera
                     NULL);
    g_object_set(G_OBJECT (appsink), "emit-signals", TRUE, "sync", FALSE, NULL);
    g_signal_connect(appsink, "new-sample", G_CALLBACK(on_new_sample), &pipeline);
    g_signal_connect(source, "pad-added", G_CALLBACK(on_rtsp_pad_created), depay);
    gst_bin_add_many(GST_BIN (pipeline), source,
                         depay, filter, appsink,
                         NULL);
    
    if (!gst_element_link_many(depay, filter, appsink, NULL)) {
        g_printerr("Elements could not be linked.\n");
        gst_object_unref(pipeline);
        return 1;
    }
    
    ret = gst_element_set_state(pipeline, GST_STATE_PLAYING);
    if (ret == GST_STATE_CHANGE_FAILURE) {
        g_printerr("Unable to set the pipeline to the playing state.\n");
        return 1;
    }
    
    self.main_loop = g_main_loop_new(NULL, FALSE);
    g_main_loop_run(self.main_loop);
    g_printerr("All Elements Linked");
    
    return 0;
}

@end
