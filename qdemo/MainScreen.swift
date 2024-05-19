//
//  ContentView.swift
//  qdemo2
//
//  Created by bill donner on 4/14/24.
//

import SwiftUI
import q20kshare

struct MatrixItem: View {
  let number: Int
  let settings:AppSettings
  var onTap: ((Int) -> Void)? // Closure to be executed on tap
  var onLongPress: ((Int) -> Void)?
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
      .foregroundColor(.black)
      .padding(.all, settings.padding)
      .onTapGesture {
        gameState.selected = number // gameState is class
        gameState.showing = .qanda
        onTap?(number) // Execute the closure if it exists
      }
      .onLongPressGesture {
        onLongPress?(number)
        
      }
      .opacity(cellOpacity(number))
      .border(cellBorderColor(number), width:cellBorderWidth(number) )
      .rotationEffect(settings.shaky ? .degrees(Double( number % 23)) : .degrees(0))
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
        let playdata = try await restorePlayDataURL(url)
        if let playdata = playdata {
          // move into a global place where we can reuse this
          aiPlayData = playdata
          let _ =   try await prepareNewGame(playdata,settings: settings)
       
          isLoaded = true
        }
      }
        catch {
          print("Could not restore from \(url) \(error.localizedDescription)")
        }
      }
    }
}



/////// ***********/////
///

func prepareNewGame(_ playdata: PlayData, settings:AppSettings) async throws  -> Int{
  let filter = buildTopicsFilter()
  var total = 0
  try await newGame(playdata, settings: settings, reloadTopics: true){
    challenge in
    // here is where we can decide  whether to include this question , primarily based on topic
    total += 1
    return filter[challenge.topic] ?? false
  }
   shuffleChallenges(settings:settings)
  let n = gameState.topics.reduce(0) {$0 + ($1.isLive ? 1:0)}
  print("New \(Int(settings.rows))x\(Int(settings.rows)) Game Starting -- \(n) selected topics with \(total) challenges")
  return total
}
fileprivate func newGame(_ playdata:PlayData, settings:AppSettings,reloadTopics:Bool , isAcceptable:((Challenge)->Bool)) async throws {
  // restore challenges from fresh? playdata
    challenges  = freshChallenges(settings:settings, from:playdata,isAcceptable: isAcceptable)
    freshGameState(settings:settings, from:playdata,reloadTopics: reloadTopics)
    print("************")
}
fileprivate func freshChallenges(settings:AppSettings,from:PlayData,isAcceptable:((Challenge)->Bool)) -> [Challenge]{
  let needs = Int(settings.rows*settings.rows)
  var r:[Challenge] = []
  var totq: Int = 0
  //keep filling till all we can ever need
  //while totq < Int(settings.rows*settings.rows){
    for gd in from.gameDatum {
      for a in gd.challenges {
        // make sure the topic is acceptable before adding the challenge
        if isAcceptable(a) || settings.rows==1 {
          r.append(a)
          totq+=1
        }
      }
    }
  if totq <  needs {
    fatalError("not enough items \(totq) need \(needs))")
  }
  return r
}
fileprivate func freshGameState(settings:AppSettings, from playdata:PlayData,reloadTopics:Bool = false ) {
  // fresh gamestate
  gameState.showing = .qanda
  gameState.selected = 0
  gameState.gimmees = Int(settings.rows)
  gameState.outcomes = Array(repeating:.unplayed,count:Int(settings.rows*settings.rows))
  if reloadTopics || gameState.topics.count < 2 {
    var tt : [LiveTopic ] = []
    // add in all the topics we got from the playing data
    for (n,t) in playdata.topicData.topics.enumerated() {
      let jj = n % playdata.topicData.topics.count
      tt.append(LiveTopic (id: UUID(), topic:t.name,isLive: true,color:pastelColors[jj]))
    }
    gameState.topics = tt
  }
}

func  shuffleChallenges(  settings:AppSettings) {
//  gameState = GameState( selected: 0, showing: .qanda,
//                         outcomes:Array(repeating:.unplayed,
//                                        count:Int(settings.rows*settings.rows)),
//                         //TBD: not quite right ?
//                         topics: gameState.topics, gimmees: Int(settings.rows))
  if settings.shuffleUp {
    challenges.shuffle()
  }
}
fileprivate func buildTopicsFilter() -> [String:Bool] {
  var ret:[String:Bool] = [:]
  for t in gameState.topics {
    if t.isLive {
      ret[t.topic] = true
    }
  }
  return ret
  }

#Preview ("Outer"){
  MainScreen(settings:AppSettings.mock)
}
#Preview ("OuterBlack"){
  MainScreen(settings:AppSettings.mock)
    .preferredColorScheme(.dark)
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
 challenges.count>0 ? colorFor(topic:challenges[number].topic) : pastelColors[number % pastelColors.count]
}
