//
//  WordListView.swift
//  qdemo
//
//  Created by bill donner on 4/30/24.
//

import SwiftUI

struct LiveTopic {
  var topic: String
  var isLive:Bool
}

struct Topic: Identifiable {
    let id = UUID()
    let name: String
    var isSelected: Bool
}

struct TopicsSelectionView: View {
    @Binding var topics: [Topic]

    var body: some View {
        HStack(spacing: 20) {

            VStack {
                Text("Selected Topics")
                    .font(.headline)
                List {
                    ForEach(topics) { topic in
                        if topic.isSelected {
                            Text(topic.name)
                                .onTapGesture {
                                    if let index = self.topics.firstIndex(where: { $0.id == topic.id }) {
                                        self.topics[index].isSelected.toggle()
                                    }
                                }
                        }
                    }
                }
            }
            
            VStack {
                Text("Unselected Topics")
                    .font(.headline)
                List {
                    ForEach(topics) { topic in
                        if !topic.isSelected {
                            Text(topic.name)
                                .onTapGesture {
                                    if let index = self.topics.firstIndex(where: { $0.id == topic.id }) {
                                        self.topics[index].isSelected.toggle()
                                    }
                                }
                        }
                    }
                }
            }
        }
        .padding()
    }
}

struct TopicSelectorScreen: View {
    @State private var internalTopics: [Topic]
    @Binding var isSelectedArray: [Bool]
    @Environment(\.presentationMode) var presentationMode
  let f:()->()
    
    init(topics: [String], isSelectedArray: Binding<[Bool]>, f: @escaping ()->()) {
      self._internalTopics = State(initialValue: liveTopics.map {Topic(name:$0.topic,isSelected: $0.isLive)})
        self._isSelectedArray = isSelectedArray
      self.f = f
    }
    
  var body: some View {
    NavigationView {
      TopicsSelectionView(topics: $internalTopics)
        .onDisappear {
//          isSelectedArray = internalTopics.map{$0.isSelected}
//          f()
        }
        .navigationBarTitle("Choose Topics", displayMode: .inline)
        .navigationBarItems(trailing: Button(action : {
          isSelectedArray = internalTopics.map{$0.isSelected}
          print("isSelected:",isSelectedArray)
          f()
          presentationMode.wrappedValue.dismiss()
        }) {
          Text("Save")
        })
        .navigationBarItems(leading: Button(action : {
          presentationMode.wrappedValue.dismiss()
        }) {
          Text("Cancel")
        })
    }
  }
}
#Preview ("TopicSelectorScreen"){
  TopicSelectorScreen (topics: ["Swift", "Kotlin", "Python"],
                       isSelectedArray: .constant([false,false,false])) {
    print("final callback")
  }
}


//struct TopicsChooserButtonView: View {
//  let topics :[String]
//  let f : ()->()
//    @State private var isSelectedArray = [Bool](repeating: false, count: 3)
//
//    var body: some View {
//      NavigationView {
//   //         VStack {
////                Button(action: {
////                    isSelectedArray = [Bool](repeating: false, count: 3)
////                }){
////                   Text("Reset Selections")
////                }
//                NavigationLink(
//                  destination: TopicSelectorScreen(topics:topics, isSelectedArray: $isSelectedArray,f:f)) {
//                    Text("Choose Topics")
//                }
//                .onAppear {
//                    print(isSelectedArray)
//                }
//            }
//        //}
//    }
//}
//#Preview ("TopicsChooserButtonView"){
//  TopicsChooserButtonView(topics:["Swift", "Kotlin", "Python"]){
//    print("calledback")
//  }
//    }
