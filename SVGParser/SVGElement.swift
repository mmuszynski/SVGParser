//
//  SVGPaintable.swift
//  SVGParser
//
//  Created by Mike Muszynski on 12/1/19.
//  Copyright © 2019 Mike Muszynski. All rights reserved.
//

import CoreGraphics

class SVGElement {
    var parent: SVGElement?
    var children: [SVGElement] = []
    var paintingInstructions: [SVGPaintingInstruction] = []
    
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
    
    /// You must call `super.parse()` in your subclass in order to make sure that child elements are parsed.
    func parse() {
        children.forEach { $0.parse() }
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
    }
}
