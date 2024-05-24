//
//  subs.swift
//  qdemo
//
//  Created by bill donner on 5/23/24.
//

import SwiftUI

func colorFor(topic:String) -> Color {
  guard let lt = gameState.topics.first(where:{$0.topic == topic}) else {return Color.black}
  return  lt.color
}

// Convert number to words
func convertNumberToWords(_ number: Int) -> String? {
  let r =  formatter.string(from: NSNumber(value: number)) ?? ""
  return  (r as NSString).replacingOccurrences(of: "-", with: " ")
}
// Convert number to question from q20k
func convertNumberToQuestion(_ number: Int) -> String? {
  guard number >= 0 && number <= challenges.count-1 else {return nil}
  return challenges [number].question
}

func downloadFile(from url: URL ) async throws -> Data {
  let (data, _) = try await URLSession.shared.data(from: url)
  return data
}
