//
//  SwiftUIView.swift
//  
//
//  Created by Mike Muszynski on 8/26/20.
//

import SwiftUI

struct SVGExamples_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SVGImageView(image: .svg(named: "android"))
            SVGImageView(image: .svg(named: "beacon"))
            SVGImageView(image: .svg(named: "couch"))
            SVGImageView(image: .svg(named: "square50"))
            SVGImageView(image: .svg(named: "babybottle"))
        }
    }
}
