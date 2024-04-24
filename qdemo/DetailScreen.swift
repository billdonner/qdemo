//
//  DetailScreen.swift
//  qdemo
//
//  Created by bill donner on 4/24/24.
//
 
import SwiftUI

struct DetailScreen: View {
  let selected:Int
  let backgroundColor: Color
  let settings:AppSettings 
  var body: some View {
    NavigationView {
      ZStack {
        backgroundColor.edgesIgnoringSafeArea(.all)
        Text(boxCon(selected,settings:settings))
          .font(.largeTitle)
          .foregroundColor(.black) // Assuming the background is dark enough; adjust accordingly.
          .padding()
      }.navigationTitle("Details for question \(selected)")
    }
  }
}
#Preview("DetailScreen") {
  DetailScreen(selected:1999,
             backgroundColor:.yellow,settings:AppSettings())
}
