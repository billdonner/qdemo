//
//  SettingsFormScreen.swift
//  qdemo
//
//  Created by bill donner on 4/23/24.
//

import SwiftUI
 

struct SettingsFormScreen: View {
  @Bindable var  settings: AppSettings
  @State var selectedLevel:Int = 1
  @State var showTopics = false
  @State private var isSelectedArray = [Bool](repeating: false, count: 26)
  var body: some View {
    ZStack {
      DismissButtonView().opacity(isIpad ? 0.0:1.0)
   
      VStack {
        if isIpad {
          Button ("Choose Topics"){
            showTopics = true
          }
        }
        Text("Controls")
        Form {
          Section(header: Text("Settings")) {
            VStack(alignment: .leading) {
              Text("HEIGHT Current: \(settings.elementWidth, specifier: "%.0f")")
              Slider(value: $settings.elementWidth, in: 60...300, step: 1.0)
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
  
          Section(header: Text("Features")) {
            Toggle(isOn: $settings.shaky) {
              Text("Shaky")
            }
            Toggle(isOn: $settings.shuffleUp) {
              Text("Shuffle on Restart")
            }.onChange(of:settings.shuffleUp) {
               shuffleChallenges(settings:settings)
            }
          }
        }
        Spacer()
       // Text("It is sometimes helpful to rotate your device!!").font(.footnote).padding()
      }
    }.sheet(isPresented: $showTopics){
      TopicSelectorScreen(settings:settings, isSelectedArray: $isSelectedArray){ // on the way back
        // necessary to recreate
        for (n,t) in gameState.topics.enumerated() {
          gameState.topics[n] = LiveTopic(id: UUID(), topic:t.topic,isLive:isSelectedArray[n],color: distinctiveColors[n])
       }
      }
    }
  }
}

#Preview ("Settings"){
  SettingsFormScreen(settings: AppSettings.mock)
}

