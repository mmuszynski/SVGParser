//
//  SVGPaintable.swift
//  SVGParser
//
//  Created by Mike Muszynski on 12/1/19.
//  Copyright © 2019 Mike Muszynski. All rights reserved.
//

import CoreGraphics
import Foundation
import SwiftUI

class SVGElement {
    var path: CGPath? { nil }
    func path(in rect: CGRect) -> CGPath {
        let thePath = path ?? CGMutablePath()
        return thePath
    }
    var parent: SVGElement?
    var children: [SVGElement] = []
    var transformInstructions: [SVGElement.Transform] = []
    var id: String?
    var attributes = [String: String]()
    
    var allTransformInstructions: [SVGElement.Transform] {
        return (parent?.transformInstructions ?? []) + self.transformInstructions
    }
    
    var preserveAspectRatio: PreserveAspectRatio = .default //PreserveAspectRatio(align: .none, meetOrSlice: .meet)
    
    /// The View Box for the top level parent
    var viewBox: CGRect? {
        var parent = self
        while let next = parent.parent {
            parent = next
            if let box = parent.viewBox {
                return box
            }
        }
        return nil
    }
    
    func append(_ child: SVGElement) {
        self.children.append(child)
    }
    
    /// Updates painting instructions and other attributes.
    /// - Parameter attributeDict: The attributes returned by the XML
    func updateAttributes(with attributes: [String: String]) {
        if let transformString = attributes["transform"] {
            let transforms = Array<SVGElement.Transform>(string: transformString)
            self.transformInstructions = transforms
        }
        
        if let id = attributes["id"] {
            self.id = id
        }
        
        self.attributes = attributes
    }
    
    func scale(for rect: CGRect) -> CGFloat {
        let vb_width = viewBox?.width ?? rect.width
        let vb_height = viewBox?.height ?? rect.height
        
        //Let e-x, e-y, e-width, e-height be the position and size of the element respectively.
        let e_width = rect.width
        let e_height = rect.height
        
        //Let align be the align value of preserveAspectRatio, or 'xMidYMid' if preserveAspectRatio is not defined.
        //Let meetOrSlice be the meetOrSlice value of preserveAspectRatio, or 'meet' if preserveAspectRatio is not defined or if meetOrSlice is missing from this value.
        let align = self.preserveAspectRatio.align
        let meetOrSlice = self.preserveAspectRatio.meetOrSlice
        
        //Initialize scale-x to e-width/vb-width.
        //Initialize scale-y to e-height/vb-height.
        
        var scale_x = e_width / vb_width
        var scale_y = e_height / vb_height
        
        if case .none = align {
        } else {
            let resize: CGFloat
            if meetOrSlice == .meet {
                resize = min(scale_x, scale_y)
            } else {
                resize = max(scale_x, scale_y)
            }
            scale_x = resize
            scale_y = resize
        }
        
        return scale_x
    }
    
    static func transform(from viewBox: CGRect?, to viewport: CGRect, preserveAspectRatio: PreserveAspectRatio = .default) -> [SVGElement.Transform] {
        //Let vb-x, vb-y, vb-width, vb-height be the min-x, min-y, width and height values of the viewBox attribute respectively.
        
        let vb_x = viewBox?.minX ?? viewport.minX
        let vb_y = viewBox?.minY ?? viewport.minY
        let vb_width = viewBox?.width ?? viewport.width
        let vb_height = viewBox?.height ?? viewport.height
        
        //Let e-x, e-y, e-width, e-height be the position and size of the element respectively.
        let e_x = viewport.minX
        let e_y = viewport.minY
        let e_width = viewport.width
        let e_height = viewport.height
        
        //Let align be the align value of preserveAspectRatio, or 'xMidYMid' if preserveAspectRatio is not defined.
        //Let meetOrSlice be the meetOrSlice value of preserveAspectRatio, or 'meet' if preserveAspectRatio is not defined or if meetOrSlice is missing from this value.
        let align = preserveAspectRatio.align
        let meetOrSlice = preserveAspectRatio.meetOrSlice
        
        //Initialize scale-x to e-width/vb-width.
        //Initialize scale-y to e-height/vb-height.
        
        var scale_x = e_width / vb_width
        var scale_y = e_height / vb_height
        
        //If align is not 'none' and meetOrSlice is 'meet', set the larger of scale-x and scale-y to the smaller.
        //Otherwise, if align is not 'none' and meetOrSlice is 'slice', set the smaller of scale-x and scale-y to the larger.

        if case .none = align {
        } else {
            let resize: CGFloat
            if meetOrSlice == .meet {
                resize = min(scale_x, scale_y)
            } else {
                resize = max(scale_x, scale_y)
            }
            scale_x = resize
            scale_y = resize
        }
        
        //Initialize translate-x to e-x - (vb-x * scale-x).
        //Initialize translate-y to e-y - (vb-y * scale-y)
        
        var translate_x = e_x - (vb_x * scale_x)
        var translate_y = e_y - (vb_y * scale_y)
                
        //If align contains 'xMid', add (e-width - vb-width * scale-x) / 2 to translate-x.
        //If align contains 'xMax', add (e-width - vb-width * scale-x) to translate-x.
        if case .some(.xMid, _) = align {
            translate_x += (e_width - vb_width * scale_x) / 2
        } else if case .some(.xMax, _) = align {
            translate_x += e_width - vb_width * scale_x
        }
        
        //If align contains 'yMid', add (e-height - vb-height * scale-y) / 2 to translate-y.
        //If align contains 'yMax', add (e-height - vb-height * scale-y) to translate-y.
        if case .some(_, .yMid) = align {
            translate_y += (e_height - vb_height * scale_y) / 2
        } else if case .some(_, .yMax) = align {
            translate_y += (e_height - vb_height * scale_y)
        }
        
        return [.translate(translate_x, translate_y), .scale(scale_x, scale_y)]
    }
    
    func descendant(named name: String) -> SVGElement? {
        for child in children {
            if child.id == name {
                return child
            } else {
                return child.descendant(named: name)
            }
        }
        
        return nil
    }
    
    var rootElement: SVGElement {
        var element: SVGElement? = self
        while element?.parent != nil {
            element = element?.parent
        }
        return element!
    }

}

extension SVGElement: CustomDebugStringConvertible {
    var debugDescription: String {
        return description(level: 0)
    }
    
    func description(level: Int) -> String {
        var string = ""
        string += Array<String>(repeating: "----", count: level).reduce("", +)
        string += "> "
        string += String(describing: type(of: self)) + ": <\(String(format: "%p", unsafeBitCast(self, to: Int.self)))>"
        
        for child in children {
            string += "\r" + child.description(level: level + 1)
        }
        return string
    }
}
