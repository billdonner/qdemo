//
//  Colors.swift
//  qdemo
//
//  Created by bill donner on 5/23/24.
//

import SwiftUI

let distinctiveColors: [Color] = [
  Color(red: 0.98, green: 0.89, blue: 0.85),
  Color(red: 0.85, green: 0.95, blue: 0.98),
  Color(red: 0.98, green: 0.87, blue: 0.90),
  Color(red: 0.84, green: 0.98, blue: 0.85),
  Color(red: 0.86, green: 0.91, blue: 0.98),
  Color(red: 0.98, green: 0.85, blue: 0.87),
  Color(red: 0.96, green: 0.85, blue: 0.98),
  Color(red: 0.98, green: 0.93, blue: 0.90),
  Color(red: 0.90, green: 0.87, blue: 0.98),
  Color(red: 0.98, green: 0.92, blue: 0.85),
  Color(red: 0.88, green: 0.85, blue: 0.98),
  Color(red: 0.98, green: 0.85, blue: 0.89),
  Color(red: 0.85, green: 0.98, blue: 0.96),
  Color(red: 0.93, green: 0.85, blue: 0.98),
  Color(red: 0.90, green: 0.98, blue: 0.87),
  Color(red: 0.87, green: 0.90, blue: 0.98),
  Color(red: 0.98, green: 0.90, blue: 0.83),
  Color(red: 0.83, green: 0.96, blue: 0.98),
  Color(red: 0.92, green: 0.88, blue: 0.98),
  Color(red: 0.98, green: 0.95, blue: 0.89),
  Color(red: 0.89, green: 0.98, blue: 0.93),
  Color(red: 0.85, green: 0.89, blue: 0.98),
  Color(red: 0.98, green: 0.91, blue: 0.87),
  Color(red: 0.91, green: 0.98, blue: 0.85),
  Color(red: 0.85, green: 0.87, blue: 0.98),
]
let colors2: [Color] = [
    Color(red: 0.98, green: 0.75, blue: 0.75),
    Color(red: 0.75, green: 0.85, blue: 0.98),
    Color(red: 0.98, green: 0.80, blue: 0.85),
    Color(red: 0.70, green: 0.98, blue: 0.75),
    Color(red: 0.75, green: 0.80, blue: 0.98),
    Color(red: 0.98, green: 0.70, blue: 0.75),
    Color(red: 0.85, green: 0.70, blue: 0.98),
    Color(red: 0.98, green: 0.90, blue: 0.75),
    Color(red: 0.80, green: 0.75, blue: 0.98),
    Color(red: 0.98, green: 0.80, blue: 0.70),
    Color(red: 0.75, green: 0.70, blue: 0.98),
    Color(red: 0.98, green: 0.70, blue: 0.75),
    Color(red: 0.70, green: 0.98, blue: 0.85),
    Color(red: 0.85, green: 0.70, blue: 0.98),
    Color(red: 0.75, green: 0.98, blue: 0.70),
    Color(red: 0.72, green: 0.75, blue: 0.98),
    Color(red: 0.98, green: 0.85, blue: 0.70),
    Color(red: 0.70, green: 0.85, blue: 0.98),
    Color(red: 0.85, green: 0.75, blue: 0.98),
    Color(red: 0.98, green: 0.95, blue: 0.75),
    Color(red: 0.75, green: 0.98, blue: 0.85),
    Color(red: 0.70, green: 0.75, blue: 0.98),
    Color(red: 0.98, green: 0.85, blue: 0.75),
    Color(red: 0.85, green: 0.98, blue: 0.70),
    Color(red: 0.70, green: 0.70, blue: 0.98),
]

let colors1: [Color] = [
    Color(red: 1.00, green: 0.80, blue: 0.80),  // Light Pink
    Color(red: 0.53, green: 0.81, blue: 0.98),  // Sky Blue
    Color(red: 1.00, green: 0.88, blue: 0.77),  // Peach
    Color(red: 0.53, green: 0.98, blue: 0.64),  // Mint Green
    Color(red: 0.80, green: 0.80, blue: 0.98),  // Soft Lavender
    Color(red: 1.00, green: 0.64, blue: 0.64),  // Salmon Pink
    Color(red: 0.73, green: 0.53, blue: 0.98),  // Light Purple
    Color(red: 1.00, green: 0.93, blue: 0.62),  // Light Yellow
    Color(red: 0.70, green: 0.98, blue: 0.93),  // Light Cyan
    Color(red: 0.73, green: 0.98, blue: 0.53),  // Lime Green
    Color(red: 1.00, green: 0.80, blue: 0.53),  // Light Orange
    Color(red: 0.98, green: 0.73, blue: 0.94),  // Light Magenta
    Color(red: 0.53, green: 0.98, blue: 0.88),  // Aquamarine
    Color(red: 0.98, green: 0.72, blue: 0.53),  // Coral
    Color(red: 0.80, green: 0.53, blue: 0.98),  // Amethyst
    Color(red: 0.98, green: 0.98, blue: 0.53),  // Light Gold
    Color(red: 0.53, green: 0.98, blue: 0.72),  // Sea Green
    Color(red: 0.98, green: 0.53, blue: 0.53),  // Light Red
    Color(red: 0.53, green: 0.53, blue: 0.98),  // Ultramarine
    Color(red: 0.72, green: 0.72, blue: 0.98),  // Periwinkle
]

struct ColorsScrollView: View {
    let colors: [Color]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(colors.indices, id: \.self) { index in
                    colors[index]
                        .frame(width: 100, height: 100)
                        .cornerRadius(15)
                        .overlay(
                            Text("\(index + 1)")
                                .font(.headline)
                                .foregroundColor(.black)
                        )
                }
            }
            .padding()
        }
    }
}
#Preview {
  ColorsScrollView(colors:colors1)
}
#Preview {
  ColorsScrollView(colors:colors2)
}
#Preview {
  ColorsScrollView(colors:distinctiveColors)
}
