//
//  SVGElementRenderer.swift
//  SVGParser
//
//  Created by Mike Muszynski on 12/2/19.
//  Copyright © 2019 Mike Muszynski. All rights reserved.
//

import SwiftUI

fileprivate extension SVGElement.PaintingInstruction {
    static let defaultFillInstruction = SVGElement.PaintingInstruction.fill("#000000")
}

extension SVGElement: Identifiable {}

extension SVGElement {
    func rendered(with instructions: [SVGElement.PaintingInstruction] = [], transforms: [SVGElement.Transform] = []) -> some View {
        self.paintingInstructions.append(contentsOf: instructions)
        self.transformInstructions.append(contentsOf: transforms)
        
        func finalTransform(in geometry: GeometryProxy) -> CGAffineTransform {
            let rect = geometry.frame(in: .local)
            var final = CGAffineTransform.identity
            
            var allTransforms = self.transformInstructions
            let viewBoxTransforms = transformForViewBox(to: rect)
            allTransforms = (viewBoxTransforms + allTransforms).reversed()
            
            for instruction in allTransforms {
                final = final.concatenating(instruction.transform)
            }
            
            return final
        }
        
        if children.isEmpty && paintingInstructions.isEmpty {
            self.paintingInstructions.append(.defaultFillInstruction)
        }
            
        
        return ZStack {
            GeometryReader { g in
                SVGShape(drawable: self)
                    .rasterized(with: finalTransform(in: g))
                ForEach(self.children) { child in
                    AnyView(child.rendered(with: self.paintingInstructions, transforms: self.transformInstructions))
                }
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
