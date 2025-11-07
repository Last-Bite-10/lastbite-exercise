////
////  WatchConnectivityManager.swift
////  Exa
////
////  Created by Ammar Alifian Fahdan on 07/11/25.
////
//
//import Foundation
//import WatchConnectivity
//
//class WatchConnectivityManager: NSObject, WCSessionDelegate, ObservableObject {
//    static let watchConnectivityManager = WatchConnectivityManager()
//    private override init() { super.init(); activateSession() }
//    
//    private let session = WCSession.default
//    
//    @Published var bpm: Double = 0.0
//    
//    func activateSession() {
//        guard WCSession.isSupported() else { return }
//        session.delegate = self
//        session.activate()
//    }
//    
//    // MARK: - WCSessionDelegate
//    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
//    
//    func sessionDidBecomeInactive(_ session: WCSession) {}
//    func sessionDidDeactivate(_ session: WCSession) {
//        session.activate()
//    }
//    
//    // Handle message from Watch
//    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
//        if let bpm = message["bpm"] as? Double {
//            DispatchQueue.main.async {
//                self.bpm = bpm
//                print("Received from Watch: \(bpm)")
//            }
//        }
//    }
//}
