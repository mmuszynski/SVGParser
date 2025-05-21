//
//  SwiftUIView.swift
//  
//
//  Created by Mike Muszynski on 8/26/20.
//

import SwiftUI

@freestanding(declaration) macro SVGPreviewExpansion(_ name: String? = nil, _ filenames: [String]) = #externalMacro(module: "ExampleExpansionMacros", type: "SVGPreviewExpansion")

struct ExamplesSplitView: View {
    @State var selection: String = "" {
        didSet {
            UserDefaults.standard.set(selection, forKey: self.userDefaultsKey)
        }
    }
    let selections: [String]
    let userDefaultsKey: String
    
    init(selections: [String], key: String = "selection") {
        self.selections = selections
        self.userDefaultsKey = "com.mmuszynski.swiftui-svg-preview.\(key)"
        self.selection = selections.first ?? ""
    }
    
    var body: some View {
        NavigationSplitView {
            List(selections, id: \.self, selection: $selection) { filename in
                Text(filename)
            }
        } detail: {
            SVGImageView(image: .svg(named: selection))
                .padding()
        }
        .onAppear {
            self.selection = UserDefaults.standard.string(forKey: userDefaultsKey) ?? selections.first ?? ""
        }
    }
}

#Preview {
    ExamplesSplitView(selections: ["android", "beacon", "couch", "square50", "babybottle"], key: "examples")
}
