//
//  EssentialChallengeView.swift
//  qanda
//
//  Created by bill donner on 1/28/24.
//

import SwiftUI
import q20kshare
//import ComposableArchitecture
enum ChallengeOutcomes : Codable,Equatable{
  case unplayed
  case playedCorrectly
  case playedIncorrectly
}
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
  case onceOnlyVirtualyTapped(Int)
}
struct GameState {
  internal init(thisChallenge: Challenge, thisOutcome: ChallengeOutcomes, showing: ShowingState) {
    self.thisChallenge = thisChallenge
    self.thisOutcome = thisOutcome
    self.showing = showing
  }
  
  var thisChallenge:Challenge
  var thisOutcome:ChallengeOutcomes
  var showing:ShowingState
}
extension GameState {
static   let thisChallenge = Challenge(question: "When will they ever learn?", topic: "Flowers", hint: "long time ago", answers: ["most","any","old","song"], correct: "old", id: "UUID320239", date: Date.now, aisource: "donner's brain")
  static var  mock = GameState(thisChallenge: thisChallenge,
                       thisOutcome: ChallengeOutcomes.unplayed, showing: ShowingState.qanda)
  static func makeMock() -> GameState {
    //blast over these globals when mocking
    challenges = [thisChallenge]
    outcomes  = [.unplayed]
    return GameState.mock
  }

}

struct HintBottomSheetView : View {
  let hint:String
  var body: some View {
    VStack {
      Image(systemName:"line.3.horizontal.decrease")
      Spacer()
      HStack{
        Text(hint).font(.headline)
      }
      Spacer()
    }
 .frame(maxWidth:.infinity)
    .background(.blue)//.opacity(0.4)
    .foregroundColor(.white)
   // .ignoresSafeArea()
  }
}


struct EssentialChallengeView: View {
 // @Bindable var store: StoreOf<ChallengesFeature>
  let gameState: GameState
  @State private var hintpressed = false
  var body: some View {
  //  assert (topicIndex==gameState.currentTopicIndex)
    let tc = gameState.thisChallenge
    return ScrollView  {
      withAnimation {
        renderQuestion(gameState: gameState).font(.title).padding(.horizontal)
      }
      VStack { // a place to hang the nav title
        renderAnswers(gameState: gameState)
          .task{
           // gameState.sendChallengeAction(.onceOnlyVirtualyTapped(gameState.currentTopicIndex))
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
            //            if let explanation = tc.explanation {
            //              RoundedTextViewNoGradient(text:explanation,backgroundColor: .white.opacity(0.15))
            //                .borderedStyleStrong( .green)
            //                .padding(.horizontal)
            //            } else {
            EmptyView() //}
            
          case .answerWasIncorrect:
            //            if let explanation = tc.explanation {
            //              RoundedTextViewNoGradient(text:explanation,backgroundColor: .white.opacity(0.15))
            //                .borderedStyleStrong( .red)
            //                .padding(.horizontal)
            //            } else {
            EmptyView()
          //}
          }
        }.frame(minHeight:200)
      } // place to hang
      .sheet(isPresented:$hintpressed) {
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
        return RoundedTextViewGradient(text: tc.question, backgroundColor: Color.blue.opacity(0.1),gradientColor:.blue  )
      case .playedCorrectly:
        return  RoundedTextViewGradient(text: tc.question, backgroundColor: Color.blue.opacity(0.1),gradientColor:.green  )
      case .playedIncorrectly:
        return  RoundedTextViewGradient(text: tc.question, backgroundColor: Color.blue.opacity(0.1),gradientColor:.red  )
      }
  }

  func renderAnswers(gameState:GameState )-> some View {
    let tc = gameState.thisChallenge
    func  renderAnswerButton(index:Int,action:ChallengeActions) -> some View {
        let beenPlayed = gameState.thisOutcome != .unplayed
      return Button(action:{ //gameState.sendChallengeAction(action)
      }){
          withAnimation {
            RoundedTextViewNoGradient(text: tc.answers[index],
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
  EssentialChallengeView(  gameState: GameState.mock)
}
#Preview ("dark"){
  EssentialChallengeView(  gameState: GameState.mock)
 .preferredColorScheme(.dark)
}

