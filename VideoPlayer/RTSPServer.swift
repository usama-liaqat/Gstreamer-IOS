//
//  RTSPServer.swift
//  VideoPlayer
//
//  Created by Usama Liaqat on 30/04/2023.
//

import Foundation

class RTSPServerStatus: ObservableObject {
    static let shared = RTSPServerStatus()
    @Published var running: Bool = false
}

class SwiftRTSPServer {
    private static let rtspServer: RTSPServer = RTSPServer()
    static let shared = SwiftRTSPServer()
    private static let serverStatus:RTSPServerStatus = RTSPServerStatus.shared
    
    private static func serverStatus(state:Bool) {
        DispatchQueue.main.async {
            self.serverStatus.running = state
        }
        
        print("Server Status", state)
    }
    
    static func runServer(uri: String){
        DispatchQueue.global().async {
            self.rtspServer.run(uri, withCallback: self.serverStatus)
        }
    }
    
    static func stopServer(){
        self.rtspServer.stop()
    }
}
