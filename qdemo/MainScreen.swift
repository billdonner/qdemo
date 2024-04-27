//
//  ContentView.swift
//  qdemo2
//
//  Created by bill donner on 4/14/24.
//

import SwiftUI
import q20kshare



struct MatrixItem: View {
  let number: Int
  let backgroundColor: Color
  let settings:AppSettings
  @Binding var selected:Int
  var onTap: ((Int) -> Void)? // Closure to be executed on tap
  
  var body: some View {
    //let oc = gameState.outcomes[number]
    
      Text(boxCon(number,settings: settings))
        .font(.system(size:settings.fontsize))
        .lineLimit(5)
        .minimumScaleFactor(0.1)
        .frame(width:settings.elementWidth,
               height: settings.elementHeight,
               alignment: .center)
        .background(backgroundColor)
        .foregroundColor(Color.black)
        //.rotationEffect(.degrees(30))
       .rotationEffect(settings.shaky ? .degrees(Double( number % 23)) : .degrees(0))
        .padding(.all, settings.padding)
        .onTapGesture {
          print("tapping and selecting number \(number)")
          selected = number // pass it thru
          gameState.selected = number // gameState is class
          gameState.showing = .qanda
          onTap?(number) // Execute the closure if it exists
        }
      //  .opacity(oc == .playedCorrectly ? 0.8 : (oc == .playedIncorrectly ? 0.5:0.0))
    }

}



struct OneRowView: View {
  let firstnum: Int
  let settings:AppSettings
  @Binding var selected:Int
  @Binding var background:Color
  @Binding var isPresented:Bool
  

  var body: some View {
    let lower = firstnum
    let upper = firstnum +  Int(settings.columns)
    HStack {
      //for number in lower..<upper {
      ForEach(lower..<upper, id: \.self) { number in
        //if challenges arent ready then give it black
        let bc =   settings.topicColors && challenges.count>0 ? colorFor(topic:challenges[number].topic) : pastelColors[number % pastelColors.count]
        
        MatrixItem(number: number, backgroundColor: bc,settings:settings,selected:$selected) { renumber in
          // This block will be called when the item is tapped
          assert((renumber>=lower && renumber<=upper),"number out of range in onerowview")
          
          selected = renumber
       //   print("+++++>>> just selected \(selected) in onerowview")
          background  = pastelColors[renumber % pastelColors.count]
        
        }
      }.onChange(of:selected){
       // print("Selected changed in OneRowView")
        isPresented = true// might be delaying it a bit
      }
  }
    
  }
}

struct QuestionsGridScreen: View {
  let settings:AppSettings
  @State private var isSheetPresented = false
  @State  var selektd: Int = -1
  @State private var selectedItemBackgroundColor: Color = .clear
  
  let origined = 0// start with 0, *** might fail otherwise
  var body: some View {

    
    ScrollView([.horizontal, .vertical], showsIndicators: true) {
      VStack {
        ForEach(0..<Int(settings.rows), id: \.self) { row in
          OneRowView(firstnum:row*Int(settings.columns)+origined,
                     settings:settings,selected:$selektd,
                     background:$selectedItemBackgroundColor,
                     isPresented: $isSheetPresented)
        }
      }
    }
    .onChange(of:selektd){
     // print("selektd changed in QuestionsGridScreen")
  
    }
    .sheet(isPresented: $isSheetPresented) {
      if selektd >= 0 {
   
        DetailScreen(selected:selektd,
                     backgroundColor: selectedItemBackgroundColor,
                    settings:settings)
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
#Preview ("Game"){
  QuestionsGridScreen(settings: AppSettings())
}



struct MainScreen: View {
  let settings:AppSettings
  init (settings:AppSettings) {
    formatter.numberStyle = .spellOut
    self.settings = settings
    
  }
  @State private var isLoaded = false
  var body: some View {
    //  NavigationView {
    ZStack {
      ProgressView().opacity(!isLoaded ? 1.0:0.0)
      QuestionsGridScreen(settings:settings)
        .opacity(isLoaded ? 1.0:0.0)
    }

    //.navigationSplitViewStyle(.automatic)
    .task {
      do{
        var gamedatum:[GameData] = []
        let playdata = try await restorePlayDataURL(url)
        if let playdata = playdata {
          gamedatum = playdata.gameDatum
          
          var r:[Challenge] = []
          var totq: Int = 0
          //keep filling till all we can ever need
          while totq < Int(MAX_ROWS*MAX_COLS){
            for gd in gamedatum {
              for a in gd.challenges {
                r.append(a)
                totq+=1
              }
            }
          }
          print("about to replace gamestate, challenges are \(r.count)")
  
          
          gameState = GameState( selected: 0, showing: .qanda,  outcomes:Array(repeating:.unplayed,count:Int(MAX_ROWS*MAX_COLS)))
          
          challenges = r
          
          isLoaded = true
          print(playdata.playDataId," now available")
        }
      }
      catch {
        print("Could not restore from \(url)")
      }
    }
  }
}

#Preview ("Outer"){
  MainScreen(settings:AppSettings())
}
