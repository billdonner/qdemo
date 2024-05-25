//
//  qdemo.swift
//  qdemo
//
//  Created by bill donner on 5/24/24.
//

import SwiftUI


@main struct qDemo: App {
  let  settings = AppSettings(elementWidth: 100.0, shaky: false, shuffleUp: true, rows: 3, fontsize: 24, padding: 5, border: 2)
  var body: some Scene {
    WindowGroup {
        OuterApp(settings:settings)
    }
  }
}

