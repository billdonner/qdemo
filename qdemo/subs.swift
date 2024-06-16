//
//  subs.swift
//  qdemo
//
//  Created by bill donner on 5/23/24.
//

import SwiftUI


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
enum AppIconProvider {
    static func appIcon(in bundle: Bundle = .main) -> String {
       // # 1
        guard let icons = bundle.object(forInfoDictionaryKey: "CFBundleIcons") as? [String: Any],
           //   # 2
              let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
            //  # 3
              let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
           //   # 4
              let iconFileName = iconFiles.last else {
            fatalError("Could not find icons in bundle")
        }

        return iconFileName
    }
}
enum AppVersionProvider {
    static func appVersion(in bundle: Bundle = .main) -> String {
        guard let x = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ,
              let y =  bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String else {
            fatalError("CFBundlexxx missing from info dictionary")
        }
      
        return x + "." + y
    }
}
enum AppNameProvider {
    static func appName(in bundle: Bundle = .main) -> String {
        guard let x = bundle.object(forInfoDictionaryKey: "CFBundleName") as? String else {
            fatalError("CFBundleName missing from info dictionary")
        }
      
        return x
    }
}
struct AppVersionInformationView: View {
   // # 1
  let name:String
    let versionString: String
    let appIcon: String

    var body: some View {
        //# 1
        HStack(alignment: .center, spacing: 12) {
          // # 2
           VStack(alignment: .leading) {
               Text("App")
                   .bold()
               Text("\(name)")
           }
           .font(.caption)
           .foregroundColor(.primary)
            //# 3
            // App icons can only be retrieved as named `UIImage`s
            // https://stackoverflow.com/a/62064533/17421764
            if let image = UIImage(named: appIcon) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
           // # 4
            VStack(alignment: .leading) {
                Text("Version")
                    .bold()
                Text("v\(versionString)")
            }
            .font(.caption)
            .foregroundColor(.primary)
        }
        //# 5
        .fixedSize()
        //# 6
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("App version \(versionString)")
    }
}


struct AppVersionInformationView_Previews: PreviewProvider {
  static var previews: some View {
    AppVersionInformationView(
        name:AppNameProvider.appName(),
        versionString: AppVersionProvider.appVersion(),
        appIcon: AppIconProvider.appIcon()
    )
  }
}



/**
 @AppStorage("moveNumber") var moveNumber = 0
 @AppStorage("boardSize") private var boardSize = 6
 @AppStorage("startInCorners") private var startInCorners = false
 @AppStorage("faceUpCards") private var faceUpCards = false
 @AppStorage("doubleDiag") private var doubleDiag = false
 @AppStorage("colorPalette") private var colorPalette = 1
 @AppStorage("difficultyLevel") private var difficultyLevel = 1
 @AppStorage("elementWidth") var elementWidth = 100.0
 @AppStorage("shuffleUp") private var shuffleUp = true
 @AppStorage("fontsize") private var fontsize = 24.0
 @AppStorage("padding") private var padding = 2.0
 @AppStorage("border") private var border = 3.0
  
  
 */

