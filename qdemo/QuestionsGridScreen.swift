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


fileprivate struct GridView:View {
  let settings:AppSettings
  // could not use isPresented version of sheet
  @State  var selektd:IdentifiableInteger? = nil
  @State  var fooly :IdentifiableInteger? = nil
  var body: some View {
    ScrollView([.vertical, .horizontal], showsIndicators: true) {
      let columns = Array(repeating: GridItem(.flexible(), spacing: settings.padding), count: Int(settings.rows))
      LazyVGrid(columns: columns, spacing:settings.border) {
        ForEach(0..<Int(settings.rows) * Int(settings.rows), id: \.self) { number in
          MatrixItemView(number: number,settings:settings,onTap:{ renumber in
            selektd = IdentifiableInteger(val:renumber)
          },onLongPress: { n in
            fooly = IdentifiableInteger (val: n)
          })
        }
      }
    }//scrollview
  //}uncomment to end here for chatgpt
      .sheet(item:$fooly) { fooly in
        LongPressView (theInt: fooly.val)
      }
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
  var body: some View {
    VStack {
      ScoreBarView(settings: settings)
      GridView(settings:settings)
    }

  }
}
#Preview ("Game"){
  QuestionsGridScreen(settings: AppSettings.mock)
}
