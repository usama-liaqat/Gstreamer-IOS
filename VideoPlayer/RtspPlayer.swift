//
//  RtspPlayer.swift
//  VideoPlayer
//
//  Created by Usama Liaqat on 19/04/2023.
//

import SwiftUI
import AVFoundation
import AVKit
import UIKit

struct VideoPlayer: UIViewControllerRepresentable {
    
    var url: URL
    
    func makeUIViewController(context: Context) -> UIViewController {
        // Create and return a UIViewController here
        let videoPlayer = GStreamerVideoViewController()
        videoPlayer.view.backgroundColor = .black
        videoPlayer.changeURI(url.absoluteString)
        return videoPlayer
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update the view controller here if needed
    }
    
}

struct RtspPlayer: View {
    let url: URL

    init(url: URL) {
        self.url = url
    }
    
    var body: some View {
        VideoPlayer(url: self.url)
    }
    
}

struct RtspPlayer_Previews: PreviewProvider {
    static var previews: some View {
        VideoPlayer(url: URL(string: "rtsp://127.0.0.1:8554/live")!)
    }
}
