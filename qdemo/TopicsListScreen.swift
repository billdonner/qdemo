//
//  WordListView.swift
//  qdemo
//
//  Created by bill donner on 4/30/24.
//

import SwiftUI



struct TextWithBackgroundStyle: View {
  let livetopic:LiveTopic
  var body: some View {
    VStack {
      Text(livetopic.topic).foregroundStyle(Color.black)
    }
    
 .background(livetopic.color)
  }
}
#Preview("TextWithBackgroundStyle") {
  TextWithBackgroundStyle(livetopic: LiveTopic(id: UUID(), topic:("Topic Goes Here"),isLive:false,color:.blue))
  
}
#Preview("TextWithBackgroundStyleDark") {
  TextWithBackgroundStyle(livetopic: LiveTopic(id: UUID(), topic:("Topic Goes Here"),isLive:false,color:.blue))
    .preferredColorScheme(.dark)
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
             // Color(livetopic.color)
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
              //Color(livetopic.color)
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
 let settings:AppSettings
  @Binding var isSelectedArray: [Bool]
  let f:()->()
  
    @State private var internalColors: [Color]
    @State private var internalTopics: [LiveTopic]
    @Environment(\.presentationMode) var presentationMode
    
  init(settings :AppSettings,  isSelectedArray: Binding<[Bool]>, f: @escaping ()->()) {
      self._internalTopics = State(initialValue: gameState.topics)
      self._isSelectedArray = isSelectedArray
      self.f = f
    self._internalColors = State(initialValue:distinctiveColors.map{$0} )
   self.settings = settings
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
         
      let _ =  try? prepareNewGame(aiPlayData!,  settings: settings,
                                   first: false )
          settings.shaky.toggle()
          presentationMode.wrappedValue.dismiss()
        }) {
          Text("Save")
        })
        .navigationBarItems(leading: Button(action : {
          settings.shaky.toggle()
          presentationMode.wrappedValue.dismiss()
        }) {
          Text("Cancel")
        })
    }
  }
}
