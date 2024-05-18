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
        DismissButtonView()
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
struct EssentialChallengeView: View {
  let gameState:GameState
  @State private var hintpressed = false
  var body: some View {
    //  assert (topicIndex==gameState.currentTopicIndex)
 
    return ScrollView  {
      withAnimation {
        renderQuestion(gameState: gameState).font(.title).padding(.horizontal)
      }
      VStack { // a place to hang the nav title
        renderAnswers(gameState: gameState)
          .task{
       gameState.sendChallengeAction(.onceOnlyVirtualyTapped)
          }// task
        Spacer()
        //SHOW Hint and Mark the Answers
        VStack {
          switch gameState.showing {
          case .qanda:
            Button("hint") {
              hintpressed.toggle()
            }
          case .hint:
            EmptyView()
          case .answerWasCorrect:
              HStack {  Text("Correct").bold() ; Text (gameState.thisChallenge.explanation  ?? "")} .padding(.horizontal) .padding(.horizontal)
            
          case .answerWasIncorrect:
            HStack {  Text("Incorrect ").bold() ; Text (gameState.thisChallenge.explanation  ?? "")} .padding(.horizontal)
            //}
          }
        }.frame(minHeight:200)
      } // place to hang
      .sheet(isPresented:$hintpressed) {
      let tc = challenges[gameState.selected]
        HintBottomSheetView(hint: tc.hint)
        //.padding()
          .presentationDetents([.fraction(0.33)])
      }
    }//end of scrollview
  }
}

func renderQuestion(gameState:GameState) -> some View {
  let tc = gameState.thisChallenge
  switch( gameState.thisOutcome ){
  case .unplayed:
    return QuestionSoloView(text: tc.question, backgroundColor: Color.blue.opacity(0.1),gradientColor:.blue  )
  case .playedCorrectly:
    return  QuestionSoloView(text: tc.question, backgroundColor: Color.blue.opacity(0.1),gradientColor:.green  )
  case .playedIncorrectly:
    return  QuestionSoloView(text: tc.question, backgroundColor: Color.blue.opacity(0.1),gradientColor:.red  )
  }
}

func renderAnswers(gameState:GameState )-> some View {
  let tc = gameState.thisChallenge
  
  func  renderAnswerButton(index:Int,action:ChallengeActions) -> some View {
    let beenPlayed = gameState.thisOutcome != .unplayed
    return Button(action:{gameState.sendChallengeAction(action)
    }){
      withAnimation {
                AnswerSoloView(text: tc.answers[index],
                                  backgroundColor: ((beenPlayed && tc.answers[index] == tc.correct) ?
                                                    correctColor : ((beenPlayed) ? incorrectColor : unplayedColor)))
      }
      .border(beenPlayed && tc.answers[index] == tc.correct ? .green:.clear,width:10)
      .padding(.horizontal)
    }
  }
  
  return  VStack {
    if tc.answers.count>0 {
      renderAnswerButton( index: 0,action:ChallengeActions.answer1ButtonTapped)
    }
    if tc.answers.count>1 {
      renderAnswerButton( index: 1,action:.answer2ButtonTapped)
    }
    if tc.answers.count>2 {
      renderAnswerButton( index: 2,action:.answer3ButtonTapped)
    }
    if tc.answers.count>3 {
      renderAnswerButton( index: 3,action:.answer4ButtonTapped)
    }
    if tc.answers.count>4 {
      renderAnswerButton( index: 4,action:.answer5ButtonTapped)
    }
  }
}



#Preview ("light"){
  EssentialChallengeView(  gameState: GameState.makeMock())
}
#Preview ("dark"){
  EssentialChallengeView(  gameState: GameState.makeMock())
    .preferredColorScheme(.dark)
}

