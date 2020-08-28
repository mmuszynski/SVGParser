//
//  SwiftUIView.swift
//  
//
//  Created by Mike Muszynski on 8/27/20.
//

import SwiftUI

struct SVGExamplesCircles_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SVGImageView(image: .svg(named: "circle50"))
            SVGImageView(image: .svg(named: "circle100"))
            SVGImageView(image: .svg(named: "circle200"))
            SVGImageView(image: .svg(named: "circle50-25-20"))
        }
    }
}
