//
//  broadcaster.h
//  VideoPlayer
//
//  Created by Usama Liaqat on 17/04/2023.
//

#ifndef broadcaster_h
#define broadcaster_h
#import <Foundation/Foundation.h>
#include <gst/gst.h>

@interface VideoBroadcaster : NSObject
@property (nonatomic) GMainLoop *main_loop;
@property (nonatomic) bool terminate;
- (int)startSource;
@end

#endif /* broadcaster_h */
