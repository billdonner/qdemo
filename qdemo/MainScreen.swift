//
//  ContentView.swift
//  qdemo2
//
//  Created by bill donner on 4/14/24.
//

import SwiftUI
import q20kshare
func rebuildWorld(  settings:AppSettings) {
  gameState = GameState( selected: 0, showing: .qanda,  outcomes:Array(repeating:.unplayed,count:Int(MAX_ROWS*MAX_COLS)),
                         //TBD: not quite right
                         topics: gameState.topics)
  if settings.shuffleUp {
    challenges.shuffle()
  }
}

struct MainScreen: View {
  let settings:AppSettings
  init (settings:AppSettings) {
    formatter.numberStyle = .spellOut
    self.settings = settings
  }
  @State private var isLoaded = false
  var body: some View {
    //  NavigationView {
    ZStack {
      ProgressView().opacity(!isLoaded ? 1.0:0.0)
      QuestionsGridScreen(settings:settings)
        .opacity(isLoaded ? 1.0:0.0)
    }
    .task {
      do{
        try await startup(){_ in 
          return true
        }
        rebuildWorld(settings:settings)
        isLoaded = true
        }
      catch {
        print("Could not restore from \(url)")
      }
    }
  }
}

func startup(isAcceptable:((Challenge)->Bool)) async throws {

  let playdata = try await restorePlayDataURL(url)
  
  // restore challenges from fresh? playdata
  if let playdata = playdata {
    var gamedatum:[GameData] = []
    gamedatum = playdata.gameDatum
    var r:[Challenge] = []
    var totq: Int = 0
    //keep filling till all we can ever need
    while totq < Int(MAX_ROWS*MAX_COLS){
      for gd in gamedatum {
        for a in gd.challenges {
          // make sure the topic is acceptable before adding the challenge
          if isAcceptable(a) {
            r.append(a)
            totq+=1
          }
        }
      }
    }
    challenges = r
    
    // fresh gamestate
    gameState.showing = .qanda
    gameState.outcomes = Array(repeating:.unplayed,count:Int(challenges.count))
    var tt : [LiveTopic ] = []
    // add in all the topics we got from the playing data
    for (n,t) in playdata.topicData.topics.enumerated() {
      let jj = n % playdata.topicData.topics.count
      tt.append(LiveTopic (topic:t.name,isLive: true,color:pastelColors[jj]))
    }
    gameState.topics = tt
   
    print("************")
  }
}

#Preview ("Outer"){
  MainScreen(settings:AppSettings.mock)
}
func cellOpacity(_ number:Int) -> Double {
  number<0||number>gameState.outcomes.count-1 ? 0.0:
    (gameState.outcomes[number] == .unplayed ? 1.0:
      (gameState.outcomes[number] == .playedCorrectly ? 0.8:0.8
      ))
}
func cellBorderColor(_ number:Int) -> Color {
  number<0||number>gameState.outcomes.count-1 ? .gray:
                (gameState.outcomes[number] == .unplayed ? .gray:
                  (gameState.outcomes[number] == .playedCorrectly ? .green:.red
                  ))
}
func cellBorderWidth(_ number:Int) -> Double {
  number<0||number>gameState.outcomes.count-1 ? 0.0:
  (gameState.outcomes[number] == .unplayed ? 1.0:
    (gameState.outcomes[number] == .playedCorrectly ? 5:5
    ))
}
func cellColorFromTopic(_ number:Int)->Color {
 return challenges.count>0 ? colorFor(topic:challenges[number].topic) : pastelColors[number % pastelColors.count]
}

struct MatrixItem: View {
  let number: Int
  let settings:AppSettings
  var onTap: ((Int) -> Void)? // Closure to be executed on tap

  var body: some View {
    //let _ = print("MatrixItem \(number)")
    Text(boxCon(number,settings: settings))
      .font(.system(size:settings.fontsize))
      .lineLimit(7)
      .minimumScaleFactor(0.1)
      .frame(width:settings.elementWidth,
             height: settings.elementWidth, //square for now
             alignment: .center)
      .background(cellColorFromTopic(number))
      .padding(.all, settings.padding)
      .onTapGesture {
        gameState.selected = number // gameState is class
        gameState.showing = .qanda
        onTap?(number) // Execute the closure if it exists
      }
      .opacity(cellOpacity(number))
      .border(cellBorderColor(number), width:cellBorderWidth(number) )
      .rotationEffect(settings.shaky ? .degrees(Double( number % 23)) : .degrees(0))
  }
}
