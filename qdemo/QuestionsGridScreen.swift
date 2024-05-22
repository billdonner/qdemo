//
//  QuestionsGridScreen.swift
//  qdemo
//
//  Created by bill donner on 5/16/24.
//

import SwiftUI
import TipKit
struct PopoverTip: Tip {
    var title: Text {
        Text("Adjust Settings")
    }
    var message: Text? {
        Text("Many Adjustments will force a new game")
    }
    var image: Image? {
        Image(systemName: "star")
    }
}

enum MatrixError: Error {
    case notSquareArray
}


func convertToSquareMatrix(_ array: [ChallengeOutcomes]) throws -> [[ChallengeOutcomes]] {
    // Calculate the square root of the array length
    let length = array.count
    let side = Int(sqrt(Double(length)))
    
    // Check if length is a perfect square
    if side * side != length {
        throw MatrixError.notSquareArray // Not a perfect square, cannot form a square matrix
    }
    
    // Initialize the square matrix
  var squareMatrix = Array(repeating: Array(repeating: ChallengeOutcomes.unplayed, count: side), count: side)
    
    // Fill the square matrix with the elements from the linear array
    for (index, element) in array.enumerated() {
        let row = index / side
        let col = index % side
        squareMatrix[row][col] = element
    }
    
    return squareMatrix
}

struct TopView: View {
  let settings:AppSettings
  let tip = PopoverTip()
  var body:some View {
    return  VStack{
      HStack {
        if let sq = try? convertToSquareMatrix(gameState.outcomes) {
          Text(isWinningPath(in:sq) ? "😎": "  ")
          Text(isPossibleWinningPath(in:sq) ? "☡ ": "  ")
          
          Text("score:\(gameState.grandScore)")
          Spacer()
          Text("gimmees:\(gameState.gimmees)")
          Spacer()
          Text("remaining:\(Int(settings.rows*settings.rows) - gameState.grandScore - gameState.grandLosers)")
            .popoverTip(tip)
            .onTapGesture {
              // Invalidate the tip when someone uses the feature.
              tip.invalidate(reason: .actionPerformed)
            }
        }
      }.font(.headline).padding()
    }.onChange(of:gameState.outcomes) {
      if let sq = try? convertToSquareMatrix(gameState.outcomes) {
        if isWinningPath(in:sq) {
          print("you have already won but can play on")
        } else {
          if !isPossibleWinningPath(in:sq) {
            print("you cant possibly win")
          }
        }
      }
    }
  }
}


struct BottomView:View {
  let settings:AppSettings
  // could not use isPresented version of sheet
  struct Selek: Identifiable {
    let id = UUID()
    let val: Int
  }
  
  @State  var selektd:Selek? = nil
  var body: some View {
    ScrollView([.vertical, .horizontal], showsIndicators: true) {
      let columns = Array(repeating: GridItem(.flexible(), spacing: settings.padding), count: Int(settings.rows))
      LazyVGrid(columns: columns, spacing:settings.border) {
        ForEach(0..<Int(settings.rows) * Int(settings.rows), id: \.self) { number in
          
          MatrixItem(number: number,settings:settings,onTap:{ renumber in
            selektd = Selek(val:renumber)
          },onLongPress: { n in
            print("long press \(n)")
          })
        }
      }//scrollview
      
      .sheet(item:$selektd) { selek in
        if selek.val  >= 0 {
          ChallengesScreen(selected:selek.val)
        } else {
          let _ = print("+++++>>> failed present red circle selected val \(selek.val)")
          ZStack {
            DismissButtonView()
            Circle().foregroundColor(.red)
          }
        }
      }
    }
  }
}
struct QuestionsGridScreen: View {
  let settings:AppSettings
 // @State private var isSheetPresented = false

  @State private var selectedItemBackgroundColor: Color = .clear
  //let origined = 0// start with 0, *** might fail otherwise
  var body: some View {
    VStack {
      TopView(settings: settings)
      BottomView(settings:settings)
    }

  }
}
#Preview ("Game"){
  QuestionsGridScreen(settings: AppSettings.mock)
}
