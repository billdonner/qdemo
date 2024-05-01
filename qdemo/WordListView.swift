//
//  WordListView.swift
//  qdemo
//
//  Created by bill donner on 4/30/24.
//

import SwiftUI


struct WordListViewTap: View {
   var manager: WordSelectionManager
  var body: some View {
    VStack{
      
      Text("Choose Your Topics").font(.title)
      HStack {
        VStack {
          Text(header1)
            .font(.headline)
            .padding()
          
          List {
            ForEach(Array(manager.selectedWords.sorted()), id: \.self) { word in
              ZStack{
              colorFor(topic:word)
                Text(word)
                  .onTapGesture {
                    manager.toggleWordSelection(word)
                  }
              }
            }
            .onDelete(perform: manager.removeWordFromSelected)
          }
        }
        
        Divider()
        
        VStack {
          Text(header2)
            .font(.headline)
            .padding()
          
          List {
            ForEach(Array(manager.unselectedWords.sorted()), id: \.self) { word in
              ZStack {
                colorFor(topic:word)
                Text(word)
                  .onTapGesture {
                    manager.toggleWordSelection(word)
                  }
              }
            }
            .onDelete(perform: manager.removeWordFromUnselected)
          }
        }
      }
      Spacer()
      Divider()
    }
  }
}

struct WordListViewTap_Previews: PreviewProvider {
    static var previews: some View {
        WordListViewTap(manager: WordSelectionManager(selectedWords: Set(set1), unselectedWords: Set(set2)))
    }
}
/*
struct WordListViewTap2: View {
    var manager: WordSelectionManager

    var body: some View {
        VStack {
            Text("Choose Your Topics").font(.title)
            HStack {
                animatedWordList(header: "Playing", words: manager.selectedWords)
                Divider()
                animatedWordList(header: "Not Playing", words: manager.unselectedWords)
            }
            Spacer()
            Divider()
        }
        .onAppear {
            animateWordsInsertion()
        }
    }

    private func animatedWordList(header: String, words: Set<String>) -> some View {
        VStack {
            Text(header)
                .font(.headline)
                .padding()

            List {
                ForEach(Array(words).sorted(), id: \.self) { word in
                    ZStack {
                        colorFor(topic: word)
                        Text(word)
                            .onTapGesture {
                                withAnimation {
                                    manager.toggleWordSelection(word)
                                }
                            }
                    }
                }
//                .onDelete { offsets in
//                    withAnimation {
//                        manager.removeWords(at: offsets, from: words)
//                    }
//                }
            }
        }
    }

    private func animateWordsInsertion() {
        var delay: Double = 0
        let totalWords = ["Movies", "Sports", "Art", "Baseball", "Presidents", "Grifters", "Food", "Drink", "Basketball"]

        for word in totalWords {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation {
                    if self.manager.selectedWords.contains(word) {
                        self.manager.selectedWords.insert(word)
                    } else {
                        self.manager.unselectedWords.insert(word)
                    }
                }
            }
            delay += 1.2
        }
    }
    
    private func colorFor(topic: String) -> Color {
        // Dummy color function, replace with actual logic
        return .blue
    }
}

struct WordListViewTap2_Previews: PreviewProvider {
    static var previews: some View {
        let set1 = ["Movies", "Sports", "Art", "Baseball", "Presidents", "Grifters"].sorted()
        let set2 = ["Food", "Drink", "Basketball"].sorted()
        return WordListViewTap(manager: WordSelectionManager(selectedWords: Set(set1), unselectedWords: Set(set2)))
    }
}

struct WordListViewDD: View {
 var manager: WordSelectionManager
 
    var body: some View {
        HStack {
            VStack {
                Text(header1)
                    .font(.headline)
                List {
                    ForEach(Array(manager.selectedWords), id: \.self) { word in
                        Text(word)
                            .padding()
                            .onDrag {
                                return NSItemProvider(object: NSString(string: word))
                            }
                            .onDrop(of: [.text], isTargeted: nil) { providers, _ in
                                handleDrop(word: word, providers: providers, currentlySelected: true)
                            }
                    }
                }
            }
            Divider()
            VStack {
                Text(header2)
                    .font(.headline)
                List {
                    ForEach(Array(manager.unselectedWords), id: \.self) { word in
                        Text(word)
                            .padding()
                            .onDrag {
                                return NSItemProvider(object: NSString(string: word))
                            }
                            .onDrop(of: [.text], isTargeted: nil) { providers, _ in
                                handleDrop(word: word, providers: providers, currentlySelected: false)
                            }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func handleDrop(word: String, providers: [NSItemProvider], currentlySelected: Bool) -> Bool {
        let provider = providers.first(where: { $0.canLoadObject(ofClass: NSString.self) })
        _ = provider?.loadObject(ofClass: NSString.self) { (draggedWord, error) in
            DispatchQueue.main.async {
              if let draggedWord = draggedWord as! String? {
                    if currentlySelected {
                        manager.selectedWords.remove(draggedWord)
                        manager.unselectedWords.insert(draggedWord)
                    } else {
                        manager.unselectedWords.remove(draggedWord)
                        manager.selectedWords.insert(draggedWord)
                    }
                }
            }
        }
        // Since we know our drag items are valid, return true
        return true
    }
}

struct WordListViewDD_Previews: PreviewProvider {
    static var previews: some View {
        WordListViewDD(manager: WordSelectionManager(selectedWords: Set(set1), unselectedWords: Set(set2)))
    }
}

struct WordListViewEE: View {
      var manager: WordSelectionManager

    var body: some View {
        HStack {
            VStack {
                Text("Selected Words")
                    .font(.headline)
                List {
                    ForEach(Array(manager.selectedWords), id: \.self) { word in
                      let x = 0.2//Double(manager.selectedWords.firstIndex(of: word) ?? 0) * 0.2
                        Text(word)
                            .padding()
                            .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity), removal: .opacity))
                            .animation(Animation.spring().delay(x), value: manager.selectedWords)
                            .onDrag {
                                return NSItemProvider(object: NSString(string: word))
                            }
                            .onDrop(of: [.text], isTargeted: nil) { providers, _ in
                                handleDrop(word: word, providers: providers, currentlySelected: true)
                            }
                    }
                }
            }
            Divider()
            VStack {
                Text("Unselected Words")
                    .font(.headline)
                List {
                    ForEach(Array(manager.unselectedWords), id: \.self) { word in
                      let x = 0.2//Double(manager.unselectedWords.firstIndex(of: word) ?? 0) * 0.2
                        Text(word)
                            .padding()
                            .transition(.asymmetric(insertion: .move(edge: .leading).combined(with: .opacity), removal: .opacity))
                            .animation(Animation.spring().delay(x), value: manager.unselectedWords)
                            .onDrag {
                                return NSItemProvider(object: NSString(string: word))
                            }
                            .onDrop(of: [.text], isTargeted: nil) { providers, _ in
                                handleDrop(word: word, providers: providers, currentlySelected: false)
                            }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func handleDrop(word: String, providers: [NSItemProvider], currentlySelected: Bool) -> Bool {
        let provider = providers.first(where: { $0.canLoadObject(ofClass: NSString.self) })
        _ = provider?.loadObject(ofClass: NSString.self) { (draggedWord, error) in
            DispatchQueue.main.async {
              if let draggedWord = draggedWord as! String? {
                    if currentlySelected {
                        self.manager.selectedWords.remove(draggedWord)
                        self.manager.unselectedWords.insert(draggedWord)
                    } else {
                        self.manager.unselectedWords.remove(draggedWord)
                        self.manager.selectedWords.insert(draggedWord)
                    }
                }
            }
        }
        // Since we know our drag items are valid, return true
        return true
    }
}

struct WordListViewEE_Previews: PreviewProvider {
    static var previews: some View {
        WordListView(manager: WordSelectionManager(selectedWords: Set(["Example", "Test"]), unselectedWords: Set(["Word", "Another", "Sample"])))
    }
}
 
 struct WordListView: View {
   var manager: WordSelectionManager

     var body: some View {
         List {
             Section(header: Text(header1)) {
                 ForEach(Array(manager.selectedWords), id: \.self) { word in
                     Text(word)
                         .onTapGesture {
                             manager.toggleWordSelection(word)
                         }
                 }
                 .onDelete(perform: manager.removeWordFromSelected)
             }

             Section(header: Text(header2)) {
                 ForEach(Array(manager.unselectedWords), id: \.self) { word in
                     Text(word)
                         .onTapGesture {
                             manager.toggleWordSelection(word)
                         }
                 }
                 .onDelete(perform: manager.removeWordFromUnselected)
             }
         }
     }
 }

 struct WordListView_Previews: PreviewProvider {
     static var previews: some View {
         WordListView(manager: WordSelectionManager(selectedWords: Set(set1), unselectedWords: Set(set2)))
     }
 }


 struct WordListViewTwoColumns: View {
    var manager: WordSelectionManager

     var body: some View {
         HStack {
             VStack {
                 Text(header1)
                     .font(.headline)

                 List {
                     ForEach(Array(manager.selectedWords), id: \.self) { word in
                         Text(word)
                             .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                 Button {
                                     manager.toggleWordSelection(word)
                                 } label: {
                                     Image(systemName: "arrow.right.square")
                                 }
                                 .tint(.blue)
                             }
                     }
                     .onDelete(perform: manager.removeWordFromSelected)
                 }
             }

             Divider()

             VStack {
                 Text(header2)
                     .font(.headline)

                 List {
                     ForEach(Array(manager.unselectedWords), id: \.self) { word in
                         Text(word)
                             .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                 Button {
                                     manager.toggleWordSelection(word)
                                 } label: {
                                     Image(systemName: "arrow.left.square")
                                 }
                                 .tint(.green)
                             }
                     }
                     .onDelete(perform: manager.removeWordFromUnselected)
                 }
             }
         }
     }
 }

 struct WordListViewTwoColumns_Previews: PreviewProvider {
     static var previews: some View {
         WordListViewTwoColumns(manager: WordSelectionManager(selectedWords: Set(set1), unselectedWords: Set(set2)))
     }
 }


*/
