//
//  ContentView.swift
//  VideoPlayer
//
//  Created by Usama Liaqat on 17/04/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var isPlaying = false
    @ObservedObject private var serverStatus = RTSPServerStatus.shared
    

    var body: some View {
        VStack {
            if isPlaying {
                RtspPlayer(url: URL(string: "rtsp://127.0.0.1:554/live")!)
            }

            Spacer()
            HStack {
                if serverStatus.running {
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
                        stopRTSPServer()
                    } label: {
                        Label("Stop Server", systemImage: "stop.fill")
                            .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.blue)
                                .cornerRadius(10)
                    }
                    if serverStatus.publishing {
                        Button {
                            stopPublish()
                        } label: {
                            Label("Stop Publish", systemImage: "stop.fill")
                                .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                        }
                    } else {
                        Button {
                            startPublish()
                        } label: {
                            Label("Start Publish", systemImage: "figure.run")
                                .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                        }
                    }
                    
                } else {
                    Button {
                        startRTSPServer()
                    } label: {
                        Label("Start Server", systemImage: "figure.run")
                            .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.blue)
                                .cornerRadius(10)
                    }
                }
                
                
            }.onReceive(serverStatus.$running) { state in
                if !state {
                    isPlaying = false
                }
            }
        }
    }
}

func startRTSPServer() {
    SwiftRTSPServer.runServer(uri: "rtsp://192.168.64.2:554/live")
}

func stopRTSPServer() {
    SwiftRTSPServer.stopServer()
}

func startPublish() {
    SwiftRTSPServer.startPublish(uuid: "c2dd8a36-d219-11ed-afa1-0242ac120002")
}

func stopPublish() {
    SwiftRTSPServer.stopPublish()
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
