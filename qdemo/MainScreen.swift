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
  var onTap: ((Int) -> Void)? // Closure to be executed on tap
  
  var body: some View {
    ZStack {
      Rectangle()//cornerSize: CGSize(width: 30, height: 30))
        .frame(width:settings.elementWidth+settings.border, 
               height: settings.elementHeight+settings.border,
               alignment: .center)
        .background(.white)
      Text(boxCon(number,settings: settings))
        .font(.system(size:settings.fontsize))
        .lineLimit(5)
        .minimumScaleFactor(0.1)
        .frame(width:settings.elementWidth,
               height: settings.elementHeight,
               alignment: .center)
        .background(backgroundColor)
        .foregroundColor(Color.black)
        .rotationEffect(settings.shaky ? .degrees(Double( number % 23)) : .degrees(0))
        .padding(.all, settings.padding)
        .onTapGesture {
          onTap?(number) // Execute the closure if it exists
        }
    }
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
        let bc =  settings.topicColors && challenges.count>0 ? colorFor(topic:challenges[number].topic) : pastelColors[number % pastelColors.count]
        MatrixItem(number: number, backgroundColor: bc,settings:settings) { renumber in
          // This block will be called when the item is tapped
          assert((renumber>=lower && renumber<=upper),"number out of range in onerowview")
          selected = renumber
          background  = pastelColors[renumber % pastelColors.count]
          isPresented = true
        }
      }
    }
  }
}

struct QuestionsGridScreen: View {
  let settings:AppSettings
  @State private var isSheetPresented = false
  @State private var selected: Int = -1
  @State private var selectedItemBackgroundColor: Color = .clear
  
  let origined = 1 // start with 1
  var body: some View {
    ScrollView([.horizontal, .vertical], showsIndicators: true) {
      VStack {
        ForEach(0..<Int(settings.rows), id: \.self) { row in
          OneRowView(firstnum:row*Int(settings.columns)+origined,
                     settings:settings,selected:$selected,
                     background:$selectedItemBackgroundColor,
                     isPresented: $isSheetPresented)
        }
      }
    }
    .fullScreenCover(isPresented: $isSheetPresented) {
      if selected > 0 {
   
        // build gameState here for the momemt
        
        let gs = GameState(thisChallenge: challenges[selected], thisOutcome: outcomes[selected], showing: .qanda)
        DetailScreen(selected:selected,
                     backgroundColor: selectedItemBackgroundColor,
                     settings:settings, gameState:gs)
      } else {
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
    .navigationTitle("Q20K Laboratory")
    //.navigationSplitViewStyle(.automatic)
    .task {
      do{
        var gamedatum:[GameData] = []
        let playdata = try await restorePlayDataURL(url)
        if let playdata = playdata {
          gamedatum = playdata.gameDatum
          //let topics = playdata.topicData.topics
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
          
          challenges = r
          outcomes = Array(repeating:.unplayed,count:r.count)
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
