//
//  WordSelectionManager.swift
//  qdemo
//
//  Created by bill donner on 4/30/24.
//

import Foundation
@Observable class WordSelectionManager {
     var selectedWords: Set<String>
     var unselectedWords: Set<String>
    
    init(selectedWords: Set<String>, unselectedWords: Set<String>) {
        self.selectedWords = selectedWords
        self.unselectedWords = unselectedWords
    }
    
    func toggleWordSelection(_ word: String) {
        if selectedWords.contains(word) {
            selectedWords.remove(word)
            unselectedWords.insert(word)
        } else {
            unselectedWords.remove(word)
            selectedWords.insert(word)
        }
    }
    
    func removeWordFromSelected(at offsets: IndexSet) {
        offsets.forEach { index in
            let word = Array(selectedWords)[index]
            selectedWords.remove(word)
            unselectedWords.insert(word)
        }
    }
    
    func removeWordFromUnselected(at offsets: IndexSet) {
        offsets.forEach { index in
            let word = Array(unselectedWords)[index]
            unselectedWords.remove(word)
            selectedWords.insert(word)
        }
    }
}
