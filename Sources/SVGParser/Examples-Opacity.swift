//
//  File.swift
//  
//
//  Created by Mike Muszynski on 9/3/20.
//

import Foundation
import SwiftUI

@available(macOS 14.0, *)
#Preview {
    @Previewable
    @AppStorage("com.mmuszynski.svgParser.transparencyExamples.selection")
    var selection: String = ""
    
        
    ExamplesSplitView(filenames: ["w3opacityExample", "squareTransparent50", "squareTransparent50pct", "opacityOverlap"],
                      selection: $selection)
    
}
