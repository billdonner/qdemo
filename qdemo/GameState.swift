//
//  GameState.swift
//  qdemo
//
//  Created by bill donner on 4/27/24.
//

import Foundation
import q20kshare
enum Effect:Equatable {
  case none
  case cancelTimer
  case startTimer
}

@Observable class  GameState {
  internal init(selected:Int, showing: ShowingState,outcomes:[ChallengeOutcomes],topics:[LiveTopic],gimmees:Int) {
    self.showing = showing
    self.outcomes = outcomes
    self.topics = topics 
    self.selected = selected
    self.gimmees = gimmees
  }
  

  var showing:ShowingState
  var outcomes:[ChallengeOutcomes] // parallels big challenges array
  var topics:[LiveTopic]
  var selected:Int // index into outcomes and challenges
  var gimmees:Int // bonus points

}

extension GameState {
  var grandScore : Int {
    outcomes.reduce(0) { $0 + ($1 == .playedCorrectly ? 1 : 0 )}
  }
  var grandLosers : Int {
    outcomes.reduce(0) { $0 + ($1 == .playedIncorrectly ? 1 : 0 )}
  }
  var stillToPlay : Int {
    outcomes.reduce(0) { $0 + ($1 == .unplayed ? 1 : 0 )}
  }
  var thisChallenge:Challenge {
   // print("thischallenge selected \(selected) of \(challenges.count)")
    return challenges[selected]
  }
  var thisOutcome:ChallengeOutcomes {
    outcomes[selected]
  }
}

extension GameState {
  static   let onechallenge = Challenge(question: "For Madmen Only", topic: "Flowers", hint: "long time ago", answers: ["most","any","old","song"], correct: "old", id: "UUID320239", date: Date.now, aisource: "donner's brain")
  static var  mock = GameState(selected: 0, showing:.qanda,outcomes:[.unplayed,.unplayed,.unplayed,.unplayed,.unplayed,.unplayed,.unplayed,.unplayed,.unplayed],
                               topics:[LiveTopic(id: UUID(), topic:"Flowers", isLive: true ,color:.blue)], gimmees: 1)
  static func makeMock() -> GameState {
    //blast over these globals when mocking
    challenges = [onechallenge,onechallenge,onechallenge,onechallenge,onechallenge,onechallenge,onechallenge,onechallenge,onechallenge]
    return GameState.mock
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


// Shared toSquareArray Function
func toSquareArray(_ array: [ChallengeOutcomes]) -> [[ChallengeOutcomes]]? {
    let size = Int(sqrt(Double(array.count)))
    if size * size != array.count { return nil } // Ensure the array can be converted into a square matrix
    
    var result = [[ChallengeOutcomes]]()
    for i in 0..<size {
        var row = [ChallengeOutcomes]()
        for j in 0..<size {
            row.append(array[i * size + j]) // Convert to 2D array
        }
        result.append(row)
    }
    return result
}
 
// isPossiblePath Function Implementation
func isPossiblePath(_ linearArray: [ChallengeOutcomes]) -> Bool {
    
    guard let outcomeMatrix = toSquareArray(linearArray) else {
        print("Could not convert array to square")
        return false
    }
    
    let n = outcomeMatrix.count
    var visited = Array(repeating: Array(repeating: false, count: n), count: n)
    let validOutcomes = [ChallengeOutcomes.playedCorrectly, ChallengeOutcomes.unplayed]
    
    func isValid(x: Int, y: Int) -> Bool {
        if x < 0 || y < 0 || x >= n || y >= n || !validOutcomes.contains(outcomeMatrix[x][y]) || visited[x][y] {
            return false
        }
        if x == n - 1 && y == n - 1 { return true }
        
        visited[x][y] = true
        let directions = [(0, 1), (1, 0), (0, -1), (-1, 0), (-1, -1), (1, 1)] // Main and secondary diagonals
        
        for (dx, dy) in directions {
            if isValid(x: x + dx, y: y + dy) {
                return true
            }
        }
        return false
    }
    
    return isValid(x: 0, y: n - 1) // Start from upper right
}

// doesPathExistNow Function Implementation
func doesPathExistNow(_ linearArray: [ChallengeOutcomes]) -> Bool {
    
    guard let outcomeMatrix = toSquareArray(linearArray) else {
        print("Could not convert array to square")
        return false
    }
    
    let n = outcomeMatrix.count
    var visited = Array(repeating: Array(repeating: false, count: n), count: n)
    
    func isValid(x: Int, y: Int) -> Bool {
        if x < 0 || y < 0 || x >= n || y >= n || outcomeMatrix[x][y] != .playedCorrectly || visited[x][y] {
            return false
        }
        if x == n - 1 && y == n - 1 { return true }
        
        visited[x][y] = true
        let directions = [(0, 1), (1, 0), (0, -1), (-1, 0), (-1, -1), (1, 1)] // Main and secondary diagonals
        
        for (dx, dy) in directions {
            if isValid(x: x + dx, y: y + dy) {
                return true
            }
        }
        return false
    }
    
    return isValid(x: 0, y: n - 1) && outcomeMatrix[0][n - 1] == .playedCorrectly // Start from upper right
}
// Test Module
func moduleTest() {
  let testCases: [([ChallengeOutcomes], Bool, Bool)] = [
        ([.unplayed, .unplayed, .unplayed, .unplayed], true, false),
        ([.playedCorrectly, .playedCorrectly, .playedCorrectly, .playedCorrectly], true, true),
        ([.playedIncorrectly, .playedIncorrectly, .playedIncorrectly, .playedIncorrectly], false, false),
        ([.playedCorrectly, .playedCorrectly, .playedIncorrectly, .unplayed], true, false),
        ([.playedCorrectly, .playedCorrectly, .unplayed, .unplayed], true, false),
        ([.unplayed, .playedCorrectly, .playedCorrectly, .playedCorrectly], true, false),
        
        //three by three
        ([.unplayed, .unplayed, .unplayed, .unplayed,.unplayed, .unplayed, .unplayed, .unplayed,.unplayed], true, false),
              ([.playedCorrectly, .playedCorrectly, .playedCorrectly, .playedCorrectly, .playedCorrectly, .playedCorrectly, .playedCorrectly, .playedCorrectly, .playedCorrectly], true, true),
              ([.playedIncorrectly, .playedIncorrectly, .playedIncorrectly, .playedIncorrectly
               , .playedIncorrectly, .playedIncorrectly, .playedIncorrectly, .playedIncorrectly, .playedIncorrectly],false, false),
        
        
    ]
    
    for (index, testCase) in testCases.enumerated() {
        let (array, expectedPossiblePathResult, expectedNowPathResult) = testCase
        
        let possiblePathResult = isPossiblePath(array)
        let nowPathResult = doesPathExistNow(array)
        
        print("Test Case \(index + 1):")
      let a =  array.map{"\($0)"}
        print("Array: \(a)")
        print("isPossiblePath Result: \(possiblePathResult) (Expected: \(expectedPossiblePathResult))")
        print("doesPathExistNow Result: \(nowPathResult) (Expected: \(expectedNowPathResult))")
        print("===================================")
    }
  print("done")
}

// Running the test module
//moduleTest()
