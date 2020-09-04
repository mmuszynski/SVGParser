//
//  File.swift
//  
//
//  Created by Mike Muszynski on 9/3/20.
//

import Foundation
import SwiftUI

struct SVGExamplesOpacity_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SVGImageView(image: .svg(named: "w3opacityExample"))
            SVGImageView(image: .svg(named: "squareTransparent50"))
            SVGImageView(image: .svg(named: "squareTransparent50pct"))
            SVGImageView(image: .svg(named: "opacityOverlap"))
        }
    }
}
