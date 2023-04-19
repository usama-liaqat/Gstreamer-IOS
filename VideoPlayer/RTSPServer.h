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

NS_ASSUME_NONNULL_BEGIN

@interface RTSPServer : NSObject
@property (nonatomic) GMainLoop *loop;
@property (nonatomic) bool terminate;

- (void)startRTSPServer;

@end

NS_ASSUME_NONNULL_END



#endif /* RTSPServer_h */
