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
  case onceOnlyVirtualyTapped//(Int)
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


fileprivate struct QuestionSoloView: View {
  let text: String
  let backgroundColor: Color
  let gradientColor: Color
  var body: some View {
    VStack {
      Text(text)
        .padding()
        .multilineTextAlignment(.center)
        .foregroundColor(.primary)
        .background(
          RoundedRectangle(cornerRadius: 10)
            .fill(
              LinearGradient(
                gradient: Gradient(colors: [gradientColor.opacity(0.1), backgroundColor]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
              )
            )
            .shadow(radius: 5))}}
}

fileprivate struct AnswerSoloView: View {
  let text: String
  let backgroundColor: Color
  var body: some View {
    VStack {
      Text(text)
        .multilineTextAlignment(.center)
        .font(.title)
        .padding()
        .foregroundColor(.primary)
        .background(
          RoundedRectangle(cornerRadius: 10)
            .fill(backgroundColor)
            .shadow(radius: 10)  )  } }
}
struct   QuestionView_Previews: PreviewProvider {
  static var previews: some View {
    VStack{
      QuestionSoloView(text: "Hello, this 999999999 9999999 99999999 \nis a multi-line 88888888888888888888888888888888888888888888888\ntext", backgroundColor: .white.opacity(0.15), gradientColor: .red)
      Spacer()
              AnswerSoloView(text: "Hello, this 999999999 9999999 99999999 \nis a multi-line 88888888888888888888888888888888888888888888888\ntext", backgroundColor:   .white.opacity(0.15) )
    }
    .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
  }
}
fileprivate struct HintBottomSheetView : View {
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
