//
//  ExaWatchApp.swift
//  ExaWatch Watch App
//
//  Created by Ammar Alifian Fahdan on 27/10/25.
//

import SwiftUI

@main
struct ExaWatch_Watch_AppApp: App {
    @StateObject private var manager = WatchHealthManager()
    
    var body: some Scene {
        WindowGroup {
            RecordView()
        }
    }
}
