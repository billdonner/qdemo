//
//  ContentView.swift
//  qdemo2
//
//  Created by bill donner on 4/14/24.
//

import SwiftUI
import q20kshare
func rebuildWorld(  settings:AppSettings) {
       gameState = GameState( selected: 0, showing: .qanda,  outcomes:Array(repeating:.unplayed,count:Int(MAX_ROWS*MAX_COLS)))
  if !settings.shuffleUp {
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
        try await startup()
        rebuildWorld(settings:settings)
        isLoaded = true
        }
      catch {
        print("Could not restore from \(url)")
      }
    }
  }
}

func startup() async throws {
  var gamedatum:[GameData] = []
  let playdata = try await restorePlayDataURL(url)
  if let playdata = playdata {
    gamedatum = playdata.gameDatum
    var r:[Challenge] = []
    var totq: Int = 0
    //keep filling till all we can ever need
    while totq < Int(MAX_ROWS*MAX_COLS){
      for gd in gamedatum {
        for a in gd.challenges {
          r.append(a)
          totq+=1
        }
      }
    }
    challenges = r
    liveTopics = (playdata.topicData.topics.map {$0.name}).map { LiveTopic(topic:$0,isLive:false)}
    print(playdata.playDataId," available; challenges are \(r.count); \(liveTopics.count) topics")
  }
}

#Preview ("Outer"){
  MainScreen(settings:AppSettings())
}


struct MatrixItem: View {
  let number: Int
  let settings:AppSettings
  @Binding var selected:Int
  var onTap: ((Int) -> Void)? // Closure to be executed on tap
  
  var body: some View {
  let backgroundColor = bc(number,settings:settings)
    //let _ = print("MatrixItem \(number)")
    Text(boxCon(number,settings: settings))
      .font(.system(size:settings.fontsize))
      .lineLimit(7)
      .minimumScaleFactor(0.1)
      .frame(width:settings.elementWidth,
             height: settings.elementHeight,
             alignment: .center)
      .background(backgroundColor)
    //.foregroundColor(Color.black)
    //.rotationEffect(.degrees(30))
      .padding(.all, settings.padding)
      .onTapGesture {
        //print("tapping and selecting number \(number)")
        selected = number // pass it thru
        gameState.selected = number // gameState is class
        gameState.showing = .qanda
        onTap?(number) // Execute the closure if it exists
      }
    //      .foregroundStyle(
    //        number<0||number>gameState.outcomes.count-1 ? Color.red :
    //          (gameState.outcomes[number] == .unplayed ? Color.blue:
    //            (gameState.outcomes[number] == .playedCorrectly ? Color.green:.red
    //          )))
      .opacity(
        number<0||number>gameState.outcomes.count-1 ? 0.0:
          (gameState.outcomes[number] == .unplayed ? 1.0:
            (gameState.outcomes[number] == .playedCorrectly ? 0.8:0.8
            )))
      .border(number<0||number>gameState.outcomes.count-1 ? .gray:
                    (gameState.outcomes[number] == .unplayed ? .gray:
                      (gameState.outcomes[number] == .playedCorrectly ? .green:.red
                      )),
                  width:
                    number<0||number>gameState.outcomes.count-1 ? 0.0:
                    (gameState.outcomes[number] == .unplayed ? 1.0:
                      (gameState.outcomes[number] == .playedCorrectly ? 5:5
                      )))
      .rotationEffect(settings.shaky ? .degrees(Double( number % 23)) : .degrees(0))
  }
}
