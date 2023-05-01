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
    @Published var publishing: Bool = false
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
    
    private static func pipelineStatus(state:Bool) {
        DispatchQueue.main.async {
            self.serverStatus.publishing = state
        }
        
        print("Pipeline Status", state)
    }
    
    static func runServer(uri: String){
        DispatchQueue.global().async {
            self.rtspServer.run(uri, withCallback: self.serverStatus)
        }
    }
    
    static func stopServer(){
        self.rtspServer.stop()
    }
    
    static func startPublish(uuid: String){
        DispatchQueue.global().async {
            self.rtspServer.startPublishing("rtsp://192.168.64.2:554/test", withCallback: self.pipelineStatus)
        }
//        createToken(uuid: uuid) { result in
//            switch result {
//                case .success(let response):
//                    print("Success:", response.success)
//                    print("Message:", response.message)
//                    print("URL:", response.data.url.replacingOccurrences(of: ":8080", with: ":554")) // This is now a URL object
//
//                case .failure(let error):
//                    print("Error:", error.localizedDescription)
//                }
//        }
    }
    
    static func stopPublish(){
        self.rtspServer.stopPublishing()
    }
}
