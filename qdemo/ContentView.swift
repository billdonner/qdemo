//
//  ContentView.swift
//  qdemo
//
//  Created by bill donner on 4/9/24.
//
import SwiftUI

// Define an array of pastel colors for the background
 let pastelColors: [Color] = [
  Color(red: 0.98, green: 0.85, blue: 0.87),
  Color(red: 0.84, green: 0.98, blue: 0.85),
  Color(red: 0.86, green: 0.91, blue: 0.98),
  Color(red: 0.98, green: 0.92, blue: 0.85),
  Color(red: 0.88, green: 0.85, blue: 0.98),
  Color(red: 0.98, green: 0.85, blue: 0.89),
  Color(red: 0.85, green: 0.98, blue: 0.96),
]

let formatter = NumberFormatter()
// Convert number to words
func convertNumberToWords(_ number: Int) -> String? {
  return formatter.string(from: NSNumber(value: number))
}

@Observable class AppSettings  {
  var elementWidth: CGFloat = 60
   var elementHeight: CGFloat = 60
    var shaky: Bool = false
 var worded: Bool = false
 var rows: Double = 4
  var columns: Double = 3
}

struct MatrixItem: View {
    let number: Int
    let backgroundColor: Color
    let settings:AppSettings
    var onTap: (() -> Void)? // Closure to be executed on tap
    
    var body: some View {
      let boxContents:String  = settings.worded ? (convertNumberToWords(number) ?? "\(number)") :
      "\(number)"
      
        Text(boxContents)
            .font(.system(size: 20))
            .lineLimit(1)
            .minimumScaleFactor(0.1)
            .frame(width:settings.elementWidth, height: settings.elementHeight, alignment: .center)
            .background(backgroundColor)
            .foregroundColor(Color.black)
            .rotationEffect(settings.shaky ? .degrees(Double( number % 23)) : .degrees(0))
            .padding(1)
            .onTapGesture {
                onTap?() // Execute the closure if it exists
            }
    }

}

struct DetailView: View {
    let text: String
    let backgroundColor: Color
    
  var body: some View {
    NavigationView {
      ZStack {
        backgroundColor.edgesIgnoringSafeArea(.all)
        Text(text)
          .font(.largeTitle)
          .foregroundColor(.black) // Assuming the background is dark enough; adjust accordingly.
          .padding()
      }.navigationTitle("Details for \(text)")
    }
  }
}
#Preview("Details") {
  DetailView(text: "Now is the time for all good men to go home",
             backgroundColor:.yellow)
}

struct OneRowView: View {
  let firstnum: Int
  let settings:AppSettings
  @Binding var selected:String
  @Binding var background:Color
  @Binding var isPresented:Bool
  var body: some View {
    let delta = Int((settings.rows-1) * (settings.columns))-1
    let lower = firstnum+Int(settings.rows*settings.columns)-delta
    let upper = firstnum+Int(settings.rows+1)*Int(settings.columns)-delta
    HStack {
      //for number in lower..<upper {
   ForEach(lower..<upper, id: \.self) { number in
        MatrixItem(number: number, backgroundColor: pastelColors[number % pastelColors.count],settings:settings) {
          // This block will be called when the item is tapped
         selected = convertNumberToWords(number) ?? "\(number)"
          background  = pastelColors[number % pastelColors.count]
        isPresented = true
        }
      }
    }
  }
}

struct OuterMatrixView: View {
  let settings:AppSettings
  @State private var isSheetPresented = false
  @State private var selectedItemText: String = ""
  @State private var selectedItemBackgroundColor: Color = .clear
  
  
  var body: some View {
    ScrollView([.horizontal, .vertical], showsIndicators: true) {
      VStack {
        ForEach(0..<Int(settings.rows), id: \.self) { row in
          OneRowView(firstnum:(row-1)*Int(settings.columns),
                     settings:settings,selected:$selectedItemText,background:$selectedItemBackgroundColor, isPresented: $isSheetPresented)
        }
      }
    }
    .sheet(isPresented: $isSheetPresented) {
      DetailView(text: selectedItemText, backgroundColor: selectedItemBackgroundColor)
    }
  }
}
#Preview ("Game"){
OuterMatrixView(settings: AppSettings())
}
struct SettingsFormView: View {
@Bindable var  settings: AppSettings
  @State private var isPresentingMainView = false
    var body: some View {
       // NavigationView {
            Form {
                Section(header: Text("Settings")) {
                    VStack(alignment: .leading) {
                      Text("ROWS Current: \(settings.rows, specifier: "%.0f")")
                      Slider(value: $settings.rows, in: 1...20, step: 1.0)
                
                    }
                    
                    VStack(alignment: .leading) {
                      Text("COLS Current: \(settings.columns, specifier: "%.0f")")
                      Slider(value: $settings.columns, in: 1...20, step: 1.0)
                      
                    }
                  VStack(alignment: .leading) {
                    Text("WIDTH Current: \(settings.elementWidth, specifier: "%.0f")")
                      Slider(value: $settings.elementWidth, in: 60...300, step: 1.0)
                  }
                  
                  VStack(alignment: .leading) {
                      Text("HEIGHT Current: \(settings.elementHeight, specifier: "%.0f")")
                    Slider(value: $settings.elementHeight, in: 60...300, step: 1.0)
                  }
              }
              Section(header: Text("Features")) {
                  Toggle(isOn: $settings.shaky) {
                    Text("Shaky")
                }
                
                Toggle(isOn:$settings.worded) {
                      Text("Worded")
                  }
              }
                
//                Button("Go To Demo") {
//                    isPresentingMainView = true
//                }.sheet(isPresented: $isPresentingMainView) {
//                    ContentView(settings: settings)
//                }
            }
           // .navigationBarTitle("Q20K Lab")
      //  }
    }
}

#Preview ("Settings"){
  SettingsFormView(settings: AppSettings())
}

struct ContentView: View {
  let settings:AppSettings
  init (settings:AppSettings) {
    formatter.numberStyle = .spellOut
    self.settings = settings
  }
  var body: some View {
    NavigationView {
      VStack{
        SettingsFormView(settings: settings)
        .background(.gray)
          .frame(height:120)
        
          OuterMatrixView(settings:settings)
      }
        .navigationTitle("Q20K Laboratory")
    }
  }
}

#Preview ("Outer"){
  ContentView(settings:AppSettings())
}
