//
//  LongPressScreen.swift
//  qdemo
//
//  Created by bill donner on 5/23/24.
//

import SwiftUI
struct GimmeeScreen: View {
  let theInt:Int
  @Binding var isPresented  : Bool 
  var body: some View {
        ZStack {
          NavigationStack {
        VStack {
          if gameState.gimmees > 0 {
            if theInt < challenges.count {
              Text( challenges[theInt].question).font(.largeTitle)
            }
            Spacer()
            Text ("Change Question \(theInt)"); Text(" will cost one Gimmee").foregroundStyle(Color.red)
            Spacer()
            Button(action:{gameState.gimmees -= 1 }){
              Text("Change within this topic")
            }
            Spacer()
            Button(action:{gameState.gimmees -= 1 }){
              Text("Change to another topic")
            }
          }
          else {
            Text ("Sorry you have no gimmees left")
          }
        }
        .navigationTitle("Change This Question!!!").navigationBarTitleDisplayMode(.inline)
          }
          WrappedDismissButton(isPresented: $isPresented)
    }
  }
}
#Preview () {
  gameState.gimmees = 0
  return GimmeeScreen(theInt:-1, isPresented:.constant(true)) 
}
