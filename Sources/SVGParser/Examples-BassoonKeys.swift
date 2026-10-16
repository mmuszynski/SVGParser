//
//  SwiftUIView.swift
//  SVGParser
//
//  Created by Mike Muszynski on 5/6/25.
//

import SwiftUI

#Preview {
    try! SVGImageView(image: .svg(named: "HighCKey"))
        .override(fillColor: .green, forElementID: "High-C-Key")
    try! SVGImageView(image: SVGImage.svg(named: "Wing Keys"))
}
