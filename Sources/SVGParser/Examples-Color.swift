//
//  SwiftUIView.swift
//
//
//  Created by Mike Muszynski on 8/27/20.
//

import SwiftUI

@available(macOS 14.0, *)
#Preview {
    @Previewable
    @AppStorage("com.mmuszynski.svgParser.colorExamples.selection")
    var selection: String = ""
        
    ExamplesSplitView(filenames: ["circle50", "circle50x100", "circle100", "circle200", "circle50-25-20"],
                      selection: $selection)

}
