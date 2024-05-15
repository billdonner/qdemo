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
    ZStack{
        DismissButtonView()
        //backgroundColor.edgesIgnoringSafeArea(.all)
          if settings.displayOption == .questions {
            ChallengesScreen( selected:selected)
          }
          else
          {
            Text(boxCon(selected,settings:settings))
              .font(.largeTitle)
              .foregroundColor(.black) // Assuming the background is dark enough; adjust accordingly.
              .padding()
          }
        }
      }
    }
//#Preview("worded") {
//  DetailScreen(selected:0,
//               backgroundColor:.yellow,
//               settings:AppSettings(displayOption:AppSettings.worded))
//}
   
#Preview("questions") {
  DetailScreen(selected:0,
               backgroundColor:.yellow,
               settings:AppSettings())
}

struct DismissButtonView: View {
  @Environment(\.dismiss) var dismiss
  var body: some View {
    VStack {
      // add a dismissal button
      HStack {
        Spacer()
        Button {
          dismiss()
        } label: {
          Image(systemName: "x.circle").padding(EdgeInsets(top:isIpad ? 40:10, leading: 0, bottom: 40, trailing: 20))
        }
      }
      Spacer()
    }
  }
}
