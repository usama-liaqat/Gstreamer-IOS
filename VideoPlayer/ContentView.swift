//
//  ContentView.swift
//  VideoPlayer
//
//  Created by Usama Liaqat on 17/04/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var isPlaying = false
    var body: some View {
        VStack {
            if isPlaying {
                RtspPlayer(url: URL(string: "rtsp://127.0.0.1:554/live")!)
            }

            Spacer()
            HStack {
                Button {
                    self.isPlaying = !self.isPlaying
                } label: {
                    if isPlaying {
                        Label("Pause", systemImage: "pause.fill")
                            .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.blue)
                                .cornerRadius(10)
                    } else {
                        Label("Play", systemImage: "play.fill")
                            .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.blue)
                                .cornerRadius(10)
                    }
                    
                }
                Button {
                    print("Edit button was tapped")
                } label: {
                    Label("Edit", systemImage: "pencil")
                }
            }.onAppear(
                perform: startRTSPServer
            )
        }
    }
}

func startRTSPServer() {
    DispatchQueue.global().async {
        let server = RTSPServer();
        server.start();
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
