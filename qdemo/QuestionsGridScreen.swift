//
//  QuestionsGridScreen.swift
//  qdemo
//
//  Created by bill donner on 5/16/24.
//

import SwiftUI

//struct GridView:View {
//  let settings:AppSettings
//  @Binding  var tappedNum:IdentifiableInteger?
//  @Binding  var longPressedNum :IdentifiableInteger?
//  var body: some View {
//    ScrollView([.vertical, .horizontal], showsIndicators: true) {
//      let columns = Array(repeating: GridItem(.flexible(), spacing: settings.padding), count: Int(settings.rows))
//      LazyVGrid(columns: columns, spacing:settings.border) {
//        ForEach(0..<Int(settings.rows) * Int(settings.rows), id: \.self) { number in
//          MatrixItemView(text:challenges[number].question,
//                         number: number,
//                         settings:settings,
//                         onTap:{ renumber in
//            tappedNum = IdentifiableInteger(val:renumber)
//          },
//                         onLongPress: { n in
//            longPressedNum = IdentifiableInteger (val: n)
//          })
//        }
//      }
//    }//scrollview
//  }
//}

//#Preview( "GridView") {
//  GridView(settings:AppSettings.mock)
//}


//#Preview ("GridView"){
//  GridView(settings: AppSettings.mock,tappedNum:.constant(IdentifiableInteger(val: 1)),longPressedNum: .constant(IdentifiableInteger(val: 2)))
//}


struct QuestionsGridScreen: View {
  let settings:AppSettings
  @State  var tappedNum:IdentifiableInteger? = nil
  @State  var longPressedNum :IdentifiableInteger? = nil
  var body: some View {
    VStack {
      ScoreBarView(settings: settings)
      GridView(settings:settings,tappedNum:$tappedNum,longPressedNum: $longPressedNum)
      .sheet(item:$longPressedNum) { fooly in
        LongPressView (theInt: fooly.val)
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
  QuestionsGridScreen(settings: AppSettings.mock)
}
