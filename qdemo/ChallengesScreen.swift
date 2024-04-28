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
  let selected:Int
  var body: some View {
      ZStack {

        Image(systemName:"pencil").font(.system(size:250)).foregroundColor(.gray.opacity(0.08))
        VStack {
          Text (gameState.thisChallenge.topic).font(.largeTitle).padding()
          EssentialChallengeView(  gameState: gameState)
        }
      }
        .foregroundColor( .primary)
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
  ChallengesScreen(selected:0)
}
