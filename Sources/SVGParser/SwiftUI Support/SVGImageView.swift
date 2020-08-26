//
//  SVGImageView.swift
//  
//
//  Created by Mike Muszynski on 8/25/20.
//

import SwiftUI

public struct SVGImageView: View {
    var image: SVGImage
    
    public init(image: SVGImage) {
        self.image = image
    }
    
    public var body: some View {
        image.svg.rendered()
    }
}

extension SVGImage {
    static func svg(named name: String) -> SVGImage {
        let dataURL = Bundle.module.url(forResource: name, withExtension: "svg")!
        let image = try! SVGImage(contentsOf: dataURL)
        return image
    }
}

struct SVGImagePreviews: PreviewProvider {
    static var previews: some View {
        Group {
            SVGImageView(image: .svg(named: "Bruins"))
                .previewLayout(.sizeThatFits)
//            SVGImageView(image: .svg(named: "Club"))
//                .previewLayout(.fixed(width: 1000, height: 1000))
//                .padding()
        }
    }
}
