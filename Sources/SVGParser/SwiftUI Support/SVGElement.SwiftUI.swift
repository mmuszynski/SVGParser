//
//  SVGElementRenderer.swift
//  SVGParser
//
//  Created by Mike Muszynski on 12/2/19.
//  Copyright © 2019 Mike Muszynski. All rights reserved.
//

import SwiftUI

extension SVGElement: Identifiable {}

extension SVGElement {
    func rendered() -> some View {
        ZStack {
            ForEach(self.allPaintingInstructions, id: \.self) { instruction in
                switch instruction {
                case .stroke(let colorString, let strokeWidth):
                    SVGShape(element: self)
                        .stroke(Color(cssString: colorString), lineWidth: strokeWidth)
                case .fill(let colorString):
                    SVGShape(element: self)
                        .fill(Color(cssString: colorString))
                }
            }
            
            ForEach(0..<children.count) { i in
                let child = self.children[i]
                AnyView(child.rendered())
            }
        }
    }
}
struct SVGElementView_Previews: PreviewProvider {
    static var previews: some View {
        SVGImageView(image: .svg(named: "Club"))
            .previewLayout(.fixed(width: 300, height: 300))
    }
}

