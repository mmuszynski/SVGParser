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

extension URL {
    static func teamLogo(id: Int) -> URL {
        URL(string: "https://www-league.nhlstatic.com/images/logos/teams-current-primary-light/\(id).svg")!
    }
}

struct SVGImagePreviews: PreviewProvider {
    static var previews: some View {
        Group {
            SVGImageView(image: .svg(named: "Bruins"))
                .previewLayout(.sizeThatFits)
            
            SVGImageView(image: try! SVGImage(contentsOf: .teamLogo(id: 14)))
                .previewLayout(.sizeThatFits)
            
            SVGImageView(image: .svg(named: "Club"))
                .previewLayout(.sizeThatFits)
                .padding()
        }
    }
}
