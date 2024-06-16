//
//  ContentView.swift
//  qdemo2
//
//  Created by bill donner on 4/14/24.
//

import SwiftUI
//import q20kshare

struct MainScreen: View {
  init () {
    formatter.numberStyle = .spellOut 
  }
  @State private var isLoaded = false
  
  var body: some View {
    //NavigationView {
      // ZStack {
      if !isLoaded {
        ProgressView()
          .task {
            do{
              let playdata = try await restorePlayDataURL(url)
              if let playdata = playdata {
                // move into a global place where we can reuse this
                aiPlayData = playdata
                let _ =   try  prepareNewGame(playdata,   first: true  )
                isLoaded = true
              }
            }
            catch {
              print("Could not restore from \(url) \(error.localizedDescription)")
            }
          }
      }
      else {
        QuestionsGridScreen()
      }
    }
  //}
}


fileprivate func restorePlayDataURL(_ url:URL) async  throws -> PlayData? {
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
      print("Loaded"," \(pd.gameDatum.count) topics, \(challengeCount) challenges")
    
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



func prepareNewGame(_ playdata: PlayData,  first:Bool) throws  -> Int{
 
  @AppStorage("boardSize") var boardSize = 6
  let x =  gameState.topics.map{$0.topic}
  let y = playdata.topicData.topics.map{$0.name}
  let filter:[String:Bool] = buildTopicsFilter(topics: first ? y : x, first:first)
  var total = 0
  try nuGame(playdata, reloadTopics: first ){///
    challenge in
    // here is where we can decide  whether to include this question , primarily based on topic
    total += 1
  return filter[challenge.topic] ?? false
  }
   shuffleChallenges()
  let n = gameState.topics.reduce(0) {$0 + ($1.isLive ? 1:0)}
  print("New \(boardSize)x\(boardSize) Game Starting -- \(n) selected topics with \(total) challenges")
  return total
}

fileprivate func nuGame(_ playdata:PlayData, reloadTopics:Bool , isAcceptable:((Challenge)->Bool)) throws {
  @AppStorage("moveNumber") var moveNumber = 0
  // restore challenges from fresh? playdata
    challenges  = freshChallenges(  from:playdata,isAcceptable: isAcceptable)
    freshGameState(  from:playdata,reloadTopics: reloadTopics)
  // reset moveNumber to 0, this will allow clicking again
  moveNumber = 0
    print("************")
}

fileprivate func freshChallenges( from:PlayData,isAcceptable:((Challenge)->Bool)) -> [Challenge]{
  
  @AppStorage("boardSize") var boardSize = 6
  let needs = Int(boardSize*boardSize)
  var r:[Challenge] = []
  var totq: Int = 0
  //keep filling till all we can ever need
  //while totq < Int(settings.rows*settings.rows){
    for gd in from.gameDatum {
      for a in gd.challenges {
        // make sure the topic is acceptable before adding the challenge
        if isAcceptable(a) || boardSize==1 {
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

fileprivate func freshGameState( from playdata:PlayData,reloadTopics:Bool = false ) {
  
  
  @AppStorage("boardSize") var boardSize = 6
  // fresh gamestate
  gameState.showing = .qanda
  gameState.selected = 0
  gameState.gimmees = Int(boardSize)
  gameState.outcomes = Array(repeating:.unplayed,count:Int(boardSize*boardSize))
  if reloadTopics || gameState.topics.count < 2 {
    var tt : [LiveTopic ] = []
    // add in all the topics we got from the playing data
    for (n,t) in playdata.topicData.topics.enumerated() {
      let jj = n %  distinctiveColors.count  // really??
      tt.append(LiveTopic (id: UUID(), topic:t.name,isLive: true,color:distinctiveColors[jj]))
    }
    gameState.topics = tt
  }
}

func  shuffleChallenges(   ) {
    challenges.shuffle() 
}
fileprivate func buildTopicsFilter(topics:[String],first:Bool ) -> [String:Bool] {
  var ret:[String:Bool] = [:]
  if first {
    for t in topics {
      ret [t] = true
    }
  } else {
    for t in topics {
      guard let tt = gameState.topics.first(where:{$0.topic==t})
      else {break}
      if tt.isLive {
        ret[tt.topic] = true
      }
    }
  }
  return ret
  }

#Preview ("Outer"){
  MainScreen()
}
#Preview ("OuterBlack"){
  MainScreen()
    .preferredColorScheme(.dark)
}
