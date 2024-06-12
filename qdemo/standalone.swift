
/**


 
 */
import SwiftUI

/** globals */
var challenges:[Challenge] = [Challenge(question: "For Madmen Only", topic: "Flowers", hint: "long time ago", answers: ["most","any","old","song"], correct: "old", id: "UUID320239", date: Date.now, aisource: "donner's brain")]
var gameState = GameState.makeMock() // will replace
var aiPlayData:PlayData? = nil

enum ChallengeOutcomes : Codable,Equatable{
  case unplayed
  case playedCorrectly
  case playedIncorrectly
}

struct IdentifiableInteger: Identifiable {
  let id = UUID()
  let val: Int
}


enum ShowingState : Codable,Equatable {
  case qanda
  case hint
  case answerWasCorrect
  case answerWasIncorrect
}

/// copied out from q20kshare
///
public struct Challenge : Codable,Equatable,Hashable,Identifiable  {
  public init(question: String, topic: String, hint: String, answers: [String], correct: String, explanation: String? = nil, id: String, date: Date, aisource: String,notes:String? = nil) {
    self.question = question
    self.topic = topic
    self.hint = hint
    self.answers = answers
    self.correct = correct
    self.explanation = explanation
    self.id = id
    self.date = date
    self.aisource = aisource
  self.notes = notes
  }
  

  public let question: String
  public let topic: String
  public let hint:String // a hint to show if the user needs help
  public let answers: [String]
  public let correct: String // which answer is correct
  public let explanation: String? // reasoning behind the correctAnswer
  public let id:String // can be real uuid
  public let date:Date // hmmm
  public let aisource:String
  public let notes:String? // for excel users, etc
  
  
  public static func decodeArrayFrom(data:Data) throws -> [Challenge]{
    try JSONDecoder().decode([Challenge].self, from: data)
  }
  public static func decodeFrom(data:Data) throws -> Challenge {
    try JSONDecoder().decode( Challenge.self, from: data)
  }
  
}

public struct Topic : Codable {
  public init(name: String, subject: String,  pic: String, notes: String, subtopics:[String]) {
    self.name = name
    self.subject = subject
    self.pic = pic
    self.notes = notes
    self.subtopics = subtopics
  }
  
  public  var name: String
  public  var subject: String
  public  var pic: String // symbol or url
  public  var notes: String // editors comments
  public  var subtopics: [String]
  
}
public struct TopicGroup : Codable {
  public init(description: String, version: String, author: String, date: String, topics: [Topic]) {
    self.description = description
    self.version = version
    self.author = author
    self.date = date
    self.topics = topics
  }
  
  public var description:String
  public var version:String
  public var author:String
  public var date:String
  public var topics:[Topic]
}
public struct GameData : Codable, Hashable,Identifiable,Equatable {
  public  init(topic: String, challenges: [Challenge],pic:String? = "leaf",shuffle:Bool = false,commentary:String? = nil ) {
    self.topic = topic
    self.challenges = shuffle ? challenges.shuffled() : challenges
    self.id = UUID().uuidString
    self.generated = Date()
    self.pic = pic
    self.commentary = commentary
  }
  
  public   let id : String
  public   let topic: String
  public   let challenges: [Challenge]
  public   let generated: Date
  public   let pic:String?
  public   let commentary:String?
}

/* a full blended playing field is published to the IOS App*/
public struct PlayData: Codable {
  public init(topicData:TopicGroup, gameDatum: [GameData], playDataId: String, blendDate: Date, pic: String? = nil) {
    self.topicData = topicData
    self.gameDatum = gameDatum
    self.playDataId = playDataId
    self.blendDate = blendDate
    self.pic = pic
  }
  
  public let topicData: TopicGroup
  public let gameDatum: [GameData]
  public let playDataId: String
  public let blendDate: Date
  public let pic:String?
  
}

///
@Observable class GameState  : Codable  {
  internal init(selected:Int, showing: ShowingState,outcomes:[ChallengeOutcomes],topics:[LiveTopic],gimmees:Int) {
    self.showing = showing
    self.outcomes = outcomes
    self.topics = topics
    self.selected = selected
    self.gimmees = gimmees
  }
  

  var showing:ShowingState
  var outcomes:[ChallengeOutcomes] // parallels big challenges array
  var topics:[LiveTopic]
  var selected:Int // index into outcomes and challenges
  var gimmees:Int // bonus points
  
  // these are needed when @Observable needs to be codable
  enum CodingKeys: String, CodingKey {
    case _showing = "showing"
    case _outcomes = "outcoms"
    case _topics = "topics"
    case _selected = "selected"
    case _gimmees = "gimmees"
 
    
  }

}

extension GameState {
  var grandScore : Int {
    outcomes.reduce(0) { $0 + ($1 == .playedCorrectly ? 1 : 0 )}
  }
  var grandLosers : Int {
    outcomes.reduce(0) { $0 + ($1 == .playedIncorrectly ? 1 : 0 )}
  }
  var stillToPlay : Int {
    outcomes.reduce(0) { $0 + ($1 == .unplayed ? 1 : 0 )}
  }
  var thisChallenge:Challenge {
    return challenges[selected]
  }
  var thisOutcome:ChallengeOutcomes {
    outcomes[selected]
  }
  
  func saveGameState(_ gameState: GameState, to fileName: String) {
    let encoder = JSONEncoder()
    do {
      let data = try encoder.encode(gameState)
      if let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        let fileURL = directory.appendingPathComponent(fileName)
        try data.write(to: fileURL)
        print("GameState saved to \(fileURL.path)")
      }
    } catch {
      print("Failed to save game state: \(error.localizedDescription)")
    }
  }
 static  func saveGameState(_ gameState: GameState, to fileName: String) {
      let encoder = JSONEncoder()
      do {
          let data = try encoder.encode(gameState)
          if let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
              let fileURL = directory.appendingPathComponent(fileName)
              try data.write(to: fileURL)
              print("GameState saved to \(fileURL.path)")
          }
      } catch {
          print("Failed to save game state: \(error.localizedDescription)")
      }
  }
  
}
extension GameState {
  static   let onechallenge = Challenge(question: "For Madmen Only", topic: "Flowers", hint: "long time ago", answers: ["most","any","old","song"], correct: "old", id: "UUID320239", date: Date.now, aisource: "donner's brain")
  static var  mock = GameState(selected: 0, showing:.qanda,outcomes:[.unplayed,.unplayed,.unplayed,.unplayed,.unplayed,.unplayed,.unplayed,.unplayed,.unplayed],
                               topics:[LiveTopic(id: UUID(), topic:"Flowers", isLive: true ,color:.blue)], gimmees: 1)
  static func makeMock() -> GameState {
    //blast over these globals when mocking
    challenges = [onechallenge,onechallenge,onechallenge,onechallenge,onechallenge,onechallenge,onechallenge,onechallenge,onechallenge]
    return GameState.mock
  }
}
struct LiveTopic:Identifiable,Codable  {
  let id:UUID
  var topic: String
  var isLive:Bool
  var color:Color
  
  static let default_topics = {
    [
      LiveTopic(id:UUID(), topic: "topic 1", isLive: true, color: .red),
      LiveTopic(id:UUID(), topic: "topic 2", isLive: true, color: .yellow),
      LiveTopic(id:UUID(), topic: "topic 3", isLive: true, color: .blue)
    ]
  }
}

@Observable class AppSettings : Codable {
  
 static func saveAppSettings(_ settings: AppSettings, to fileName: String) {
      let encoder = JSONEncoder()
      do {
          let data = try encoder.encode(settings)
          if let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
              let fileURL = directory.appendingPathComponent(fileName)
              try data.write(to: fileURL)
              print("AppSettings saved to \(fileURL.path)")
          }
      } catch {
          print("Failed to save app settings: \(error.localizedDescription)")
      }
  }
  static func loadAppSettings(from fileName: String) -> AppSettings? {
      if let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
          let fileURL = directory.appendingPathComponent(fileName)
          let decoder = JSONDecoder()
          do {
              let data = try Data(contentsOf: fileURL)
              let settings = try decoder.decode(AppSettings.self, from: data)
              print("AppSettings loaded from \(fileURL.path)")
              return settings
          } catch {
              print("Failed to load app settings: \(error.localizedDescription)")
          }
      }
      return nil
  }

  internal init(elementWidth: CGFloat = 100, shaky: Bool = false, shuffleUp: Bool = true, rows: Double = 3, fontsize: Double = 24, padding: Double=5, border: Double=2,topics:[LiveTopic]=[]) {
    self.elementWidth = elementWidth
    self.shaky = shaky
    self.shuffleUp = shuffleUp
    self.rows = rows
    self.fontsize = fontsize
    self.padding = padding
    self.border = border
    self.topics = topics
  }
  static var mock = AppSettings(elementWidth: 100, shaky: false, shuffleUp: false, rows: 1, fontsize: 24, padding: 5, border: 2)
  
  var elementWidth: CGFloat
  var shaky: Bool
  var shuffleUp: Bool
  var rows: Double
  var fontsize: Double
  var padding: Double
  var border: Double
  var topics:[LiveTopic]
  
  // these are needed when @Observable needs to be codable
  enum CodingKeys: String, CodingKey {
    case _border = "border"
    case _padding = "padding"
    case _fontsize = "fontsize"
    case _rows = "rows"
    case _elementWidth = "elementWidth"
    case _shaky = "shaky"
    case _shuffleUp = "shuffleUp"
    case _topics = "topics"
    
  }
  
}



///////////// code
///
/////http://brunowernimont.me/howtos/make-swiftui-color-codable
#if os(iOS)
import UIKit
#elseif os(watchOS)
import WatchKit
#elseif os(macOS)
import AppKit
#endif

fileprivate extension Color {
#if os(macOS)
  typealias SystemColor = NSColor
#else
  typealias SystemColor = UIColor
#endif
  
  var colorComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
    var r: CGFloat = 0
    var g: CGFloat = 0
    var b: CGFloat = 0
    var a: CGFloat = 0
    
#if os(macOS)
    SystemColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)
    // Note that non RGB color will raise an exception, that I don't now how to catch because it is an Objc exception.
#else
    guard SystemColor(self).getRed(&r, green: &g, blue: &b, alpha: &a) else {
      // Pay attention that the color should be convertible into RGB format
      // Colors using hue, saturation and brightness won't work
      return nil
    }
#endif
    
    return (r, g, b, a)
  }
}

extension Color: Codable {
  enum CodingKeys: String, CodingKey {
    case red, green, blue
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let r = try container.decode(Double.self, forKey: .red)
    let g = try container.decode(Double.self, forKey: .green)
    let b = try container.decode(Double.self, forKey: .blue)
    
    self.init(red: r, green: g, blue: b)
  }
  
  public func encode(to encoder: Encoder) throws {
    guard let colorComponents = self.colorComponents else {
      return
    }
    
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(colorComponents.red, forKey: .red)
    try container.encode(colorComponents.green, forKey: .green)
    try container.encode(colorComponents.blue, forKey: .blue)
  }
}







////// Views
///


struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GridView(settings: AppSettings.mock, tappedNum: .constant(IdentifiableInteger(val: 1)), longPressedNum: .constant(IdentifiableInteger(val: 2)))
    }
}
 

func colorFor(topic:String) -> Color {
  guard let lt = gameState.topics.first(where:{$0.topic == topic}) else {return Color.black}
  return  lt.color
}


func cellOpacity(_ number:Int) -> Double {
  number<0||number>gameState.outcomes.count-1 ? 0.0:
    (gameState.outcomes[number] == .unplayed ? 1.0:
      (gameState.outcomes[number] == .playedCorrectly ? 0.8:0.8
      ))
}
func cellBorderColor(_ number:Int) -> Color {
  number<0||number>gameState.outcomes.count-1 ? .gray:
                (gameState.outcomes[number] == .unplayed ? .gray:
                  (gameState.outcomes[number] == .playedCorrectly ? .green:.red
                  ))
}
func cellBorderWidth(_ number:Int) -> Double {
  number<0||number>gameState.outcomes.count-1 ? 0.0:
  (gameState.outcomes[number] == .unplayed ? 1.0:
    (gameState.outcomes[number] == .playedCorrectly ? 5:5
    ))
}
func cellColorFromTopic(_ number:Int)->Color {
 challenges.count>0 ? colorFor(topic:challenges[number].topic) : distinctiveColors[number %  distinctiveColors.count]
}


/* Add your existing code here */

struct MatrixItemView: View {
    init(text: String, number: Int, settings: AppSettings, onTap: ((Int) -> Void)? = nil, onLongPress: ((Int) -> Void)? = nil, shownum: Bool = false) {
        self.text = text
        self.settings = settings
        self.onTap = onTap
        self.onLongPress = onLongPress
        self.shownum = shownum
        self.number = number
    }
    
    let text: String
    let number: Int
    let settings: AppSettings
    let shownum: Bool

    var onTap: ((Int) -> Void)? // Closure to be executed on tap
    var onLongPress: ((Int) -> Void)?
    
    var body: some View {
        Text(text)
            .font(.system(size: settings.fontsize))
            .lineLimit(8)
            .minimumScaleFactor(0.2)
            .frame(width: settings.elementWidth,
                   height: settings.elementWidth, // square for now
                   alignment: .center)
            .padding(.all, settings.padding)
            .background( cellColorFromTopic(number)) // Change color based on global state or individual state
            .foregroundColor(.black)
            .onTapGesture {
              withAnimation {
                
                gameState.selected = number // gameState is class
                gameState.showing = .qanda
                onTap?(number) // Execute the closure if it exists
              }
            }
            .onLongPressGesture {
                onLongPress?(number)
            }
            .opacity(cellOpacity(number))
            .border(cellBorderColor(number), width: cellBorderWidth(number))
          //  .rotationEffect(settings.shaky ? .degrees(Double(number % 23)) : .degrees(0))
//            .animation(.default, value: globalFlipState)
//            .animation(.default, value: isFlipped) // Add animation
    }
}

struct GridView: View {
    let settings: AppSettings
    @Binding var tappedNum: IdentifiableInteger?
    @Binding var longPressedNum: IdentifiableInteger?

    
  init(settings: AppSettings, tappedNum: Binding<IdentifiableInteger?>, longPressedNum: Binding<IdentifiableInteger?>) {
        self.settings = settings
        self._tappedNum = tappedNum
        self._longPressedNum = longPressedNum
  }
    
    var body: some View {
        ScrollView([.vertical, .horizontal], showsIndicators: true) {
            let columns = Array(repeating: GridItem(.flexible(), spacing: settings.padding), count: Int(settings.rows))
            LazyVGrid(columns: columns, spacing: settings.border) {
                ForEach(0..<Int(settings.rows) * Int(settings.rows), id: \.self) { number in
                    MatrixItemView(text: challenges[number].question,
                                   number: number,
                                   settings: settings,
                                   onTap: { renumber in
                        tappedNum = IdentifiableInteger(val: renumber)
                    },
                                   onLongPress: { n in
                        longPressedNum = IdentifiableInteger(val: n)
                    })
                }
            }
        } // scrollview
    }
}


#if os(macOS)
@main
struct macdemoApp: App {
    let settings = AppSettings(elementWidth: 100.0, shaky: false, shuffleUp: true, rows: 3, fontsize: 24, padding: 5, border: 2)
    var body: some Scene {
        WindowGroup {
            OuterApp(settings: settings)
        }
    }
}

struct OuterApp: View {
    @State var tappedNum: IdentifiableInteger? = nil
    @State var longPressedNum: IdentifiableInteger? = nil

    let settings: AppSettings

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    // Flip all cells to Color.gray
                    withAnimation {
                        globalFlipState = true
                    }
                }) {
                    Text("Flip All to Gray")
                }
                .padding()

                Button(action: {
                    // Flip all cells back
                    withAnimation {
                        globalFlipState = false
                    }
                }) {
                    Text("Flip All Back")
                }
                .padding()
            }

            GridView(settings: settings, tappedNum: $tappedNum, longPressedNum: $longPressedNum, 
                     flipStates: .constant([true,false]),globalFlipState: $globalFlipState)
        }
    }
}
#endif

