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

let url = URL(string: PRIMARY_REMOTE )!
 
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
func exx(_ n:Int) {
  guard let playData = aiPlayData else {
    fatalError("No playdata when we need it")
  }
   Task {
     let reloaded = try  prepareNewGame(playData,  first:false)
      print("Prepared New Game \(reloaded)") 
      //self.selectedNavItem = Sni(val:n)
    }
}
struct OuterApp : View {

  @State private var showSettings = false
  @State private var showUserSettings = false
  @State private var showHowToPlay = false
  @State private var showOnBoarding = false
  @State private var showTopics = false
  @State private var isSelectedArray = [Bool](repeating: false, count: 26)


  var body: some View{
    NavigationStack {
      MainScreen()
        .navigationBarTitle("Q20K ",displayMode: .inline)
        .navigationBarItems(trailing:
                              Menu {
          Button(action:{ exx(0) }) {
            Text("New Game")
          }
          
          Button(action:{ showHowToPlay.toggle() }) {
            Text("Help")
          }
   
          Button(action: { showUserSettings.toggle() }) {
            Text("Settings")
          }
      
        } label: {
          Label("Select Action", systemImage: "filemenu.and.selection")
        }
        )

    }
    .fullScreenCover(isPresented: $showHowToPlay){
      HowToPlayScreen(isPresented: $showHowToPlay)
    }

    .sheet(isPresented: $showUserSettings){
      GameSettingsScreen(ourTopics: gameState.topics.map {$0.topic}) {
        //        // necessary to recreate
//        for (n,t) in gameState.topics.enumerated() {
//        
//          gameState.topics[n] = LiveTopic(id: UUID(),
//                                          topic:t.topic,isLive:false ,color: colorFor(topic: t.topic))
//          exx(0)
//        }
      }
    }
    .sheet(isPresented: $showSettings){
      FreeportSettingsScreen()
    }

  }
}


#Preview {
  OuterApp()
}
