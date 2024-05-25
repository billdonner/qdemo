//
//  GameState.swift
//  qdemo
//
//  Created by bill donner on 4/27/24.
//

import Foundation
////import q20kshare
 
//
//@Observable class  GameState {
//  internal init(selected:Int, showing: ShowingState,outcomes:[ChallengeOutcomes],topics:[LiveTopic],gimmees:Int) {
//    self.showing = showing
//    self.outcomes = outcomes
//    self.topics = topics 
//    self.selected = selected
//    self.gimmees = gimmees
//  }
//  
//
//  var showing:ShowingState
//  var outcomes:[ChallengeOutcomes] // parallels big challenges array
//  var topics:[LiveTopic]
//  var selected:Int // index into outcomes and challenges
//  var gimmees:Int // bonus points
//
//}
//
//extension GameState {
//  var grandScore : Int {
//    outcomes.reduce(0) { $0 + ($1 == .playedCorrectly ? 1 : 0 )}
//  }
//  var grandLosers : Int {
//    outcomes.reduce(0) { $0 + ($1 == .playedIncorrectly ? 1 : 0 )}
//  }
//  var stillToPlay : Int {
//    outcomes.reduce(0) { $0 + ($1 == .unplayed ? 1 : 0 )}
//  }
//  var thisChallenge:Challenge {
//    return challenges[selected]
//  }
//  var thisOutcome:ChallengeOutcomes {
//    outcomes[selected]
//  }
//}


extension GameState {
  enum Effect:Equatable {
    case none
    case cancelTimer
    case startTimer
  }

  @discardableResult
  func sendChallengeAction(_ action:ChallengeActions) -> Effect {
    
    switch action {
    case .cancelButtonTapped:
      return .none
    case .nextButtonTapped:
//      if self.questionNumber < playData.gameDatum[self.currentTopicIndex].challenges.count - 1 {
//        self.setQuestionNumber(self.questionNumber + 1 )
//        //  self.timerCount = 0
//        self.showing = .qanda
//        self.save() // save all changes
        return .startTimer
      
      
    case .previousButtonTapped:
//      if self.questionNumber > 0 {
//        self.setQuestionNumber(self.questionNumber - 1 )
//        //  self.timerCount = 0
//        self.showing = .qanda
//        self.save() // save all changes
        return .startTimer
      
    case .answer1ButtonTapped:
      answerButtonTapped(0)
      return .cancelTimer
    case .answer2ButtonTapped:
      answerButtonTapped(1)
      return .cancelTimer
    case .answer3ButtonTapped:
      answerButtonTapped(2)
      return .cancelTimer
    case .answer4ButtonTapped:
      answerButtonTapped(3)
      return .cancelTimer
    case .answer5ButtonTapped:
      answerButtonTapped(4)
      return .cancelTimer
    case .hintButtonTapped:
      if self.showing == .qanda
      {self.showing = .hint} // dont stop timer
    case .timeTick:
      //  self.timerCount += 1
      return .none
    case .virtualTimerButtonTapped:
      return .startTimer
    case .onceOnlyVirtualyTapped://(let topicIndex):
      //self.currentTopicIndex = topicIndex
      // self.timerCount = 0
      self.showing = .qanda
      return .startTimer
    case .infoButtonTapped:
      return .none
    case .thumbsUpButtonTapped:
      return .none
    case .thumbsDownButtonTapped:
      return .none
    }
    
    return .none
  }
  
  private  func answerButtonTapped( _ idx:Int) {
 
    let t =  thisChallenge.correct == thisChallenge.answers[idx]
//    var outcomes = self.scoresByTopic[self.currentTopic]?.outcomes ?? Array(repeating:.unplayed,count:playData.gameDatum[self.currentTopicIndex].challenges.count)
//    let times = self.scoresByTopic[self.currentTopic]?.time ?? Array(repeating:0.0,count:playData.gameDatum[self.currentTopicIndex].challenges.count)
    let oc =  t ? ChallengeOutcomes.playedCorrectly : .playedIncorrectly
    // if unplayed
    if outcomes [self.selected] == ChallengeOutcomes.unplayed {
      // adjust the outcome
      outcomes [self.selected] = oc
      // adjust the time
      
     // self.scoresByTopic[self.currentTopic] =
     // TopicGroupData(topic:self.currentTopic,outcomes: outcomes, time: times, questionNumber: self.questionNumber)
      // self.addTime(self.currentTopic, timeInSecs: Double(self.timerCount)/10.0)// get the time
      
    }
    self.showing = t ? .answerWasCorrect : .answerWasIncorrect
    // self.isTimerRunning = false
   // self.save() // save all changes
    
    //print("updated \(self.selected) with outcome \(oc)")
  }
  
}

