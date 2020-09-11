//
//  SVGRectangle.swift
//  
//
//  Created by Mike Muszynski on 8/27/20.
//

import Foundation
import CoreGraphics

class SVGRectangle: SVGElement {
    var rect: CGRect = .zero
    
    override var path: CGPath {
        return CGPath(rect: self.rect, transform: nil)
    }
    
    override func updateAttributes(with attributes: [String : String]) {
        let formatter = NumberFormatter()
        
        if let att = attributes["width"], let number = formatter.number(from: att) {
            rect.size.width = CGFloat(truncating: number)
        } else if let vb = viewBox, let width = attributes["width"]?.asCGFloat(in: vb.width) {
            rect.size.width = width
        }
        
        if let att = attributes["height"], let number = formatter.number(from: att) {
            rect.size.height = CGFloat(truncating: number)
        } else if let vb = viewBox, let height = attributes["height"]?.asCGFloat(in: vb.height) {
            rect.size.height = height
        }
        
        if let att = attributes["x"], let number = formatter.number(from: att) {
            rect.origin.x = CGFloat(truncating: number)
        }
        
        if let att = attributes["y"], let number = formatter.number(from: att) {
            rect.origin.y = CGFloat(truncating: number)
        }
        
        super.updateAttributes(with: attributes)
    }
}
