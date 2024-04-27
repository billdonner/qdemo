//
//  ChallengeView.swift
//  stupido
//
//  Created by bill donner on 7/15/23.
//

import SwiftUI
import q20kshare

/*
import ComposableArchitecture

@Reducer
struct ChallengesFeature {
  @ObservableState
  struct State: Equatable {
    
  }
  
  enum Action: BindableAction,Sendable {
    case binding(BindingAction<State>)
  }
  @Dependency(\.continuousClock) var clock
  @Dependency(\.uuid) var uuid
  private enum CancelID { case todoCompletion }
  
  var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
        
      case .binding:
        return .none
      }
      
    }
  }
}
*/
struct ChallengesScreen: View {
 // let selected:Int
 // let backgroundColor: Color
 // let settings:AppSettings
  let gameState:GameState
  
 // @EnvironmentObject var logManager: LogEntryManager
//
//  @Binding var gd: [GameData]
//  let backgroundPic:String
//  let loginID : String
  
  var body: some View {
   // NavigationStack{
     // MenuView(gameState: gameState, gd: $gd)
      // keep Question outside vstack to give it a chance to remain fullsize
      ZStack {

        Image(systemName:"pencil").font(.system(size:250)).foregroundColor(.gray.opacity(0.08))
        VStack {
          Text (gameState.thisChallenge.topic).font(.largeTitle).padding()
          EssentialChallengeView(//store: Store(initialState:ChallengesFeature.State()){ChallengesFeature()},
                                 gameState: gameState)//, topicIndex: topicIndex)
 //         StatsTextView(gameState: gameState)  // show dynamic stats
  //        ChallengesToolbarView(gameState: gameState).navigationTitle(fixTopicName(gameState.thisChallenge.topic))
        }
      }//.navigationTitle(gameState.thisChallenge.topic)
//        .task {
//          // assert (topicIndex==gameState.currentTopicIndex)
//          // gameState.isTimerRunning = gameState.showing == ShowingState.qanda // still fresh
//          // try? await updateTimer(gameState: gameState)
//        }
        .foregroundColor( .primary)
        //.borderedStyleStrong(Color.blue).padding(.horizontal)
        .onDisappear() {
          //          gameState.isTimerRunning = false
          
          //   gameState.addTime(gameState.currentTopic, timeInSecs: Double(gameState.timerCount)/10.0)// get the time
//          
//          Task {
//            sendLogout(LogoutRec(datetime: Date(), initialUUID: loginID),lem: logManager)
//          }
       // }
    }
  }
}
#Preview {
  ChallengesScreen(gameState: GameState.mock)
}
