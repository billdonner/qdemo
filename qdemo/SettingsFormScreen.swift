//
//  SettingsFormScreen.swift
//  qdemo
//
//  Created by bill donner on 4/23/24.
//

import SwiftUI


@Observable class AppSettings  {
  enum options {
    case numeric
    case worded
    case questions
  }
  var elementWidth: CGFloat = 100
  var elementHeight: CGFloat = 100
  var shaky: Bool = false
  var topicColors: Bool = false
  var displayOption = options.numeric
  var rows: Double = 4
  var columns: Double = 3
  var fontsize: Double = 24
  var padding: Double = 5
  var border: Double = 2
}


struct SettingsFormScreen: View {
  @Bindable var  settings: AppSettings
  @State private var isPresentingMainView = false
  @State var selectedLevel:Int = 1
  var body: some View {
    Text("Q20K Controls")
    Form {
      Section(header: Text("Settings")) {
        VStack(alignment: .leading) {
          Text("ROWS Current: \(settings.rows, specifier: "%.0f")")
          Slider(value: $settings.rows, in: 1...MAX_ROWS, step: 1.0)
        }
        VStack(alignment: .leading) {
          Text("COLS Current: \(settings.columns, specifier: "%.0f")")
          Slider(value: $settings.columns, in: 1...MAX_COLS, step: 1.0)
        }
        VStack(alignment: .leading) {
          Text("WIDTH Current: \(settings.elementWidth, specifier: "%.0f")")
          Slider(value: $settings.elementWidth, in: 60...300, step: 1.0)
        }
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
        VStack {
          Picker("Select Celltype", selection: $selectedLevel) {
            Text("numeric").tag(1)
            Text("number words").tag(2)
            Text("questions").tag(3)
          }.font(.largeTitle)
          // .pickerStyle(InlinePickerStyle())// You can adjust the picker style
          
        }.padding()
          .onChange(of: selectedLevel,initial:true) {
            switch selectedLevel {
            case 1:
              settings.displayOption = .numeric
            case 2:
              settings.displayOption = .worded
            case 3:
              settings.displayOption = .questions
            default:
              settings.displayOption = .numeric
            }
          }
      }
      Section(header: Text("Features")) {
        Toggle(isOn: $settings.shaky) {
          Text("Shaky")
        }
        Toggle(isOn: $settings.topicColors) {
          Text("Colors by Topic")
        }
      }
    }
    Spacer()
    Text("It is sometimes helpful to rotate your device!!").font(.footnote).padding()
  }
}

#Preview ("Settings"){
  SettingsFormScreen(settings: AppSettings())
}
