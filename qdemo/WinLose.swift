//
//  WinLose.swift
//  qdemo
//
//  Created by bill donner on 5/20/24.
//

import Foundation
enum ChallengeOutcomes : Codable,Equatable{
  case unplayed
  case playedCorrectly
  case playedIncorrectly
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
    // case 1 - all unplayed
        ([.unplayed, .unplayed, .unplayed, .unplayed], true/*still possible?*/, false/*winner now*/),
    // case 2 - upper corners covered with correct
        ([.playedCorrectly, .playedCorrectly, .unplayed, .unplayed], true, false),
    // case 3 - lower corners covered with correct
        ([ .unplayed, .unplayed,.playedCorrectly, .playedCorrectly], true, false),
        
    // case 4 - upper corners covered with incorrect
        ([.playedIncorrectly, .playedIncorrectly, .unplayed, .unplayed], false, false),
    // case 5 - lower corners covered with incorrect
        ([ .unplayed, .unplayed,.playedIncorrectly, .playedIncorrectly], false, false),

        // case 6 - main diag covered with incorrect
            ([.playedIncorrectly, .unplayed, .unplayed, .playedIncorrectly], true, false),
        // case 7 - reverse diag covered with incorrect
            ([ .unplayed, .playedIncorrectly,.playedIncorrectly, .unplayed], true, false),
        
        // case 8 - main diag covered with correct
            ([.playedCorrectly, .unplayed, .unplayed, .playedCorrectly], true, false),
        // case 9 - reverse diag covered with correct
            ([ .unplayed, .playedCorrectly,.playedCorrectly, .unplayed], true, false),
        
        // case 10 - left around covered with correct
            ([.playedCorrectly, .unplayed, .playedCorrectly, .playedCorrectly], true, true),
        // case 11 - right around covered with correct
            ([ .unplayed, .playedCorrectly,.playedCorrectly, .playedCorrectly], true, true),
        // case 12 - left around covered with incorrect
            ([.playedIncorrectly, .unplayed, .playedIncorrectly, .playedIncorrectly], false, false),
        // case 13 - right around covered with incorrect
            ([ .unplayed, .playedIncorrectly,.playedIncorrectly, .playedIncorrectly], false, false),
        
        
    // case 3 - all incorrect
        ([.playedIncorrectly, .playedIncorrectly, .playedIncorrectly, .playedIncorrectly], false, false),
        // case 5 - mid game
        ([.playedCorrectly, .playedCorrectly, .playedIncorrectly, .unplayed], true, false),
        // case 6 - mid game
        ([.playedCorrectly, .playedCorrectly, .unplayed, .unplayed], true, false),
        // case 6
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
      if possiblePathResult != expectedNowPathResult {
        print("isPossiblePath Result: \(possiblePathResult) (Expected: \(expectedPossiblePathResult))")
      }
      if nowPathResult != expectedNowPathResult {
        print("doesPathExistNow Result: \(nowPathResult) (Expected: \(expectedNowPathResult))")
      }
        print("===================================")
    }
  print("done")
}

// Running the test module
//moduleTest()
