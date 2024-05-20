//
//  qdemo2App.swift
//  qdemo2
//
//  Created by bill donner on 4/14/24.
//

import SwiftUI
import q20kshare
import TipKit

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

let url = URL(string:SECONDARY_REMOTE)!

let MAX_ROWS = 8.0
let MAX_COLS = 8.0
let MIN_ROWS = 3.0
let MIN_COLS = 3.0


var challenges:[Challenge] = []
var gameState = GameState.makeMock() // will replace
var aiPlayData:PlayData? = nil // loaded from readyforios, topics moved to gamestate, challenges filtered into challenges

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

//import ComposableArchitecture

enum ShowingState : Codable,Equatable {
  case qanda
  case hint
  case answerWasCorrect
  case answerWasIncorrect
}
enum ChallengeActions: Equatable {
  case cancelButtonTapped
  case nextButtonTapped
  case previousButtonTapped
  case answer1ButtonTapped
  case answer2ButtonTapped
  case answer3ButtonTapped
  case answer4ButtonTapped
  case answer5ButtonTapped
  case hintButtonTapped
  case infoButtonTapped
  case thumbsUpButtonTapped
  case thumbsDownButtonTapped
  case timeTick
  case virtualTimerButtonTapped
  case onceOnlyVirtualyTapped//(Int)
}

struct ipadView:View {
  let settings:AppSettings
  @State var col: NavigationSplitViewColumn =  .detail
  var body: some View {
    //open with detail view on top
    NavigationSplitView(preferredCompactColumn: $col) {
      SettingsFormScreen(settings: settings )
    } detail: {
      MainScreen(settings: settings)
        .navigationTitle("Q20K for iPad")
    }
  }
}
struct Sni:Identifiable {
  let id = UUID()
  var val:Int
}
struct iphoneView : View {
  let settings:AppSettings
  @State private var selectedNavItem: Sni? = nil
  @State private var showSettings = false
  @State private var showTopics = false
  @State private var newGameKicker:NewGameKicker?=nil
  @State private var isSelectedArray = [Bool](repeating: false, count: 26)
    @State   var showAlert = false
  func exx(_ n:Int) {
    guard let playData = aiPlayData else {
      fatalError("No playdata when we need it")
    }
     Task {
        self.settings.rows = Double(n + 3);
        let reloaded = try await prepareNewGame(playData, settings: settings)
        print("Prepared New Game \(reloaded)")
        //self.selectedNavItem = Sni(val:n)
      }
  }
  var body: some View{
    NavigationStack {
      MainScreen(settings: settings)
        .navigationBarTitle("Q20K for iPhone",displayMode: .inline)
        .navigationBarItems(trailing:
        Menu {
          Button(action:{ exx(0) }) {
            Text("New 3x3 Game")
          }
          Button(action:{ exx(1) }) {
            Text("New 4x4 Game")
          }
          Button(action:{ exx(2) }) {
            Text("New 5x5 Game")
          }
          Button(action:{ exx(3) }) {
            Text("New 6x6 Game")
          }
          Button(action:{ exx(4) }) {
            Text("New 7x7 Game")
          }
          Button(action:{ exx(5) }) {
            Text("New 8x8 Game")
          }
          Button(action: { showSettings.toggle() }) {
            Text("Freeport Settings")
          }
        } label: {
          Label("Select Action", systemImage: "arrowtriangle.down.circle")
        }
        )
      
        .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            Button {
              showTopics.toggle()
            } label: {
              Image(systemName: "list.bullet")//.padding()//EdgeInsets(top:isIpad ? 40:10, leading: 0, bottom: 40, trailing: 20))
            }
          }
        }
    }

    .sheet(item:$selectedNavItem) { item in
      NewGameScreen(sni:item)
    }
    .sheet(isPresented: $showSettings){
      SettingsFormScreen(settings: settings)
    }
    .sheet(isPresented: $showTopics){
      TopicSelectorScreen( isSelectedArray: $isSelectedArray ){ // on the way back
        // necessary to recreate
        for (n,t) in gameState.topics.enumerated() {
          gameState.topics[n] = LiveTopic(id: UUID(), topic:t.topic,isLive:isSelectedArray[n],color:pastelColors[n])
        }
      }
    }
  }
}

struct NewGameKicker : Identifiable{
  let id = UUID()
  var val: Int
}
@main
struct qdemoApp: App {
  //TBD: rows must be one because full topics not set yet until after download
  
  let  settings = AppSettings(elementWidth: 100.0, shaky: false, shuffleUp: true, rows: 3, fontsize: 24, padding: 5, border: 2)

  var body: some Scene {
    WindowGroup {
      if isIpad {
        ipadView(settings:settings)
      }
      else {
        iphoneView(settings:settings)
      }
    }
  }
}
struct NewGameScreen: View {
  let sni:Sni
  var body: some View {
    ZStack {
      DismissButtonView()
      Text("New Game size \(sni.val+3)x\(sni.val+3)")
    }
  }
}



/**
 .sheet(item:$newGameKicker){item in
 NewGameScreen(val: item.val)
 }
 .sheet(isPresented: $showSettings){
 SettingsFormScreen(settings: settings)
 }
 .sheet(isPresented: $showTopics){
 TopicSelectorScreen( isSelectedArray: $isSelectedArray ){ // on the way back
 // necessary to recreate
 for (n,t) in gameState.topics.enumerated() {
 gameState.topics[n] = LiveTopic(id: UUID(), topic:t.topic,isLive:isSelectedArray[n],color:pastelColors[n])
 }
 }
 }
 
 //                      ToolbarItem(placement: .navigationBarTrailing) {
 //                        Button {
 //                          showSettings.toggle()
 //                        } label: {
 //                          Image(systemName: "gear")//.padding()//EdgeInsets(top:isIpad ? 40:10, leading: 0, bottom: 40, trailing: 20))
 //
 //                        }
 //                      }
 //          ToolbarItem(placement: .navigationBarTrailing) {
 //            Button {
 //              newGameKicker = NewGameKicker(val: 3) // just testing
 //            } label: {
 //              Image(systemName: "pencil")//.padding()//EdgeInsets(top:isIpad ? 40:10, leading: 0, bottom: 40, trailing: 20))
 //
 //            }
 //        }
 */
