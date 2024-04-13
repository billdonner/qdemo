//
//  ContentView.swift
//  qdemo
//
//  Created by bill donner on 4/9/24.
//
import SwiftUI
import q20kshare


var questions:[String] = []
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
 let r =  formatter.string(from: NSNumber(value: number)) ?? ""
 return  (r as NSString).replacingOccurrences(of: "-", with: " ")
}
// Convert number to question from q20k
func convertNumberToQuestion(_ number: Int) -> String? {
  guard number > 0 && number <= questions.count else {return nil}
 return questions [number-1]
}

@Observable class AppSettings  {
  var elementWidth: CGFloat = 100
  var elementHeight: CGFloat = 100
  var shaky: Bool = false
  var worded: Bool = false
  var questions: Bool = true
  var rows: Double = 4
  var columns: Double = 3
  var fontsize: Double = 16
}

func boxCon (_ number:Int,settings:AppSettings) -> String {
  if settings.questions {
    let a =  convertNumberToQuestion(number)
    if a != nil { return a! }
  }
  if settings.worded {
    let b = convertNumberToWords(number)
    if b != nil {return b! }
  }
    return "\(number)"
  }
struct MatrixItem: View {
  let number: Int
  let backgroundColor: Color
  let settings:AppSettings
  var onTap: (() -> Void)? // Closure to be executed on tap
  
  
  var body: some View {
    Text(boxCon(number,settings: settings))
      .font(.system(size:settings.fontsize))
      .lineLimit(5)
      .minimumScaleFactor(0.1)
      .frame(width:settings.elementWidth, height: settings.elementHeight, alignment: .center)
      .background(backgroundColor)
      .foregroundColor(Color.black)
      .rotationEffect(settings.shaky ? .degrees(Double( number % 23)) : .degrees(0))
      .padding(2)
      .onTapGesture {
        onTap?() // Execute the closure if it exists
      }
  }
  
}

struct DetailView: View {
  let selected:Int
  let backgroundColor: Color
  let settings:AppSettings
  
  var body: some View {
    NavigationView {
      ZStack {
        backgroundColor.edgesIgnoringSafeArea(.all)
        Text(boxCon(selected,settings:settings))
          .font(.largeTitle)
          .foregroundColor(.black) // Assuming the background is dark enough; adjust accordingly.
          .padding()
      }.navigationTitle("Details for question \(selected)")
    }
  }
}
#Preview("Details") {
  DetailView(selected:1999,
             backgroundColor:.yellow,settings:AppSettings())
}

struct OneRowView: View {
  let firstnum: Int
  let settings:AppSettings
  @Binding var selected:Int
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
          selected = number
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
  @State private var selected: Int = -1
  @State private var selectedItemBackgroundColor: Color = .clear
  
  
  var body: some View {
    ScrollView([.horizontal, .vertical], showsIndicators: true) {
      VStack {
        ForEach(0..<Int(settings.rows), id: \.self) { row in
          OneRowView(firstnum:(row-1)*Int(settings.columns),
                     settings:settings,selected:$selected,background:$selectedItemBackgroundColor, isPresented: $isSheetPresented)
        }
      }
    }
    .sheet(isPresented: $isSheetPresented) {
      if selected > 0 {
        DetailView(selected:selected, backgroundColor: selectedItemBackgroundColor,settings:settings)
      }
    }
  }
}
#Preview ("Game"){
  OuterMatrixView(settings: AppSettings())
}
let MAX_ROWS = 30.0
let MAX_COLS = 30.0

struct SettingsFormView: View {
  @Bindable var  settings: AppSettings
  @State private var isPresentingMainView = false
  var body: some View {
    // NavigationView {
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
      }
      Section(header: Text("Features")) {
        Toggle(isOn: $settings.shaky) {
          Text("Shaky")
        }
        
        Toggle(isOn:$settings.worded) {
          Text("Worded")
        }
        
        Toggle(isOn:$settings.questions) {
          Text("Questions")
        }
      }
      
    }
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
  @State private var isLoaded = false
  var body: some View {
    NavigationView {
      ZStack {
        ProgressView().opacity(!isLoaded ? 1.0:0.0)
        VStack{
          SettingsFormView(settings: settings)
            .frame(height:300)
          Divider()
          OuterMatrixView(settings:settings)
        }.opacity(isLoaded ? 1.0:0.0)
      }
      .navigationTitle("Q20K Laboratory")
    }.navigationViewStyle(.stack)
    .task {
      do{
        var gamedatum:[GameData] = []
        let playdata = try await restorePlayDataURL(url)
        if let playdata = playdata {
          gamedatum = playdata.gameDatum
          var r:[String] = []
          var totq: Int = 0
          //keep filling till all we can ever need
          while totq < Int(MAX_ROWS*MAX_COLS){
            for gd in gamedatum {
              for a in gd.challenges {
                r.append(a.question)
                totq+=1
              }
            }
          }
          
          questions = r
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
  ContentView(settings:AppSettings())
}
