//
//  WordListView.swift
//  qdemo
//
//  Created by bill donner on 4/30/24.
//

import SwiftUI

struct LiveTopic:Identifiable {
  let id = UUID()
  var topic: String
  var isLive:Bool
  var color:Color
}

struct TextWithBackgroundStyle: View {
  let livetopic:LiveTopic
  var body: some View {
    VStack {
      Text(livetopic.topic)
    }
  // .background(livetopic.color)
  }
}
#Preview("TextWithBackgroundStyle") {
  TextWithBackgroundStyle(livetopic: LiveTopic(topic:("Topic Goes Here"),isLive:false,color:.blue))
}

let MIN_UNSELECTED_TOPICS = 0

let MIN_SELECTED_TOPICS = 2


struct TopicsSelectionView: View {
  @Binding var topics: [LiveTopic]
    @State   var showAlert = false
//  @Binding var colors: [Color]
  fileprivate func showSelectedWithTap(_ livetopic: LiveTopic) -> some View {
      return TextWithBackgroundStyle(livetopic: livetopic)
          .onTapGesture {
              let count = topics.reduce(0){$0 + ($1.isLive ? 1:0) }
              if count > MIN_SELECTED_TOPICS  { // should come from settings
                  if let index = self.topics.firstIndex(where: { $0.id == livetopic.id }) {
                      self.topics[index].isLive.toggle()
                  }
              } else {
                  showAlert = true
              }
          }
          .alert(isPresented: $showAlert) {
              Alert(title: Text("Hey"),
                    message: Text("You must select at least \(MIN_SELECTED_TOPICS) topics"),
                    dismissButton: .default(Text("OK")))
          }
  }
  fileprivate func showUnSelectedWithTap(_ livetopic: LiveTopic) -> some View {
    return TextWithBackgroundStyle(livetopic: livetopic)
      .onTapGesture {
        let count = topics.reduce(0){$0 + (!$1.isLive ? 1:0) }
        if count > MIN_UNSELECTED_TOPICS  {// should come from settings
          if let index = self.topics.firstIndex(where: { $0.id == livetopic.id }) {
            self.topics[index].isLive.toggle()
          }
        }
      }
  }
  var body: some View {
    HStack(spacing: 20) {
      VStack {
        Text("Selected")
          .font(.headline)
        List {
          ForEach(topics) { livetopic in
            if livetopic.isLive {
            ZStack {
              Color(livetopic.color)
                showSelectedWithTap(livetopic)
              }
            
            }
          }
        }
      }
      
      VStack {
        Text("Unselected")
          .font(.headline)
        List {
          ForEach(topics) { livetopic in
            if !livetopic.isLive {
            ZStack {
              Color(livetopic.color)
                showUnSelectedWithTap(livetopic)
              }
            }
          }
        }
        .padding()
      }
    }
  }
}

struct TopicSelectorScreen: View {
    @State private var internalColors: [Color]
    @State private var internalTopics: [LiveTopic]
    @Binding var isSelectedArray: [Bool]
    @Environment(\.presentationMode) var presentationMode
  let f:()->()
    
    init( isSelectedArray: Binding<[Bool]>, f: @escaping ()->()) {
      self._internalTopics = State(initialValue: liveTopics)
        self._isSelectedArray = isSelectedArray
      self.f = f
      self._internalColors = State(initialValue: pastelColors.map{$0} )
    }
    
  var body: some View {
    NavigationView {
      TopicsSelectionView(topics: $internalTopics)
        .onDisappear {
        }
        .navigationBarTitle("Choose Topics", displayMode: .inline)
        .navigationBarItems(trailing: Button(action : {
          isSelectedArray = internalTopics.map{$0.isLive}
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
/*
 #Preview ("TopicSelectorScreen"){
 liveTopics = [
 LiveTopic(topic: "topic 1", isLive: true, color: .red),
 LiveTopic(topic: "topic 2", isLive: true, color: .yellow),
 LiveTopic(topic: "topic 3", isLive: true, color: .blue)
 ]
 let _ =  TopicSelectorScreen (
 isSelectedArray: .constant([false,false,false])) {
 print("final callback")
 }
 }
 */
