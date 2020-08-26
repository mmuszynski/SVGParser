//
//  SVGPaintable.swift
//  SVGParser
//
//  Created by Mike Muszynski on 12/1/19.
//  Copyright © 2019 Mike Muszynski. All rights reserved.
//

import CoreGraphics

class SVGElement: SVGDrawable {
    var path: CGPath? { nil }
    var parent: SVGElement?
    var children: [SVGElement] = []
    var paintingInstructions: [SVGElement.PaintingInstruction] = []
    var transformInstructions: [SVGElement.Transform] = []
    
    /// The View Box for the top level parent
    var viewBox: CGRect? {
        while let parent = parent {
            if let box = parent.viewBox {
                return box
            }
        }
        return nil
    }
    
    func append(_ child: SVGElement) {
        self.children.append(child)
    }
    
    /// Updates painting instructions and other attributes. Calling `super` will update painting instructions
    /// - Parameter attributeDict: The attributes returned by the XML
    func updateAttributes(with attributes: [String: String]) {
        if let fillColor = attributes["fill"] {
            paintingInstructions.append(.fill(fillColor))
        }

        if let strokeColor = attributes["stroke"] {
            paintingInstructions.append(.stroke(strokeColor))
        }
        
        if let transformString = attributes["transform"] {
            let transforms = Array<SVGElement.Transform>(string: transformString)
            print(transformString)
            print(transforms)
        }
    }
}
