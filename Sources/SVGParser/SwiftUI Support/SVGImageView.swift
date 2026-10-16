//
//  SVGImageView.swift
//  
//
//  Created by Mike Muszynski on 8/25/20.
//

import SwiftUI

public struct SVGImageView: View {
    var image: SVGImage
    
    /// An environment variable that allows individual elements to be filled with different colors, provided they have an available identifier.
    @Environment(\.fillOverrides) var fillOverrides
    @Environment(\.onTapOverrides) var tapOverrides

    public init(image: SVGImage) {
        self.image = image
    }
    
    public var body: some View {
        SVGElementView(element: image.content.svg)
    }
}

struct SVGImagePreviews: PreviewProvider {
    static var previews: some View {
        Group {
            SVGImageView(image: try! .svg(named: "Bruins"))
                .previewLayout(.sizeThatFits)
            
            SVGImageView(image: try! .svg(named: "Club"))
                .previewLayout(.sizeThatFits)
                .padding()
        }
    }
}
