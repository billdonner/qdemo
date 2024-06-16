//
//  SettingsFormScreen.swift
//  qdemo
//
//  Created by bill donner on 4/23/24.
//

import SwiftUI
 

struct FreeportSettingsScreen: View {
  @AppStorage("elementWidth") var elementWidth = 100.0
  @AppStorage("shuffleUp") private var shuffleUp = true
  @AppStorage("fontsize") private var fontsize = 24.0
  @AppStorage("padding") private var padding = 2.0
  @AppStorage("border") private var border = 3.0
  @State var selectedLevel:Int = 1
  @State var showOnBoarding = false
  @State private var isSelectedArray = [Bool](repeating: false, count: 26)
  var body: some View {
    ZStack {
      DismissButtonView().opacity(isIpad ? 0.0:1.0)
      VStack {
        Text("Freeport Controls")
        Form {
          Section(header: Text("Not For Civilians")) {
            VStack(alignment: .leading) {
              Text("SIZE Current: \( elementWidth, specifier: "%.0f")")
              Slider(value:  $elementWidth, in: 60...300, step: 1.0)
            }
            VStack(alignment: .leading) {
              Text("FONTSIZE Current: \( fontsize, specifier: "%.0f")")
              Slider(value:  $fontsize, in: 8...40, step: 2.0)
            }
            VStack(alignment: .leading) {
              Text("PADDING Current: \( padding, specifier: "%.0f")")
              Slider(value:  $padding, in: 1...40, step: 1.0)
            }
            VStack(alignment: .leading) {
              Text("BORDER Current: \( border, specifier: "%.0f")")
              Slider(value:  $border, in: 0...20, step: 1.0)
            }
            
            Button(action:{ showOnBoarding.toggle() }) {
              Text("Replay OnBoarding")
            }.padding(.vertical)
          }
          
        }
        .fullScreenCover(isPresented: $showOnBoarding) {
          OnboardingScreen(isPresented: $showOnBoarding)
        }
        
        Spacer()
        // Text("It is sometimes helpful to rotate your device!!").font(.footnote).padding()
      }
    }
  }
}

#Preview ("Settings"){
  FreeportSettingsScreen()
}

