//
//  QuestionsGridScreen.swift
//  qdemo
//
//  Created by bill donner on 5/16/24.
//

import SwiftUI


struct QuestionsGridScreen: View {

  internal init(
                tappedNum: IdentifiableInteger? = nil,
                longPressedNum: IdentifiableInteger? = nil,   globalFlipState: Bool = false) {
    
    @AppStorage("boardSize") var boardSize = 6
    
 
    self.tappedNum = tappedNum
    self.longPressedNum = longPressedNum
    self._flipStates =   State(initialValue: Array(repeating: false, count: boardSize*boardSize))
    self.globalFlipState = globalFlipState
  }
  
  @State  var tappedNum:IdentifiableInteger?
  @State  var longPressedNum :IdentifiableInteger?
  @State var flipStates: [Bool]
  @State var globalFlipState: Bool
  @State private var currentZoom = 0.0
  @State private var totalZoom = 1.0
                                         
                                         
                                         
  var body: some View {
    VStack {
      ScoreBarView()
      ZStack {
        Color.blue.opacity(0.4)
        GridView(tappedNum:$tappedNum,longPressedNum: $longPressedNum)
          .scaleEffect(currentZoom + totalZoom)
          .gesture(
            MagnifyGesture()
              .onChanged { value in
                currentZoom = value.magnification - 1
              }
              .onEnded { value in
                totalZoom += currentZoom
                currentZoom = 0
              }
          )
      }
        .accessibilityZoomAction { action in
            if action.direction == .zoomIn {
                totalZoom += 1
            } else {
                totalZoom -= 1
            }
        }

      .sheet(item:$tappedNum) { selek in
        if selek.val  >= 0 {
          ChallengesScreen(selected:selek.val)
        }
      }
    }
    
  }
}
#Preview ("Screen"){
  QuestionsGridScreen()
}
struct ZGridView: View {
    @State private var currentZoom = 0.0
    @State private var totalZoom = 1.0

    var body: some View {
        Image("singapore")
            .scaleEffect(currentZoom + totalZoom)
            .gesture(
                MagnifyGesture()
                    .onChanged { value in
                        currentZoom = value.magnification - 1
                    }
                    .onEnded { value in
                        totalZoom += currentZoom
                        currentZoom = 0
                    }
            )
            .accessibilityZoomAction { action in
                if action.direction == .zoomIn {
                    totalZoom += 1
                } else {
                    totalZoom -= 1
                }
            }
    }
}
