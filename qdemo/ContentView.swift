//
//  ContentView.swift
//  qdemo2
//
//  Created by bill donner on 4/14/24.
//

import SwiftUI
import q20kshare



let url = URL(string:"https://billdonner.com/fs/gd/readyforios02.json")!

let MAX_ROWS = 50.0
let MAX_COLS = 200.0

var challenges:[Challenge] = []



let pastelColors: [Color] = [
  Color(red: 0.98, green: 0.85, blue: 0.87),
  Color(red: 0.84, green: 0.98, blue: 0.85),
  Color(red: 0.86, green: 0.91, blue: 0.98),
  Color(red: 0.98, green: 0.92, blue: 0.85),
  Color(red: 0.88, green: 0.85, blue: 0.98),
  Color(red: 0.98, green: 0.85, blue: 0.89),
  Color(red: 0.85, green: 0.98, blue: 0.96),
  Color(red: 0.93, green: 0.85, blue: 0.98),
  Color(red: 0.98, green: 0.89, blue: 0.85),
  Color(red: 0.85, green: 0.95, blue: 0.98),
  Color(red: 0.98, green: 0.87, blue: 0.90),
  Color(red: 0.90, green: 0.98, blue: 0.87),
  Color(red: 0.87, green: 0.90, blue: 0.98),
  Color(red: 0.98, green: 0.90, blue: 0.83),
  Color(red: 0.83, green: 0.96, blue: 0.98),
  Color(red: 0.92, green: 0.88, blue: 0.98),
  Color(red: 0.98, green: 0.95, blue: 0.89),
  Color(red: 0.89, green: 0.98, blue: 0.93),
  Color(red: 0.85, green: 0.89, blue: 0.98),
  Color(red: 0.98, green: 0.91, blue: 0.87),
  Color(red: 0.91, green: 0.98, blue: 0.85),
  Color(red: 0.85, green: 0.87, blue: 0.98),
  Color(red: 0.96, green: 0.85, blue: 0.98),
  Color(red: 0.98, green: 0.93, blue: 0.90),
  Color(red: 0.90, green: 0.87, blue: 0.98),
]

let formatter = NumberFormatter()

@Observable class AppSettings  {
  enum options {
    case numeric
    case worded
    case questions
  }
  var elementWidth: CGFloat = 100
  var elementHeight: CGFloat = 100
  var shaky: Bool = false
  var topicColors: Bool = true
  var displayOption = options.numeric
  var rows: Double = 4
  var columns: Double = 3
  var fontsize: Double = 24
  var padding: Double = 5
  var border: Double = 2
}

// Convert number to words
func convertNumberToWords(_ number: Int) -> String? {
  let r =  formatter.string(from: NSNumber(value: number)) ?? ""
  return  (r as NSString).replacingOccurrences(of: "-", with: " ")
}
// Convert number to question from q20k
func convertNumberToQuestion(_ number: Int) -> String? {
  guard number > 0 && number <= challenges.count else {return nil}
  return challenges [number-1].question
}

func downloadFile(from url: URL ) async throws -> Data {
  let (data, _) = try await URLSession.shared.data(from: url)
  return data
}

func restorePlayDataURL(_ url:URL) async  throws -> PlayData? {
  do {
    let start_time = Date()
    let tada = try await  downloadFile(from:url)
    let str = String(data:tada,encoding:.utf8) ?? ""
    do {
      let pd = try JSONDecoder().decode(PlayData.self,from:tada)
      let elapsed = Date().timeIntervalSince(start_time)
      print("************")
      print("Downloaded \(pd.playDataId) in \(elapsed) secs from \(url)")
      let challengeCount = pd.gameDatum.reduce(0,{$0 + $1.challenges.count})
      print("Loaded"," \(pd.gameDatum.count) topics, \(challengeCount) challenges in \(elapsed) secs")
      print("************")
      return pd
    }
    catch {
      print(">>> could not decode playdata from \(url) \n>>> original str:\n\(str)")
    }
  }
  catch {
    throw error
  }
  return nil
}

func boxCon (_ number:Int,settings:AppSettings) -> String {
  switch settings.displayOption {
  case .numeric: break
  case .questions:
    let a = convertNumberToQuestion(number)
    if a != nil { return a! }
  case.worded:
    let b = convertNumberToWords(number)
    if b != nil {return b! }
  }
  return "\(number)"
}

struct MatrixItem: View {
  let number: Int
  let backgroundColor: Color
  let settings:AppSettings
  var onTap: ((Int) -> Void)? // Closure to be executed on tap
  
  var body: some View {
    ZStack {
      Rectangle()//cornerSize: CGSize(width: 30, height: 30))
        .frame(width:settings.elementWidth+settings.border, height: settings.elementHeight+settings.border, alignment: .center)
      Text(boxCon(number,settings: settings))
        .font(.system(size:settings.fontsize))
        .lineLimit(5)
        .minimumScaleFactor(0.1)
        .frame(width:settings.elementWidth, height: settings.elementHeight, alignment: .center)
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
    let lower = firstnum
    let upper = firstnum +  Int(settings.columns)
    HStack {
      //for number in lower..<upper {
      ForEach(lower..<upper, id: \.self) { number in
        MatrixItem(number: number, backgroundColor: pastelColors[number % pastelColors.count],settings:settings) { renumber in
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
                     settings:settings,selected:$selected,background:$selectedItemBackgroundColor, isPresented: $isSheetPresented)
        }
      }
    }
    .sheet(isPresented: $isSheetPresented) {
      if selected > 0 {
        DetailView(selected:selected, backgroundColor: selectedItemBackgroundColor,settings:settings)
      } else {
        Circle().foregroundColor(.red)
      }
    }
  }
}
#Preview ("Game"){
  QuestionsGridScreen(settings: AppSettings())
}


struct SettingsFormScreen: View {
  @Bindable var  settings: AppSettings
  @State private var isPresentingMainView = false
  @State var selectedLevel:Int = 0
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
            Text("numeric").tag(1).font(.largeTitle)
            Text("number words").tag(2).font(.largeTitle)
            Text("questions").tag(3).font(.largeTitle)
          }
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

struct ContentView: View {
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
    .navigationSplitViewStyle(.automatic)
    .task {
      do{
        var gamedatum:[GameData] = []
        let playdata = try await restorePlayDataURL(url)
        if let playdata = playdata {
          gamedatum = playdata.gameDatum
          let topics = playdata.topicData.topics
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
