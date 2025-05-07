//
//  SwiftUIView.swift
//  SVGParser
//
//  Created by Mike Muszynski on 5/6/25.
//

import SwiftUI

#Preview {
    SVGImageView(image: .svg(named: "HighCKey"))
        .setFillOverride(.blue, forElementID: "High-C-Key")
}
