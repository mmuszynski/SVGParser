//
//  SwiftUIView.swift
//  SVGParser
//
//  Created by Mike Muszynski on 5/6/25.
//

import SwiftUI

#Preview {
    SVGImageView(image: .svg(named: "HighCKey"))
        .override(fillColor: .green, forElementID: "High-C-Key")
    SVGImageView(image: SVGImage.svg(named: "Wing Keys"))
}
