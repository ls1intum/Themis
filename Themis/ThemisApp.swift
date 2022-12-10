//
//  ThemisApp.swift
//  Themis
//
//  Created by Florian Huber on 04.11.22.
//

import SwiftUI
import TouchVisualizer

@main
struct ThemisApp: App {

    init() {
        Visualizer.start()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
