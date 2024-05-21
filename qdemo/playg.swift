//
//  playg.swift
//  qdemo
//
//  Created by bill donner on 5/21/24.
//

import Foundation

/* SYSTEM

```swift




```
We are interactively building a game in swift and swifUI based on a square matrix of cells.

 

  When generating output:



 - put all the generated swift code at the end

- all generated markdown should be surrounded by swift comments

 - do not surround the swift code with backtick markdown



All test cases must be automated and run under a single command and with summarized results.

 

 ### Game Requirements

 

 1. **Game Board**:

     - The game board is a square matrix consisting of cells.

     - Each cell in the matrix contains one of three possible states from the `ChallengeOutcomes` enum: `unplayed`, `playedCorrectly`, or `playedIncorrectly`.

     - Initially, all cells Weare in the `unplayed` state.



 2. **Cell States**:

     - `empty`: The cell is yet to be played.

     - `correct`: The cell is played correctly.

     - `incorrect`: The cell is played incorrectly.



 3. **Neighbors**:

     - Each cell in the matrix can have up to eight neighboring cells (adjacent horizontally, vertically, or diagonally).



 4. **Winning and Losing Paths**:

     - A winning path is defined as a continuous sequence of cells where every cell is marked as `playedCorrectly`.

     - A winning path starts from any corner of the matrix and must reach the diagonally opposite corner.

     - A losing path is any path that includes at least one cell marked as `playedIncorrectly`.



 5. **Game Evaluation**:

     - As each cell's state is updated, the board is evaluated to determine the following:

         a. Whether a winning path currently exists.

         b. Whether it is still possible to find a winning path in the future.



it is very important the swift code come at the end of the output and without backticks

*/
/* USER

write these functions
```json




When generating test cases:
- ensure each case runs without human intervention
- ensure the results are summarized

write a boolean function to determine if two cells in the matrix are adjacent

 assuming the square matrix is zero origined write a boolean function to determine if there is a winning path on the board right now and to print it. what is the big O complexity of the function?

 test cases of generated function for complex 3x3 boards
 test cases of generated function for complex 4x4 boards

 assuming the square matrix is zero origined write a boolean function to determine if there is a possible winning path on the board and to print it. what is the big O complexity of the function?
 test cases of generated function for complex 3x3 boards
 test cases of generated function for complex 4x4 boards

```

*/// This function checks if two given cells in a square matrix are adjacent.
/// Adjacency is defined as horizontally, vertically, or diagonally neighboring cells.
///
/// - Parameters:
///   - cell1: A tuple representing the coordinates (row, column) of the first cell.
///   - cell2: A tuple representing the coordinates (row, column) of the second cell.
/// - Returns: A boolean value indicating whether the two cells are adjacent.
func areCellsAdjacent(_ cell1: (Int, Int), _ cell2: (Int, Int)) -> Bool {
   let rowDifference = abs(cell1.0 - cell2.0)
   let colDifference = abs(cell1.1 - cell2.1)
   
   return rowDifference <= 1 && colDifference <= 1 && !(rowDifference == 0 && colDifference == 0)
}


/// This function determines if there is a winning path in the current matrix.
/// A winning path is defined as a continuous sequence of cells marked as `correct`
/// that starts from any corner of the matrix and reaches the diagonally opposite corner.
///
/// - Parameter matrix: A square matrix of ChallengeOutcomes representing the current state of the game board.
/// - Returns: A boolean value indicating whether a winning path exists.

//enum ChallengeOutcomes {
//   case unplayed
//   case playedCorrectly
//   case playedIncorrectly
//}


/// This function determines if there is a winning path in the current matrix.
/// A winning path is defined as a continuous sequence of cells marked as `correct`
/// that starts from any corner of the matrix and reaches the diagonally opposite corner.
///
/// - Parameter matrix: A square matrix of ChallengeOutcomes representing the current state of the game board.
/// - Returns: A boolean value indicating whether a winning path exists.



func isWinningPath(in matrix: [[ChallengeOutcomes]]) -> Bool {
   let n = matrix.count
   guard n > 0 else { return false }
   guard matrix[0][0] == .playedCorrectly else { return false }

   // Defines directions: right, down, left, up, and the four diagonals
   let directions = [(0, 1), (1, 0), (0, -1), (-1, 0), (1, 1), (1, -1), (-1, 1), (-1, -1)]
   
   func dfs(_ row: Int, _ col: Int, _ visited: inout Set<String>) -> Bool {
       // Reached bottom-right corner
       if row == n - 1 && col == n - 1 {
           return matrix[row][col] == .playedCorrectly
       }
       
       let key = "\(row),\(col)"
       if visited.contains(key) || matrix[row][col] != .playedCorrectly {
           return false
       }
       
       visited.insert(key)
       
       for direction in directions {
           let newRow = row + direction.0
           let newCol = col + direction.1
           if newRow >= 0, newRow < n, newCol >= 0, newCol < n {
               if dfs(newRow, newCol, &visited) {
                   return true
               }
           }
       }
       
       return false
   }
   
   var visited = Set<String>()
   return dfs(0, 0, &visited)
}
/// This function determines if there is any possible winning path in the future
/// in the given matrix. A possible winning path is defined as a path from the
/// top-left corner to the bottom-right corner that can potentially be turned
/// into a winning path by changing `unplayed` cells to `playedCorrectly`.
///
/// - Parameter matrix: A square matrix of ChallengeOutcomes representing the current state of the game board.
/// - Returns: A boolean value indicating whether a possible winning path exists.


func isPossibleWinningPath(in matrix: [[ChallengeOutcomes]]) -> Bool {
   let n = matrix.count
   guard n > 0 else { return false }
   guard matrix[0][0] != .playedIncorrectly else { return false }

   func dfs(_ row: Int, _ col: Int, _ visited: inout Set<String>) -> Bool {
       if row == n - 1 && col == n - 1 {
           return matrix[row][col] != .playedIncorrectly
       }
       
       let key = "\(row),\(col)"
       if visited.contains(key) || matrix[row][col] == .playedIncorrectly {
           return false
       }
       
       visited.insert(key)
       
       let directions = [(0, 1), (1, 0), (-1, 0), (0, -1)]
       for direction in directions {
           let newRow = row + direction.0
           let newCol = col + direction.1
           if newRow >= 0 && newRow < n && newCol >= 0 && newCol < n {
               if dfs(newRow, newCol, &visited) {
                   return true
               }
           }
       }
       
       return false
   }
   
   var visited = Set<String>()
   return dfs(0, 0, &visited)
}

// --- Unit Tests ---

import XCTest


class WinningPathTests: XCTestCase {
   
   func testEmptyMatrix() {
       let matrix: [[ChallengeOutcomes]] = []
       XCTAssertFalse(isWinningPath(in: matrix))
   }
   
   func testSingleCellPlayedCorrectly() {
       let matrix: [[ChallengeOutcomes]] = [[.playedCorrectly]]
       XCTAssertTrue(isWinningPath(in: matrix))
   }

   func testSingleCellPlayedIncorrectly() {
       let matrix: [[ChallengeOutcomes]] = [[.playedIncorrectly]]
       XCTAssertFalse(isWinningPath(in: matrix))
   }
   
   func test2x2MatrixWinningPath() {
       let matrix: [[ChallengeOutcomes]] = [
           [.playedCorrectly, .playedCorrectly],
           [.playedCorrectly, .playedCorrectly],
       ]
       XCTAssertTrue(isWinningPath(in: matrix))
   }
   
   func test2x2MatrixMainDiagonalWinningPath() {
       let matrix: [[ChallengeOutcomes]] = [
           [.playedCorrectly, .playedIncorrectly],
           [.playedIncorrectly, .playedCorrectly],
       ]
       XCTAssertTrue(isWinningPath(in: matrix))
   }
   
   func test2x2MatrixNoWinningPath() {
       let matrix: [[ChallengeOutcomes]] = [
           [.playedCorrectly, .playedIncorrectly],
           [.playedIncorrectly, .playedIncorrectly],
       ]
       XCTAssertFalse(isWinningPath(in: matrix))
   }
   
   func test3x3MatrixWinningPath() {
       let matrix: [[ChallengeOutcomes]] = [
           [.playedCorrectly, .playedCorrectly, .playedIncorrectly],
           [.unplayed, .playedCorrectly, .playedIncorrectly],
           [.playedIncorrectly, .playedCorrectly, .playedCorrectly]
       ]
       XCTAssertTrue(isWinningPath(in: matrix))
   }
   
   func test3x3MatrixNoWinningPath() {
       let matrix: [[ChallengeOutcomes]] = [
           [.playedCorrectly, .playedIncorrectly, .playedIncorrectly],
           [.unplayed, .playedCorrectly, .playedIncorrectly],
           [.playedIncorrectly, .playedCorrectly, .playedIncorrectly]
       ]
       XCTAssertFalse(isWinningPath(in: matrix))
   }
   
   func testComplexMatrixWinningPath() {
       let matrix: [[ChallengeOutcomes]] = [
           [.playedCorrectly, .playedIncorrectly, .unplayed],
           [.playedIncorrectly, .playedCorrectly, .unplayed],
           [.playedIncorrectly, .playedCorrectly, .playedCorrectly]
       ]
       XCTAssertTrue(isWinningPath(in: matrix))
   }
   
   func testComplexMatrixNoWinningPath() {
       let matrix: [[ChallengeOutcomes]] = [
           [.playedCorrectly, .playedIncorrectly, .unplayed],
           [.playedIncorrectly, .playedIncorrectly, .unplayed],
           [.playedIncorrectly, .unplayed, .playedCorrectly]
       ]
       XCTAssertFalse(isWinningPath(in: matrix))
   }

   // --- New 4x4 Test Cases ---

   func test4x4MatrixWinningPath() {
       let matrix: [[ChallengeOutcomes]] = [
           [.playedCorrectly, .playedCorrectly, .playedCorrectly, .playedIncorrectly],
           [.playedIncorrectly, .playedIncorrectly, .playedCorrectly, .playedCorrectly],
           [.playedCorrectly, .playedCorrectly, .playedCorrectly, .playedIncorrectly],
           [.playedIncorrectly, .playedCorrectly, .playedCorrectly, .playedCorrectly]
       ]
       XCTAssertTrue(isWinningPath(in: matrix))
   }
   
   func test4x4MatrixNoWinningPath() {
       let matrix: [[ChallengeOutcomes]] = [
           [.playedCorrectly, .playedIncorrectly, .playedCorrectly, .unplayed],
           [.unplayed, .playedIncorrectly, .playedIncorrectly, .unplayed],
           [.unplayed, .unplayed, .playedIncorrectly, .playedIncorrectly],
           [.playedIncorrectly, .unplayed, .unplayed, .playedIncorrectly]
       ]
       XCTAssertFalse(isWinningPath(in: matrix))
   }

   func test4x4MatrixComplexWinningPath() {
       let matrix: [[ChallengeOutcomes]] = [
           [.playedCorrectly, .unplayed, .unplayed, .unplayed],
           [.unplayed, .playedCorrectly, .unplayed, .unplayed],
           [.unplayed, .unplayed, .playedCorrectly, .unplayed],
           [.unplayed, .unplayed, .unplayed, .playedCorrectly]
       ]
       XCTAssertTrue(isWinningPath(in: matrix))
   }
   
   func test4x4MatrixWinningPathDirty() {
       let matrix: [[ChallengeOutcomes]] = [
           [.playedCorrectly, .playedIncorrectly, .playedIncorrectly, .unplayed],
           [.playedCorrectly, .unplayed, .unplayed, .playedIncorrectly],
           [.playedIncorrectly, .playedCorrectly, .playedCorrectly, .playedIncorrectly],
           [.unplayed, .unplayed, .playedCorrectly, .playedCorrectly]
       ]
       XCTAssertTrue(isWinningPath(in: matrix))
   }

   // --- New 5x5 Test Cases ---

   func test5x5MatrixLongWinningPath() {
       let matrix: [[ChallengeOutcomes]] = [
           [.playedCorrectly, .playedIncorrectly, .unplayed, .unplayed, .unplayed],
           [.playedCorrectly, .playedCorrectly, .unplayed, .playedIncorrectly, .unplayed],
           [.unplayed, .playedIncorrectly, .playedCorrectly, .playedCorrectly, .playedIncorrectly],
           [.unplayed, .unplayed, .unplayed, .unplayed, .playedCorrectly],
           [.playedCorrectly, .playedCorrectly, .playedCorrectly, .playedCorrectly, .playedCorrectly]
       ]
       XCTAssertTrue(isWinningPath(in: matrix))
   }

   func test5x5MatrixComplexWinningPath() {
       let matrix: [[ChallengeOutcomes]] = [
           [.playedCorrectly, .unplayed, .playedIncorrectly, .unplayed, .unplayed],
           [.unplayed, .playedCorrectly, .unplayed, .playedIncorrectly, .unplayed],
           [.unplayed, .unplayed, .playedCorrectly, .unplayed, .playedIncorrectly],
           [.playedIncorrectly, .unplayed, .playedIncorrectly, .playedCorrectly, .unplayed],
           [.playedCorrectly, .unplayed, .unplayed, .unplayed, .playedCorrectly]
       ]
       XCTAssertTrue(isWinningPath(in: matrix))
   }

   func test5x5MatrixNoWinningPath() {
       let matrix: [[ChallengeOutcomes]] = [
           [.playedCorrectly, .unplayed, .playedIncorrectly, .unplayed, .unplayed],
           [.unplayed, .playedIncorrectly, .unplayed, .playedIncorrectly, .unplayed],
           [.unplayed, .unplayed, .playedIncorrectly, .unplayed, .playedIncorrectly],
           [.playedIncorrectly, .unplayed, .playedIncorrectly, .playedIncorrectly, .unplayed],
           [.playedCorrectly, .unplayed, .unplayed, .unplayed, .playedIncorrectly]
       ]
       XCTAssertFalse(isWinningPath(in: matrix))
   }

   func test5x5MatrixLongPathButNoWinning() {
       let matrix: [[ChallengeOutcomes]] = [
           [.playedCorrectly, .unplayed, .unplayed, .unplayed, .unplayed],
           [.playedCorrectly, .unplayed, .unplayed, .playedIncorrectly, .unplayed],
           [.playedIncorrectly, .playedCorrectly, .playedIncorrectly, .unplayed, .unplayed],
           [.unplayed, .playedIncorrectly, .playedCorrectly, .unplayed, .unplayed],
           [.unplayed, .unplayed, .unplayed, .unplayed, .playedIncorrectly]
       ]
       XCTAssertFalse(isWinningPath(in: matrix))
   }
   
   // --- New 8x8 Test Cases ---

 func test8x8MatrixLongWinningPath1() {
     let matrix: [[ChallengeOutcomes]] = [
         [.playedCorrectly, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed],
         [.playedCorrectly, .playedCorrectly, .playedIncorrectly, .unplayed, .playedIncorrectly, .unplayed, .unplayed, .unplayed],
         [.unplayed, .unplayed, .playedCorrectly, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed],
         [.unplayed, .unplayed, .playedCorrectly, .playedCorrectly, .unplayed, .unplayed, .unplayed, .unplayed],
         [.unplayed, .unplayed, .unplayed, .unplayed, .playedCorrectly, .unplayed, .unplayed, .unplayed],
         [.unplayed, .unplayed, .unplayed, .unplayed, .playedCorrectly, .unplayed, .unplayed, .unplayed],
         [.unplayed, .unplayed, .unplayed, .unplayed, .playedCorrectly, .playedCorrectly, .unplayed, .unplayed],
         [.unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .playedCorrectly, .playedCorrectly]
     ]
     XCTAssertTrue(isWinningPath(in: matrix))
 }
 func test8x8MatrixLongWinningPath2() {
     let matrix: [[ChallengeOutcomes]] = [
         [.playedCorrectly, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed],
         [.playedCorrectly, .playedCorrectly, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed],
         [.unplayed, .unplayed, .playedCorrectly, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed],
         [.unplayed, .unplayed, .unplayed, .playedCorrectly, .unplayed, .unplayed, .unplayed, .unplayed],
         [.unplayed, .unplayed, .unplayed, .unplayed, .playedCorrectly, .unplayed, .unplayed, .unplayed],
         [.unplayed, .unplayed, .unplayed, .unplayed, .playedCorrectly, .playedCorrectly, .unplayed, .unplayed],
         [.unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .playedCorrectly, .unplayed],
         [.unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .playedCorrectly, .playedCorrectly]
     ]
     XCTAssertTrue(isWinningPath(in: matrix))
 }

   func test8x8MatrixNoWinningPath() {
       let matrix: [[ChallengeOutcomes]] = [
           [.playedCorrectly, .playedIncorrectly, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed],
           [.unplayed, .playedIncorrectly, .playedIncorrectly, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed],
           [.unplayed, .playedCorrectly, .unplayed, .unplayed, .playedIncorrectly, .unplayed, .unplayed, .unplayed],
           [.unplayed, .unplayed, .playedIncorrectly, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed],
           [.unplayed, .unplayed, .unplayed, .unplayed, .playedIncorrectly, .unplayed, .unplayed, .unplayed],
           [.unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .playedIncorrectly],
           [.unplayed, .playedIncorrectly, .unplayed, .unplayed, .unplayed, .playedIncorrectly, .playedIncorrectly, .unplayed],
           [.playedCorrectly, .unplayed, .unplayed, .unplayed, .playedIncorrectly, .playedIncorrectly, .unplayed, .playedIncorrectly]
       ]
       XCTAssertFalse(isWinningPath(in: matrix))
   }

   func test8x8MatrixLongPathButNoWinning() {
       let matrix: [[ChallengeOutcomes]] = [
           [.playedCorrectly, .playedIncorrectly, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed],
           [.unplayed, .playedCorrectly, .playedIncorrectly, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed],
           [.unplayed, .playedIncorrectly, .unplayed, .unplayed, .playedIncorrectly, .unplayed, .playedCorrectly, .unplayed],
           [.unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .playedIncorrectly, .unplayed, .unplayed],
           [.unplayed, .unplayed, .unplayed, .unplayed, .playedIncorrectly, .unplayed, .unplayed, .unplayed],
           [.unplayed, .playedIncorrectly, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed],
           [.playedIncorrectly, .playedIncorrectly, .unplayed, .unplayed, .playedIncorrectly, .unplayed, .unplayed, .unplayed],
           [.playedCorrectly, .unplayed, .unplayed, .unplayed, .unplayed, .playedIncorrectly, .unplayed, .playedIncorrectly]
       ]
       XCTAssertFalse(isWinningPath(in: matrix))
   }

   func test8x8MatrixComplexWinningPath() {
       let matrix: [[ChallengeOutcomes]] = [
           [.playedCorrectly, .unplayed, .unplayed, .playedIncorrectly, .unplayed, .unplayed, .unplayed, .unplayed],
           [.unplayed, .playedCorrectly, .unplayed, .playedIncorrectly, .unplayed, .unplayed, .unplayed, .unplayed],
           [.unplayed, .unplayed, .playedCorrectly, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed],
           [.playedIncorrectly, .unplayed, .unplayed, .playedCorrectly, .unplayed, .unplayed, .unplayed, .unplayed],
           [.unplayed, .playedIncorrectly, .unplayed, .unplayed, .playedCorrectly, .unplayed, .unplayed, .unplayed],
           [.unplayed, .unplayed, .playedIncorrectly, .unplayed, .unplayed, .playedCorrectly, .unplayed, .unplayed],
           [.unplayed, .unplayed, .unplayed, .playedIncorrectly, .unplayed, .unplayed, .playedCorrectly, .unplayed],
           [.unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .playedCorrectly]
       ]
       XCTAssertTrue(isWinningPath(in: matrix))
   }
 
 func test8x8MatrixSnakingWinningPath() {
     let matrix: [[ChallengeOutcomes]] = [
         [.unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .playedCorrectly],
         [.unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .playedCorrectly],
         [.unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .playedCorrectly, .unplayed],
         [.unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .playedCorrectly, .playedCorrectly, .unplayed],
         [.unplayed, .unplayed, .unplayed, .unplayed, .playedCorrectly, .unplayed, .playedCorrectly, .unplayed],
         [.unplayed, .unplayed, .unplayed, .playedCorrectly, .playedCorrectly, .unplayed, .unplayed, .unplayed],
         [.unplayed, .unplayed, .playedCorrectly, .playedCorrectly, .unplayed, .unplayed, .unplayed, .unplayed],
         [.playedCorrectly, .playedCorrectly, .playedCorrectly, .playedCorrectly, .unplayed, .unplayed, .unplayed, .unplayed]
     ]
     XCTAssertTrue(isWinningPath(in: matrix))
 }
 func test8x8MatrixReverseDiagonalWinningPath() {
     let matrix: [[ChallengeOutcomes]] = [
         [.unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .playedCorrectly],
         [.unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .playedCorrectly, .unplayed],
         [.unplayed, .unplayed, .playedCorrectly, .unplayed, .unplayed, .playedCorrectly, .unplayed, .unplayed],
         [.unplayed, .playedCorrectly, .unplayed, .playedCorrectly, .playedCorrectly, .unplayed, .unplayed, .unplayed],
         [.playedCorrectly, .unplayed, .playedCorrectly, .unplayed, .playedCorrectly, .unplayed, .unplayed, .unplayed],
         [.unplayed, .unplayed, .playedIncorrectly, .unplayed, .unplayed, .playedIncorrectly, .unplayed, .unplayed],
         [.unplayed, .playedCorrectly, .unplayed, .unplayed, .playedCorrectly, .playedCorrectly, .unplayed, .unplayed],
         [.playedCorrectly, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed, .playedCorrectly]
     ]
     XCTAssertTrue(isWinningPath(in: matrix))
 }
}

 
class CellAdjacencyTests: XCTestCase {
   
   func testCellsAreHorizontallyAdjacent() {
       XCTAssertTrue(areCellsAdjacent((0, 0), (0, 1)))
       XCTAssertTrue(areCellsAdjacent((1, 1), (1, 2)))
       XCTAssertTrue(areCellsAdjacent((2, 3), (2, 2)))
   }
   
   func testCellsAreVerticallyAdjacent() {
       XCTAssertTrue(areCellsAdjacent((0, 0), (1, 0)))
       XCTAssertTrue(areCellsAdjacent((2, 1), (3, 1)))
       XCTAssertTrue(areCellsAdjacent((1, 1), (0, 1)))
   }
   
   func testCellsAreDiagonallyAdjacent() {
       XCTAssertTrue(areCellsAdjacent((0, 0), (1, 1)))
       XCTAssertTrue(areCellsAdjacent((2, 2), (1, 1)))
       XCTAssertTrue(areCellsAdjacent((1, 1), (2, 2)))
   }
   
   func testCellsAreNotAdjacent() {
       XCTAssertFalse(areCellsAdjacent((0, 0), (2, 2)))
       XCTAssertFalse(areCellsAdjacent((1, 1), (3, 1)))
       XCTAssertFalse(areCellsAdjacent((0, 0), (2, 1)))
   }
   
   func testSameCellIsNotAdjacent() {
       XCTAssertFalse(areCellsAdjacent((0, 0), (0, 0)))
       XCTAssertFalse(areCellsAdjacent((1, 1), (1, 1)))
   }

   func testOtherBoardSizes() {
       XCTAssertTrue(areCellsAdjacent((10, 10), (10, 11)))
       XCTAssertTrue(areCellsAdjacent((10, 10), (11, 10)))
       XCTAssertTrue(areCellsAdjacent((10, 10), (9, 9)))
       XCTAssertFalse(areCellsAdjacent((10, 10), (12, 12)))
   }
}
class PossibleWinningPathTests: XCTestCase {
   
   func testEmptyMatrix() {
       let matrix: [[ChallengeOutcomes]] = []
       XCTAssertFalse(isPossibleWinningPath(in: matrix))
   }
   
   func testSingleCellPlayedCorrectly() {
       let matrix: [[ChallengeOutcomes]] = [[.playedCorrectly]]
       XCTAssertTrue(isPossibleWinningPath(in: matrix))
   }

   func testSingleCellPlayedIncorrectly() {
       let matrix: [[ChallengeOutcomes]] = [[.playedIncorrectly]]
       XCTAssertFalse(isPossibleWinningPath(in: matrix))
   }
   
   func test2x2MatrixWinningPathPossible() {
       let matrix: [[ChallengeOutcomes]] = [
           [.playedCorrectly, .playedIncorrectly],
           [.unplayed, .playedCorrectly],
       ]
       XCTAssertTrue(isPossibleWinningPath(in: matrix))
   }
   
   func test2x2MatrixNoWinningPathPossible() {
       let matrix: [[ChallengeOutcomes]] = [
           [.playedCorrectly, .playedIncorrectly],
           [.playedIncorrectly, .playedCorrectly],
       ]
       XCTAssertFalse(isPossibleWinningPath(in: matrix))
   }
   
   func test3x3MatrixWinningPathPossible() {
       let matrix: [[ChallengeOutcomes]] = [
           [.playedCorrectly, .playedCorrectly, .playedIncorrectly],
           [.unplayed, .playedCorrectly, .playedIncorrectly],
           [.playedIncorrectly, .playedCorrectly, .unplayed]
       ]
       XCTAssertTrue(isPossibleWinningPath(in: matrix))
   }
   
   func test3x3MatrixNoWinningPathPossible() {
       let matrix: [[ChallengeOutcomes]] = [
           [.playedCorrectly, .playedIncorrectly, .playedIncorrectly],
           [.unplayed, .playedIncorrectly, .playedIncorrectly],
           [.playedIncorrectly, .playedCorrectly, .playedIncorrectly]
       ]
       XCTAssertFalse(isPossibleWinningPath(in: matrix))
   }
   
   func testComplexMatrixWinningPathPossible() {
       let matrix: [[ChallengeOutcomes]] = [
           [.playedCorrectly, .playedIncorrectly, .unplayed],
           [.unplayed, .playedCorrectly, .unplayed],
           [.playedIncorrectly, .unplayed, .playedCorrectly]
       ]
       XCTAssertTrue(isPossibleWinningPath(in: matrix))
   }
   
   func testComplexMatrixNoWinningPathPossible() {
       let matrix: [[ChallengeOutcomes]] = [
           [.playedCorrectly, .playedIncorrectly, .unplayed],
           [.playedIncorrectly, .playedIncorrectly, .unplayed],
           [.playedIncorrectly, .unplayed, .playedCorrectly]
       ]
       XCTAssertFalse(isPossibleWinningPath(in: matrix))
   }
   
   // --- New 4x4 Test Cases ---

   func test4x4MatrixWinningPathPossible() {
       let matrix: [[ChallengeOutcomes]] = [
           [.playedCorrectly, .playedIncorrectly, .unplayed, .unplayed],
           [.unplayed, .playedCorrectly, .playedIncorrectly, .unplayed],
           [.unplayed, .unplayed, .playedCorrectly, .playedCorrectly],
           [.playedIncorrectly, .unplayed, .unplayed, .playedCorrectly]
       ]
       XCTAssertTrue(isPossibleWinningPath(in: matrix))
   }
   
   func test4x4MatrixWinningPathPossibleComplex() {
       let matrix: [[ChallengeOutcomes]] = [
           [.playedCorrectly, .playedIncorrectly, .playedIncorrectly, .unplayed],
           [.playedCorrectly, .unplayed, .unplayed, .playedIncorrectly],
           [.playedIncorrectly, .playedCorrectly, .playedCorrectly, .playedIncorrectly],
           [.unplayed, .unplayed, .playedCorrectly, .playedCorrectly]
       ]
       XCTAssertTrue(isPossibleWinningPath(in: matrix))
   }
   
   func test4x4MatrixNoWinningPathPossible() {
       let matrix: [[ChallengeOutcomes]] = [
           [.playedCorrectly, .playedIncorrectly, .unplayed, .unplayed],
           [.unplayed, .playedIncorrectly, .playedIncorrectly, .unplayed],
           [.unplayed, .unplayed, .playedIncorrectly, .playedIncorrectly],
           [.playedIncorrectly, .unplayed, .unplayed, .playedIncorrectly]
       ]
       XCTAssertFalse(isPossibleWinningPath(in: matrix))
   }
   
   func test4x4MatrixWinningPathPossibleDirty() {
       let matrix: [[ChallengeOutcomes]] = [
           [.playedCorrectly, .unplayed, .unplayed, .unplayed],
           [.unplayed, .playedIncorrectly, .playedCorrectly, .playedIncorrectly],
           [.unplayed, .unplayed, .playedCorrectly, .unplayed],
           [.playedIncorrectly, .playedCorrectly, .playedIncorrectly, .playedCorrectly]
       ]
       XCTAssertTrue(isPossibleWinningPath(in: matrix))
   }
 
 
 // --- New 6x6 Test Cases ---

 func test6x6MatrixWinningPathPossible() {
     let matrix: [[ChallengeOutcomes]] = [
         [.playedCorrectly, .playedIncorrectly, .unplayed, .unplayed, .unplayed, .unplayed],
         [.unplayed, .playedIncorrectly, .playedCorrectly, .unplayed, .playedIncorrectly, .unplayed],
         [.unplayed, .unplayed, .playedCorrectly, .playedCorrectly, .playedIncorrectly, .unplayed],
         [.playedIncorrectly, .unplayed, .unplayed, .unplayed, .playedCorrectly, .unplayed],
         [.unplayed, .playedIncorrectly, .playedIncorrectly, .playedCorrectly, .unplayed, .unplayed],
         [.unplayed, .unplayed, .unplayed, .playedIncorrectly, .playedCorrectly, .playedCorrectly]
     ]
     XCTAssertTrue(isPossibleWinningPath(in: matrix))
 }

 func test6x6MatrixNoWinningPathPossible() {
     let matrix: [[ChallengeOutcomes]] = [
         [.playedCorrectly, .playedIncorrectly, .unplayed, .unplayed, .unplayed, .unplayed],
         [.unplayed, .playedIncorrectly, .playedIncorrectly, .unplayed, .playedIncorrectly, .unplayed],
         [.unplayed, .unplayed, .playedCorrectly, .playedIncorrectly, .playedIncorrectly, .unplayed],
         [.playedIncorrectly, .unplayed, .unplayed, .unplayed, .playedIncorrectly, .unplayed],
         [.unplayed, .playedIncorrectly, .playedIncorrectly, .playedIncorrectly, .unplayed, .unplayed],
         [.unplayed, .unplayed, .unplayed, .playedIncorrectly, .playedIncorrectly, .playedIncorrectly]
     ]
     XCTAssertFalse(isPossibleWinningPath(in: matrix))
 }

 func test6x6MatrixComplexWinningPathPossible() {
     let matrix: [[ChallengeOutcomes]] = [
         [.playedCorrectly, .playedIncorrectly, .unplayed, .unplayed, .unplayed, .unplayed],
         [.unplayed, .playedCorrectly, .unplayed, .playedIncorrectly, .unplayed, .unplayed],
         [.unplayed, .unplayed, .playedCorrectly, .playedCorrectly, .unplayed, .unplayed],
         [.playedIncorrectly, .unplayed, .unplayed, .unplayed, .unplayed, .playedCorrectly],
         [.unplayed, .playedIncorrectly, .playedIncorrectly, .unplayed, .unplayed, .unplayed],
         [.playedIncorrectly, .unplayed, .playedIncorrectly, .playedCorrectly, .playedCorrectly, .playedCorrectly]
     ]
     XCTAssertTrue(isPossibleWinningPath(in: matrix))
 }

 func test6x6MatrixWinningPathPossibleDirty() {
     let matrix: [[ChallengeOutcomes]] = [
         [.playedCorrectly, .unplayed, .unplayed, .unplayed, .unplayed, .unplayed],
         [.unplayed, .playedIncorrectly, .unplayed, .playedCorrectly, .unplayed, .unplayed],
         [.unplayed, .unplayed, .playedCorrectly, .playedIncorrectly, .unplayed, .unplayed],
         [.playedIncorrectly, .playedCorrectly, .unplayed, .unplayed, .unplayed, .playedCorrectly],
         [.unplayed, .unplayed, .unplayed, .playedIncorrectly, .unplayed, .unplayed],
         [.playedIncorrectly, .playedCorrectly, .playedIncorrectly, .playedCorrectly, .playedIncorrectly, .playedCorrectly]
     ]
     XCTAssertTrue(isPossibleWinningPath(in: matrix))
 }
}

func runtests() {
 print("Running tests")
 CellAdjacencyTests.defaultTestSuite.run()
 
 
 PossibleWinningPathTests.defaultTestSuite.run()
 
 
 WinningPathTests.defaultTestSuite.run()
 
}
//run()
