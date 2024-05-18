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
        Text("remaining:\(Int(settings.rows*settings.rows) - gameState.grandScore - gameState.grandLosers)")
      }.font(.headline).padding()
    }
  }
}
func bc(_ number:Int, settings:AppSettings)->Color {
 return challenges.count>0 ? colorFor(topic:challenges[number].topic) : pastelColors[number % pastelColors.count]
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
      
          MatrixItem(number: number,settings:settings) { renumber in
            selektd = Selek(val:renumber)
      
          }
        }
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
