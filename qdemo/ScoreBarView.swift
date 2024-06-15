//
//  ScoreBarView.swift
//  qdemo
//
//  Created by bill donner on 5/24/24.
//

import SwiftUI

 struct ScoreBarView: View {
  let settings:AppSettings
   @State var showAlert = false
  var body:some View {
    return  VStack{
      HStack {
        if let sq = try? convertToSquareMatrix(gameState.outcomes) {
          let showchar = if isWinningPath(in: sq) {"😎"}
          else {
            if isPossibleWinningPath(in:sq) {
              "☡"
            } else {
              "❌"
            }
          }
          Text(showchar).font(.largeTitle) 
          Text("score:");Text("\(gameState.grandScore)").font(.largeTitle)
          Text("gimmees:");Text("\(gameState.gimmees)").font(.largeTitle)
          Text("togo:");Text("\(Int(settings.rows*settings.rows) - gameState.grandScore - gameState.grandLosers)").font(.largeTitle)
           // .popoverTip(tip)
            .onTapGesture {
              // Invalidate the tip when someone uses the feature.
              //tip.invalidate(reason: .actionPerformed)
            }
        }
      }.font(.headline).padding()
//    }   .alert(isPresented: $showAlert) {
//      Alert(title: Text("Hey"),
//            message: Text("You have already won but you can play on"),
//            dismissButton: .default(Text("OK")))
  }
    
    
    
    .onChange(of:gameState.outcomes) {
      if let sq = try? convertToSquareMatrix(gameState.outcomes) {
        if isWinningPath(in:sq) {
          print("you have already won but can play on")
          showAlert = true
        } else {
          if !isPossibleWinningPath(in:sq) {
            print("you cant possibly win")
          }
        }
      }
    }
  }
}
#Preview {
  ScoreBarView(settings: AppSettings())
}
