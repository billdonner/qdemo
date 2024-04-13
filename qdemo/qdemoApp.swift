//
//  qdemoApp.swift
//  qdemo
//
//  Created by bill donner on 4/9/24.
//

import SwiftUI

@main
struct qdemoApp: App {
 let  settings = AppSettings()
    var body: some Scene {
        WindowGroup {
            ContentView(settings: settings)
        }
    }
}
