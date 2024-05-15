//
//  SettingsFormScreen.swift
//  qdemo
//
//  Created by bill donner on 4/23/24.
//

import SwiftUI


let header1="Playing"
let header2="Not Playing"

enum Options :Int,Codable {
  case questions
  case numeric
  case worded
}
@Observable class AppSettings :Codable {
//  static func == (lhs: AppSettings, rhs: AppSettings) -> Bool {
//    lhs.rows == rhs.rows && lhs.elementHeight == rhs.elementHeight
//  }
  
  internal init(elementWidth: CGFloat = 100, //elementHeight: CGFloat = 100,
                shaky: Bool = false,
              ltopicColors: Bool = false, shuffleUp: Bool = false,
             lazyVGrid: Bool = true,
            displayOption: Options =  .questions,
                rows: Double = 1,
               columns: Double = 1,
                fontsize: Double = 24, padding: Double = 5, border: Double = 2) {
    self.elementWidth = elementWidth
    self.elementHeight = elementWidth //  - make these square elementHeight
    self.shaky = shaky
    self.topicColors = topicColors
    self.shuffleUp = shuffleUp
    self.lazyVGrid = lazyVGrid
    self.displayOption = displayOption
    self.rows = rows
    self.columns = rows  // columns - make it square
    self.fontsize = fontsize
    self.padding = padding
    self.border = border
  }

  var elementWidth: CGFloat = 100
  var elementHeight: CGFloat = 100
  var shaky: Bool = false
  var topicColors: Bool = true
  var shuffleUp: Bool = false
  var lazyVGrid: Bool = true
  var displayOption = Options.questions
  var rows: Double = 1
  var columns: Double = 1
  var fontsize: Double = 24
  var padding: Double = 5
  var border: Double = 2
}


struct SettingsFormScreen: View {
  @Bindable var  settings: AppSettings
  @State var selectedLevel:Int = 1
  @State var showTopics = false
  @State private var isSelectedArray = [Bool](repeating: false, count: 26)
  var body: some View {
    ZStack {
      DismissButtonView().opacity(isIpad ? 0.0:1.0)
      VStack {
        Text("Q20K Controls")
        Button ("Choose Topics"){
          showTopics = true
        }
//        let t = topics.map {$0.topic}
//        TopicsChooserButtonView(topics:t){
//          
//        }
        Form {
          Section(header: Text("Settings")) {
            
            
            VStack(alignment: .leading) {
              Text("ROWS Current: \(settings.rows, specifier: "%.0f")")
              Slider(value: $settings.rows, in: MIN_ROWS...MAX_ROWS, step: 1.0)
            }
            //            VStack(alignment: .leading) {
            //              Text("COLS Current: \(settings.columns, specifier: "%.0f")")
            //              Slider(value: $settings.columns, in: 1...MAX_COLS, step: 1.0)
            //            }
            //            VStack(alignment: .leading) {
            //              Text("WIDTH Current: \(settings.elementWidth, specifier: "%.0f")")
            //              Slider(value: $settings.elementWidth, in: 60...300, step: 1.0)
            //            }
            VStack(alignment: .leading) {
              Text("HEIGHT Current: \(settings.elementHeight, specifier: "%.0f")")
              Slider(value: $settings.elementHeight, in: 60...300, step: 1.0)
            }
            VStack(alignment: .leading) {
              Text("FONTSIZE Current: \(settings.fontsize, specifier: "%.0f")")
              Slider(value: $settings.fontsize, in: 8...40, step: 2.0)
            }
            VStack(alignment: .leading) {
              Text("PADDING Current: \(settings.padding, specifier: "%.0f")")
              Slider(value: $settings.padding, in: 1...40, step: 1.0)
            }
            VStack(alignment: .leading) {
              Text("BORDER Current: \(settings.border, specifier: "%.0f")")
              Slider(value: $settings.border, in: 0...20, step: 1.0)
            }
          }
            .onChange(of: settings.elementHeight) {
              settings.elementWidth = settings.elementHeight
            }
            .onChange(of: settings.rows ){
              settings.columns = settings.rows
            }
            // .pickerStyle(InlinePickerStyle())// You can adjust the picker style
            
//            
//            .onChange(of: selectedLevel,initial:true) {
//              switch selectedLevel {
//              case 1:
//                settings.displayOption = .numeric
//              case 2:
//                settings.displayOption = .worded
//              case 3:
//                settings.displayOption = .questions
//              default:
//                settings.displayOption = .questions
//              }
//            }
        
          Section(header: Text("Features")) {
            Toggle(isOn: $settings.shaky) {
              Text("Shaky")
            }
//            Toggle(isOn: $settings.topicColors) {
//              Text("Colors by Topic")
//            }
            Toggle(isOn: $settings.shuffleUp) {
              Text("Shuffle on Restart")
            }.onChange(of:settings.shuffleUp) {
              rebuildWorld(settings:settings)
            }
//            Toggle(isOn: $settings.lazyVGrid) {
//              Text("LazyVGrid")
//            }
          }
          
        }
        Spacer()
       // Text("It is sometimes helpful to rotate your device!!").font(.footnote).padding()
      }
    }.sheet(isPresented: $showTopics){

      
      TopicSelectorScreen(topics:liveTopics.map{$0.topic} , isSelectedArray: $isSelectedArray ){
        for (n,t) in liveTopics.enumerated() {
          liveTopics[n] = LiveTopic(topic:t.topic,isLive:isSelectedArray[n])
 
        }
        print("livetopics3: ",liveTopics)
        for lt in liveTopics {
          if lt.isLive {
            print("live now: \(lt.topic)")
          }
        }
      }
    }
  }
}

#Preview ("Settings"){
  SettingsFormScreen(settings: AppSettings())
}

