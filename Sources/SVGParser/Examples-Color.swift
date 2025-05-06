//
//  SwiftUIView.swift
//
//
//  Created by Mike Muszynski on 8/27/20.
//

import SwiftUI

struct SVGExamplesColors_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SVGImageView(image: .svg(named: "circle50"))
                .border(.black)
            SVGImageView(image: .svg(named: "circle50x100"))
                .border(.black)
            SVGImageView(image: .svg(named: "circle100"))
                .border(.black)
            SVGImageView(image: .svg(named: "circle200"))
                .border(.black)
            SVGImageView(image: .svg(named: "circle50-25-20"))
                .border(.black)
        }
    }
}
