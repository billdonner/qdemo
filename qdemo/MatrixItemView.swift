//
//  MatrixItem.swift
//  qdemo
//
//  Created by bill donner on 5/23/24.
//

import SwiftUI

//struct MatrixItemView: View {
//  init(text:String ,number:Int, settings: AppSettings, onTap: ((Int) -> Void)? = nil, onLongPress: ((Int) -> Void)? = nil,shownum:Bool = false) {
//    self.text = text
//    self.settings = settings
//    self.onTap = onTap
//    self.onLongPress = onLongPress
//    self.shownum = shownum
//    self.number = number
//  }
//  
//  let text: String
//  let number:Int
//  let settings:AppSettings
//  let shownum:Bool
//  
//  var onTap: ((Int) -> Void)? // Closure to be executed on tap
//  var onLongPress: ((Int) -> Void)?
//  var body: some View {
//    //letqu _ = print("MatrixItem \(number)")
//    Text(text) // replace with "\(number)" for gpt
//      .font(.system(size:settings.fontsize))
//      .lineLimit(8)
//      .minimumScaleFactor(0.2)
//      .frame(width:settings.elementWidth,
//             height: settings.elementWidth, //square for now
//             alignment: .center)
//      .padding(.all, settings.padding)
//      .background(cellColorFromTopic(number))
//      .foregroundColor(.black)
//      .onTapGesture {
//        gameState.selected = number // gameState is class
//        gameState.showing = .qanda
//        onTap?(number) // Execute the closure if it exists
//      }
//      .onLongPressGesture {
//        onLongPress?(number)
//      }
//      .opacity(cellOpacity(number))
//      .border(cellBorderColor(number), width:cellBorderWidth(number) )
//      .rotationEffect(settings.shaky ? .degrees(Double( number % 23)) : .degrees(0))
//  }
//}
#Preview {
  MatrixItemView(text: "test one", number: 1, settings: AppSettings(), shownum:true)
}
#Preview {
  MatrixItemView(text: "test one", number: 1, settings: AppSettings(), shownum:true)
    .preferredColorScheme(.dark)
}
//func cellOpacity(_ number:Int) -> Double {
//  number<0||number>gameState.outcomes.count-1 ? 0.0:
//    (gameState.outcomes[number] == .unplayed ? 1.0:
//      (gameState.outcomes[number] == .playedCorrectly ? 0.8:0.8
//      ))
//}
//func cellBorderColor(_ number:Int) -> Color {
//  number<0||number>gameState.outcomes.count-1 ? .gray:
//                (gameState.outcomes[number] == .unplayed ? .gray:
//                  (gameState.outcomes[number] == .playedCorrectly ? .green:.red
//                  ))
//}
//func cellBorderWidth(_ number:Int) -> Double {
//  number<0||number>gameState.outcomes.count-1 ? 0.0:
//  (gameState.outcomes[number] == .unplayed ? 1.0:
//    (gameState.outcomes[number] == .playedCorrectly ? 5:5
//    ))
//}
//func cellColorFromTopic(_ number:Int)->Color {
// challenges.count>0 ? colorFor(topic:challenges[number].topic) : distinctiveColors[number %  distinctiveColors.count]
//} 
