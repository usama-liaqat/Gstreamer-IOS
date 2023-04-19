//
//  ContentView.swift
//  VideoPlayer
//
//  Created by Usama Liaqat on 17/04/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
                .padding()
                .onAppear {
                    startRTSPServer()
                }
                
        }
        .padding()
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
