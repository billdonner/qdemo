//
//  qdemoApp.swift
//  qdemo
//
//  Created by bill donner on 4/9/24.
//

import SwiftUI
import q20kshare


let url = URL(string:"https://billdonner.com/fs/gd/readyforios01.json")!
@main
struct qdemoApp: App {
 let  settings = AppSettings()
    var body: some Scene {
        WindowGroup {
            ContentView(settings: settings)
        }
    }
}


func downloadFile(from url: URL ) async throws -> Data {
let (data, _) = try await URLSession.shared.data(from: url)
return data
}

 func restorePlayDataURL(_ url:URL) async  throws -> PlayData? {
do {
  let start_time = Date()
  let tada = try await  downloadFile(from:url)
  let str = String(data:tada,encoding:.utf8) ?? ""
  do {
    let pd = try JSONDecoder().decode(PlayData.self,from:tada)
    let elapsed = Date().timeIntervalSince(start_time)
    print("************")
    print("Downloaded \(pd.playDataId) in \(elapsed) secs from \(url)")
    let challengeCount = pd.gameDatum.reduce(0,{$0 + $1.challenges.count})
    print("Loaded"," \(pd.gameDatum.count) topics, \(challengeCount) challenges in \(elapsed) secs")
    print("************")
    return pd
  }
  catch {
    print(">>> could not decode playdata from \(url) \n>>> original str:\n\(str)")
  }
}
catch {
  throw error
}
return nil
}


