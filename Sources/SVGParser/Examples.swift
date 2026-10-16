//
//  SwiftUIView.swift
//  
//
//  Created by Mike Muszynski on 8/26/20.
//

import SwiftUI

@freestanding(declaration) macro SVGPreviewExpansion(_ name: String? = nil, _ filenames: [String]) = #externalMacro(module: "ExampleExpansionMacros", type: "SVGPreviewExpansion")

public struct ExamplesSplitView: View {
    let filenames: [String]
    @Binding var selection: String
    
    var image: SVGImage? {
        try? .svg(named: selection)
    }
    
    public init(filenames: [String], selection: Binding<String>) {
        self.filenames = filenames
        self._selection = selection
    }
    
    public var body: some View {
        NavigationSplitView {
            List(filenames, id: \.self, selection: $selection) { filename in
                Text(filename)
            }
        } detail: {
            if let image {
                SVGImageView(image: image)
            } else {
                Text("No selection")
            }
        }
    }
}

@available(macOS 14.0, *)
#Preview {
    @Previewable 
    @AppStorage("com.mmuszynski.previews.svgExamples.selection")
    var selection: String = ""
    
    ExamplesSplitView(filenames: ["android", "beacon", "couch", "square50", "babybottle"], selection: $selection)
}
