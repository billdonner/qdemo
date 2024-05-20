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
