//
//  AppSettings.swift
//  qdemo
//
//  Created by bill donner on 5/18/24.
//

import SwiftUI
////http://brunowernimont.me/howtos/make-swiftui-color-codable
//#if os(iOS)
//import UIKit
//#elseif os(watchOS)
//import WatchKit
//#elseif os(macOS)
//import AppKit
//#endif
//
//fileprivate extension Color {
//#if os(macOS)
//  typealias SystemColor = NSColor
//#else
//  typealias SystemColor = UIColor
//#endif
//  
//  var colorComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
//    var r: CGFloat = 0
//    var g: CGFloat = 0
//    var b: CGFloat = 0
//    var a: CGFloat = 0
//    
//#if os(macOS)
//    SystemColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)
//    // Note that non RGB color will raise an exception, that I don't now how to catch because it is an Objc exception.
//#else
//    guard SystemColor(self).getRed(&r, green: &g, blue: &b, alpha: &a) else {
//      // Pay attention that the color should be convertible into RGB format
//      // Colors using hue, saturation and brightness won't work
//      return nil
//    }
//#endif
//    
//    return (r, g, b, a)
//  }
//}
//
//extension Color: Codable {
//  enum CodingKeys: String, CodingKey {
//    case red, green, blue
//  }
//  
//  public init(from decoder: Decoder) throws {
//    let container = try decoder.container(keyedBy: CodingKeys.self)
//    let r = try container.decode(Double.self, forKey: .red)
//    let g = try container.decode(Double.self, forKey: .green)
//    let b = try container.decode(Double.self, forKey: .blue)
//    
//    self.init(red: r, green: g, blue: b)
//  }
//  
//  public func encode(to encoder: Encoder) throws {
//    guard let colorComponents = self.colorComponents else {
//      return
//    }
//    
//    var container = encoder.container(keyedBy: CodingKeys.self)
//    
//    try container.encode(colorComponents.red, forKey: .red)
//    try container.encode(colorComponents.green, forKey: .green)
//    try container.encode(colorComponents.blue, forKey: .blue)
//  }
//}

//
//struct LiveTopic:Identifiable,Codable  {
//  let id:UUID
//  var topic: String
//  var isLive:Bool
//  var color:Color
//  
//  static let default_topics = {
//    [
//      LiveTopic(id:UUID(), topic: "topic 1", isLive: true, color: .red),
//      LiveTopic(id:UUID(), topic: "topic 2", isLive: true, color: .yellow),
//      LiveTopic(id:UUID(), topic: "topic 3", isLive: true, color: .blue)
//    ]
//  }
//}
//
//@Observable class AppSettings : Codable {
//
//  internal init(elementWidth: CGFloat = 100, shaky: Bool = false, shuffleUp: Bool = true, rows: Double = 3, fontsize: Double = 24, padding: Double=5, border: Double=2,topics:[LiveTopic]=[]) {
//    self.elementWidth = elementWidth
//    self.shaky = shaky
//    self.shuffleUp = shuffleUp
//    self.rows = rows
//    self.fontsize = fontsize
//    self.padding = padding
//    self.border = border
//    self.topics = topics
//  }
//  static var mock = AppSettings(elementWidth: 100, shaky: false, shuffleUp: false, rows: 1, fontsize: 24, padding: 5, border: 2)
//  
//  var elementWidth: CGFloat
//  var shaky: Bool
//  var shuffleUp: Bool
//  var rows: Double
//  var fontsize: Double
//  var padding: Double
//  var border: Double
//  var topics:[LiveTopic]
//  
//  // these are needed when @Observable needs to be codable
//  enum CodingKeys: String, CodingKey {
//    case _border = "border"
//    case _padding = "padding"
//    case _fontsize = "fontsize"
//    case _rows = "rows"
//    case _elementWidth = "elementWidth"
//    case _shaky = "shaky"
//    case _shuffleUp = "shuffleUp"
//    case _topics = "topics"
//    
//  }
//  
//}
