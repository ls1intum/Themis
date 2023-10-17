//
//  ThemisApp.swift
//  Themis
//
//  Created by Florian Huber on 04.11.22.
//

import SwiftUI
import TipKit

@main
struct ThemisApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
//                    Tips.showAllTipsForTesting() // uncomment when debugging tips
                    
                    try? Tips.configure([
                        .displayFrequency(.immediate),
                        .datastoreLocation(.applicationDefault)
                    ])
                }
        }
    }
}
