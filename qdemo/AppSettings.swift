//
//  AppSettings.swift
//  qdemo
//
//  Created by bill donner on 5/18/24.
//

import SwiftUI

/*
 init(elementWidth: CGFloat = 100,
                shaky: Bool = false,
                shuffleUp: Bool = false,
                lazyVGrid: Bool = true,
                rows: Double = 1,
                fontsize: Double = 24,
                padding: Double = 5,
                border: Double = 2) {
    self.elementWidth = elementWidth
    self.elementHeight = elementWidth //  - make these square elementHeight
    self.shaky = shaky
    self.shuffleUp = shuffleUp
    self.lazyVGrid = lazyVGrid
    self.rows = rows
    self.columns = rows  // columns - make it square
    self.fontsize = fontsize
    self.padding = padding
    self.border = border
  }
 */
@Observable class AppSettings : Codable {
  internal init(elementWidth: CGFloat, shaky: Bool, shuffleUp: Bool, rows: Double, fontsize: Double, padding: Double, border: Double) {
    self.elementWidth = elementWidth 
    self.shaky = shaky
    self.shuffleUp = shuffleUp
    self.rows = rows
    self.fontsize = fontsize
    self.padding = padding
    self.border = border
  }
  
static var mock = AppSettings(elementWidth: 100, shaky: false, shuffleUp: false, rows: 1, fontsize: 24, padding: 2, border: 2)

 var elementWidth: CGFloat
  var shaky: Bool
  var shuffleUp: Bool
   var rows: Double
  var fontsize: Double
   var padding: Double
  var border: Double
  
  // these are needed when @Observable needs to be codable
  enum CodingKeys: String, CodingKey {
      case _border = "border"
    case _padding = "padding"
    case _fontsize = "fontsize"
    case _rows = "rows"
    case _elementWidth = "elementWidth"
    case _shaky = "shaky"
    case _shuffleUp = "shuffleUp"
    
  }
  
}