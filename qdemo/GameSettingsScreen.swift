//
//  GameSettingsScreen.swift
//  qdemo
//
//  Created by bill donner on 6/12/24.
//

import SwiftUI
struct TopicsView: View {
    @State private var currentTopics: [String]
    @State private var remainingTopics: [String]
    @State private var changedIndices: Set<Int> = []

    init(topics: [String], allTopics: [String]) {
        _currentTopics = State(initialValue: topics)
        _remainingTopics = State(initialValue: allTopics.filter { !topics.contains($0) })
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("You can change each topic once")
                .font(.footnote)
                .padding()

            List(currentTopics.indices, id: \.self) { index in
                Text("\(index + 1). \(currentTopics[index])")
                    .onTapGesture {
                        if !changedIndices.contains(index) {
                            changeTopic(at: index)
                        }
                    }
                    .foregroundColor(changedIndices.contains(index) ? .gray : .primary)
                    .disabled(changedIndices.contains(index)) // Indicate non-tappable state
            }
        }
        .padding()
    }
    
    private func changeTopic(at index: Int) {
        guard !remainingTopics.isEmpty else {
            print("No more unused topics available.")
            return
        }

        if let newTopic = remainingTopics.randomElement(),
           let newTopicIndex = remainingTopics.firstIndex(of: newTopic) {
            currentTopics[index] = newTopic
            remainingTopics.remove(at: newTopicIndex)
            changedIndices.insert(index)
        }
    }
}

func chooseTopics(from topics: [String], count N: Int) -> [String] {
    guard N > 0 else {
        return []
    }

    if N >= topics.count {
        return topics
    }

    var chosenTopics: Set<String> = []
    while chosenTopics.count < N {
        if let topic = topics.randomElement() {
            chosenTopics.insert(topic)
        }
    }

    return Array(chosenTopics)
}
struct GameSettingsScreen: View {
  @Binding var boardSize: Int
  @Binding var startInCorners: Bool
  @Binding var faceUpCards: Bool
  @Binding var doubleDiag: Bool
  @Binding var colorPalette: Int
  @Binding var difficultyLevel: Int
  @Binding var ourTopics: [String]
  
  @Environment(\.presentationMode) var presentationMode
  
  var colorPaletteBackground: LinearGradient {
    switch colorPalette {
    case 1:
      return LinearGradient(gradient: Gradient(colors: [Color.green, Color.yellow]), startPoint: .topLeading, endPoint: .bottomTrailing)
      
    case 2:
      
      return LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing)
    case 3:
      return LinearGradient(gradient: Gradient(colors: [Color.brown, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing)
      
    case 4:
      return LinearGradient(gradient: Gradient(colors: [Color.blue, Color.cyan]), startPoint: .topLeading, endPoint: .bottomTrailing)
    default:
      return LinearGradient(gradient: Gradient(colors: [Color.gray, Color.black]), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
  }
  
  var body: some View {
    let size = boardSize - 3
    NavigationView {
      Form {
        Section(header: Text("Board Size")) {
          Picker("Board Size", selection: $boardSize) {
            Text("3x3").tag(3)
            Text("4x4").tag(4)
            Text("5x5").tag(5)
            Text("6x6").tag(6)
          }
          .pickerStyle(SegmentedPickerStyle())
        }
        
        Section(header: Text("Difficulty Level")) {
          Picker("Difficulty Level", selection: $difficultyLevel) {
            Text("Easy").tag(1)
            Text("Normal").tag(2)
            Text("Hard").tag(3)
          }
          .pickerStyle(SegmentedPickerStyle())
          .background(Color(.systemBackground).clipShape(RoundedRectangle(cornerRadius: 10)))
        }
        Section(header: Text("Starting Position")) {
          HStack {
            Text("Anywhere")
            Spacer()
            Toggle("", isOn: $startInCorners)
              .labelsHidden()
            Spacer()
            Text("Corners")
          }
          .frame(maxWidth: .infinity)
        }
        
        Section(header: Text("Cards Face")) {
          HStack {
            Text("Face Up")
            Spacer()
            Toggle("", isOn: $faceUpCards)
              .labelsHidden()
            Spacer()
            Text("Face Down")
          }
          .frame(maxWidth: .infinity)
        }
        Section(header: Text("Double Diag")) {
          HStack {
            Text("One Diag")
            Spacer()
            Toggle("", isOn: $doubleDiag)
              .labelsHidden()
            Spacer()
            Text("Both Diags")
          }
          .frame(maxWidth: .infinity)
        }
        
        Section(header: Text("Color Palette")) {
          Picker("Color Palette", selection: $colorPalette) {
            Text("Spring").tag(1)
            Text("Summer").tag(2)
            Text("Autumn").tag(3)
            Text("Winter").tag(4)
          }
          .pickerStyle(SegmentedPickerStyle())
          .background(colorPaletteBackground.clipShape(RoundedRectangle(cornerRadius: 10)))
        }
        Section(header: Text("Choose Up To \(boardSize) Topics")) {
        }
        Section(header: Text("We Choose \(size) Topics")) {
        
//          let selectedTopics = switch boardSize {
//          case 3:    chooseTopics(from: ourTopics, count:3)
//          case 4:    chooseTopics(from: ourTopics, count:4)
//          case 5:    chooseTopics(from: ourTopics, count:5)
//          case 6:    chooseTopics(from: ourTopics, count:6)
//          default:
//            chooseTopics(from: ourTopics, count:3)
//            
//          }
          
          let selectedTopics =
          chooseTopics(from: ourTopics, count:3)
          TopicsView(topics: selectedTopics, allTopics: ourTopics)
        }
        
      }
      .navigationBarTitle("Settings", displayMode: .inline)
      .navigationBarItems(
        leading: Button("Cancel") {
          self.presentationMode.wrappedValue.dismiss()
        },
        trailing: Button("Done") {
          self.presentationMode.wrappedValue.dismiss()
        }
      )
    }
  }
}
#Preview {
  @Previewable @State var boardSize: Int = 3
  @Previewable @State var startInCorners: Bool = false
  @Previewable @State var faceUpCards: Bool = false
  @Previewable @State var colorPalette: Int = 1
  @Previewable @State var difficultyLevel: Int = 1
  @Previewable @State var doubleDiag: Bool = false
  @Previewable @State var ourTopics = [
    "Movies",
    "Brit Royals",
    "Baseball",
    "Music",
    "Technology",
    "Science",
    "Literature",
    "Travel",
    "Art",
    "History",
    "Fashion",
    "Food & Drink",
    "Health & Fitness",
    "Politics",
    "Education",
    "Environment",
    "Finance",
    "Automobiles",
    "Gaming",
    "DIY & Crafts",
    "Gardening",
    "Pets",
    "Photography",
    "Sports",
    "Television"
]
  GameSettingsScreen(
    boardSize: $boardSize,
    startInCorners: $startInCorners,
    faceUpCards: $faceUpCards,
    doubleDiag: $doubleDiag,
    colorPalette: $colorPalette,
    difficultyLevel: $difficultyLevel,
    ourTopics: $ourTopics)
}


