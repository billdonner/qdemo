//
//  ContentView.swift
//  qdemo2
//
//  Created by bill donner on 4/14/24.
//

import SwiftUI
import q20kshare
func rebuildWorld(  settings:AppSettings) {
       gameState = GameState( selected: 0, showing: .qanda,  outcomes:Array(repeating:.unplayed,count:Int(MAX_ROWS*MAX_COLS)))
  if !settings.shuffleUp {
    challenges.shuffle()
  }
}


struct MatrixItem: View {
  let number: Int
  let backgroundColor: Color
  let settings:AppSettings
  @Binding var selected:Int
  var onTap: ((Int) -> Void)? // Closure to be executed on tap
  
  var body: some View {
    //let _ = print("MatrixItem \(number)")
    Text(boxCon(number,settings: settings))
      .font(.system(size:settings.fontsize))
      .lineLimit(7)
      .minimumScaleFactor(0.1)
      .frame(width:settings.elementWidth,
             height: settings.elementHeight,
             alignment: .center)
      .background(backgroundColor)
    //.foregroundColor(Color.black)
    //.rotationEffect(.degrees(30))
      .padding(.all, settings.padding)
      .onTapGesture {
        //print("tapping and selecting number \(number)")
        selected = number // pass it thru
        gameState.selected = number // gameState is class
        gameState.showing = .qanda
        onTap?(number) // Execute the closure if it exists
      }
    //      .foregroundStyle(
    //        number<0||number>gameState.outcomes.count-1 ? Color.red :
    //          (gameState.outcomes[number] == .unplayed ? Color.blue:
    //            (gameState.outcomes[number] == .playedCorrectly ? Color.green:.red
    //          )))
      .opacity(
        number<0||number>gameState.outcomes.count-1 ? 0.0:
          (gameState.outcomes[number] == .unplayed ? 1.0:
            (gameState.outcomes[number] == .playedCorrectly ? 0.8:0.8
            )))
      .border(    number<0||number>gameState.outcomes.count-1 ? .gray:
                    (gameState.outcomes[number] == .unplayed ? .gray:
                      (gameState.outcomes[number] == .playedCorrectly ? .green:.red
                      ))
                  
                  ,
                  width:
                    number<0||number>gameState.outcomes.count-1 ? 0.0:
                    (gameState.outcomes[number] == .unplayed ? 1.0:
                      (gameState.outcomes[number] == .playedCorrectly ? 5:5
                      )))
    
    
      .rotationEffect(settings.shaky ? .degrees(Double( number % 23)) : .degrees(0))
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
          assert((renumber>=lower && renumber<=upper),"number out of range in onerowview")
          selected = renumber
          //   print("+++++>>> just selected \(selected) in onerowview")
          background  = pastelColors[renumber % pastelColors.count]
          isPresented = true// might be delaying it a bit
        }
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
    let ll = Int(settings.rows*settings.columns) - gameState.grandScore - gameState.grandLosers
    VStack{
      HStack {
        Text("score:\(gameState.grandScore)")
        Spacer()
        Text("remaining:\(ll)")
      }.font(.headline).padding()
      if settings.lazyVGrid {
        //let _ = print("lazyVGrid")
        ScrollView([.vertical, .horizontal], showsIndicators: true) {
          let columns = Array(repeating: GridItem(.flexible(), spacing: settings.padding), count: Int(settings.columns))
          
          LazyVGrid(columns: columns, spacing:settings.border) {
            ForEach(0..<Int(settings.rows) * Int(settings.columns), id: \.self) { number in
   
              let bc =   settings.topicColors && challenges.count>0 ? colorFor(topic:challenges[number].topic) : pastelColors[number % pastelColors.count]
              
              MatrixItem(number: number, backgroundColor: bc,settings:settings,selected:$selektd) { renumber in
                // assert((renumber>=lower && renumber<=upper),"number out of range in onerowview")
                selektd = renumber
                //   print("+++++>>> just selected \(selected) in onerowview")
                selectedItemBackgroundColor  = pastelColors[renumber % pastelColors.count]
                isSheetPresented = true// might be delaying it a bit
              }
            }
          }
        }
      } else {
        
        let _ = print("manual grid")
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
      }
    }
    
    //    .onChange(of:selektd){
    //      print("selektd changed in QuestionsGridScreen")
    //    }
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
          
          challenges = r
          topics = playdata.topicData.topics.map {$0.name}
          rebuildWorld(settings:settings)
          
          isLoaded = true
          print(playdata.playDataId," available; challenges are \(r.count); \(topics.count) topics")
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
