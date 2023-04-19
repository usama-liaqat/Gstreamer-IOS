//
//  VideoPlayerApp.swift
//  VideoPlayer
//
//  Created by Usama Liaqat on 17/04/2023.
//

import SwiftUI


@main
struct VideoPlayerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        autoreleasepool {
            gst_ios_init()
        }
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
