//
//  qdemo2App.swift
//  qdemo2
//
//  Created by bill donner on 4/14/24.
//

import SwiftUI
import q20kshare

let PRIMARY_REMOTE = "https://billdonner.com/fs/gd/readyforios01.json"
let SECONDARY_REMOTE = "https://billdonner.com/fs/gd/readyforios02.json"
let TERTIARY_REMOTE = "https://billdonner.com/fs/gd/readyforios03.json"

let container = "iCloud.com.billdonner.gentest"
let zone = "_defaultZone"
let correctColor:Color = .green.opacity(0.1)
let incorrectColor:Color = .red.opacity(0.1)
let unplayedColor:Color = .blue.opacity(0.1)

var isIpad: Bool {
  UIDevice.current.systemName == "iPadOS"
}

let url = URL(string:"https://billdonner.com/fs/gd/readyforios02.json")!

let MAX_ROWS = 40.0
let MAX_COLS = 40.0

var challenges:[Challenge] = []
var gameState = GameState.makeMock() // will replace 

let pastelColors: [Color] = [ 
  Color(red: 0.98, green: 0.89, blue: 0.85),
  Color(red: 0.85, green: 0.95, blue: 0.98),
  Color(red: 0.98, green: 0.87, blue: 0.90),
  Color(red: 0.84, green: 0.98, blue: 0.85),
  Color(red: 0.86, green: 0.91, blue: 0.98),
  Color(red: 0.98, green: 0.85, blue: 0.87),
  Color(red: 0.96, green: 0.85, blue: 0.98),
  Color(red: 0.98, green: 0.93, blue: 0.90),
  Color(red: 0.90, green: 0.87, blue: 0.98),
  Color(red: 0.98, green: 0.92, blue: 0.85),
  Color(red: 0.88, green: 0.85, blue: 0.98),
  Color(red: 0.98, green: 0.85, blue: 0.89),
  Color(red: 0.85, green: 0.98, blue: 0.96),
  Color(red: 0.93, green: 0.85, blue: 0.98),
  Color(red: 0.90, green: 0.98, blue: 0.87),
  Color(red: 0.87, green: 0.90, blue: 0.98),
  Color(red: 0.98, green: 0.90, blue: 0.83),
  Color(red: 0.83, green: 0.96, blue: 0.98),
  Color(red: 0.92, green: 0.88, blue: 0.98),
  Color(red: 0.98, green: 0.95, blue: 0.89),
  Color(red: 0.89, green: 0.98, blue: 0.93),
  Color(red: 0.85, green: 0.89, blue: 0.98),
  Color(red: 0.98, green: 0.91, blue: 0.87),
  Color(red: 0.91, green: 0.98, blue: 0.85),
  Color(red: 0.85, green: 0.87, blue: 0.98),
]


let formatter = NumberFormatter()


func colorFor(topic:String) -> Color {
  let p = abs(topic.hashValue % pastelColors.count)
 // print("shoowing for \(p)")
  return  pastelColors[p]
}

// Convert number to words
func convertNumberToWords(_ number: Int) -> String? {
  let r =  formatter.string(from: NSNumber(value: number)) ?? ""
  return  (r as NSString).replacingOccurrences(of: "-", with: " ")
}
// Convert number to question from q20k
func convertNumberToQuestion(_ number: Int) -> String? {
  guard number > 0 && number <= challenges.count else {return nil}
  
  return challenges [number-1].question
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

func boxCon (_ number:Int,settings:AppSettings) -> String {
  switch settings.displayOption {
  case .numeric: break
  case .questions:
    let a = convertNumberToQuestion(number)
    if a != nil { return a! }
    
    
    
  case .worded:
    let b = convertNumberToWords(number)
    if b != nil {return b! }
  }
  return "\(number)"
}

@main
struct qdemoApp: App {
 let  settings = AppSettings()
  
  
  @State private var showSettings = false
  @State var col: NavigationSplitViewColumn =  .detail
    var body: some Scene {
      WindowGroup {
        if isIpad {
          //open with detail view on top
          NavigationSplitView(preferredCompactColumn: $col) {
            SettingsFormScreen(settings: settings)
          } detail: {
            
            MainScreen(settings: settings)
              .navigationTitle("Q20K Lab ")
            
          }
        }
        else {
          NavigationStack {
            MainScreen(settings: settings)
              .navigationTitle("Q20K Laboratory")
              .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("settings") {
                                  showSettings.toggle()
                                }
                            }
                        }
          }.sheet(isPresented: $showSettings, content: {
            SettingsFormScreen(settings: settings)
          })
        }
      }
    }
}
