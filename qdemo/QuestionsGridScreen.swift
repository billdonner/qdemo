//
//  QuestionsGridScreen.swift
//  qdemo
//
//  Created by bill donner on 5/16/24.
//

import SwiftUI
struct TopView: View {
  let settings:AppSettings
  var body:some View {
    return  VStack{
      HStack {
        Text("score:\(gameState.grandScore)")
        Spacer()
        Text("remaining:\(Int(settings.rows*settings.columns) - gameState.grandScore - gameState.grandLosers)")
      }.font(.headline).padding()
    }
  }
}
func bc(_ number:Int, settings:AppSettings)->Color {
 return challenges.count>0 ? colorFor(topic:challenges[number].topic) : pastelColors[number % pastelColors.count]
}
struct BottomView:View {
  let settings:AppSettings
  @State  var selektd: Int = -1
  @State var isSheetPresented = false 
  var body: some View {
    ScrollView([.vertical, .horizontal], showsIndicators: true) {
      let columns = Array(repeating: GridItem(.flexible(), spacing: settings.padding), count: Int(settings.columns))
      LazyVGrid(columns: columns, spacing:settings.border) {
        ForEach(0..<Int(settings.rows) * Int(settings.columns), id: \.self) { number in
      
          MatrixItem(number: number,settings:settings,selected:$selektd) { renumber in
            // assert((renumber>=lower && renumber<=upper),"number out of range in onerowview")
            selektd = renumber
            //   print("+++++>>> just selected \(selected) in onerowview")
           // selectedItemBackgroundColor  = pastelColors[renumber % pastelColors.count]
          isSheetPresented = true// might be delaying it a bit
          }
        }
      }
    }
    .sheet(isPresented: $isSheetPresented) {
    if selektd >= 0 {
      ChallengesScreen(selected:selektd)
    } else {
      let _ = print("+++++>>> failed present red circle selected \(selektd)")
      ZStack {
        DismissButtonView()
        Circle().foregroundColor(.red)
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
  QuestionsGridScreen(settings: AppSettings())
}
