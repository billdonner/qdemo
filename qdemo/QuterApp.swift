//
//  qdemo2App.swift
//  qdemo2
//
//  Created by bill donner on 4/14/24.
//

import SwiftUI
///import q20kshare
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



let formatter = NumberFormatter()

//import ComposableArchitecture
 
struct PopoverTip: Tip {
  var title: Text {
    Text("Adjust Settings")
  }
  var message: Text? {
    Text("Many Adjustments will force a new game")
  }
  var image: Image? {
    Image(systemName: "star")
  }
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

//struct ipadView:View {
//  let settings:AppSettings
//  @State var col: NavigationSplitViewColumn =  .detail
//  var body: some View {
//    //open with detail view on top
//    NavigationSplitView(preferredCompactColumn: $col) {
//      SettingsFormScreen(settings: settings )
//    } detail: {
//      MainScreen(settings: settings)
//        .navigationTitle("Q20K for iPad")
//    }
//  }
//}

struct OuterApp : View {
  let settings:AppSettings
  @State private var showSettings = false
  @State private var showHowToPlay = false
  @State private var showOnBoarding = false
  @State private var showTopics = false
  @State private var isSelectedArray = [Bool](repeating: false, count: 26)
    @State   var showAlert = false
  func exx(_ n:Int) {
    guard let playData = aiPlayData else {
      fatalError("No playdata when we need it")
    }
     Task {
        self.settings.rows = Double(n + 3);
       let reloaded = try  prepareNewGame(playData, settings: settings,first:false)
        print("Prepared New Game \(reloaded)")
        //self.selectedNavItem = Sni(val:n)
      }
  }
  var body: some View{
    NavigationStack {
      MainScreen(settings: settings)
        .navigationBarTitle("Q20K ",displayMode: .inline)
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
          Button(action:{ showHowToPlay.toggle() }) {
            Text("How To Play")
          }
          Button(action:{ showOnBoarding.toggle() }) {
            Text("OnBoarding")
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
    .fullScreenCover(isPresented: $showHowToPlay){
      HowToPlayScreen(isPresented: $showHowToPlay)
    }
    .fullScreenCover(isPresented: $showOnBoarding){
      OnboardingScreen(isPresented: $showOnBoarding)
    }
    .sheet(isPresented: $showSettings){
      SettingsFormScreen(settings: settings)
    }
    .sheet(isPresented: $showTopics){
      TopicSelectorScreen( settings:settings, isSelectedArray: $isSelectedArray ){ // on the way back
        // necessary to recreate
        for (n,t) in gameState.topics.enumerated() {
          gameState.topics[n] = LiveTopic(id: UUID(), topic:t.topic,isLive:isSelectedArray[n],color: distinctiveColors[n])
        }
      }
    }
  }
}



