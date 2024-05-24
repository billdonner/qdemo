//
//  LongPressScreen.swift
//  qdemo
//
//  Created by bill donner on 5/23/24.
//

import SwiftUI
struct LongPressView: View {
  let theInt:Int
  var body: some View {
      DismissButtonView()
    ZStack {
      NavigationStack {
        VStack {
          if gameState.gimmees > 0 {
            if theInt < challenges.count {
              Text( challenges[theInt].question).font(.largeTitle)
            }
            Text ("Change Question \(theInt) - will cost one Gimmee")
            Button(action:{}){
              Text("Change within this topic")
            }
            Button(action:{}){
              Text("Change to another topic")
            }
          }
          else {
            Text ("Sorry you have no gimmees left")
          }
        }
      }.navigationTitle("Change This Question!!!")
    }
  }
}
#Preview () {
  LongPressView(theInt:-1)
}
