//
//  qdemo2App.swift
//  qdemo2
//
//  Created by bill donner on 4/14/24.
//

import SwiftUI
import q20kshare


@main
struct qdemo2App: App {
 let  settings = AppSettings()
    var body: some Scene {
        WindowGroup {
          NavigationSplitView {
            SettingsFormScreen(settings: settings)
          } detail: {
            ContentView(settings: settings)
          }
        }
    }
}
