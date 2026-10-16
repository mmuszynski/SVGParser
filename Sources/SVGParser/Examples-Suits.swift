//
//  File.swift
//  
//
//  Created by Mike Muszynski on 9/3/20.
//

import SwiftUI

@available(macOS 14.0, *)
#Preview {
    @Previewable
    @AppStorage("com.mmuszynski.svgParser.suits.selection")
    
    var selection: String = ""
    ExamplesSplitView(filenames: ["Spade", "Club", "Heart", "Diamond"], selection: $selection)
}
