//
//  SVGRectangle.swift
//  
//
//  Created by Mike Muszynski on 8/27/20.
//

import Foundation

class SVGRectangle: SVGElement {
    var rect: CGRect = .zero
    
    override var path: CGPath {
        return CGPath(rect: self.rect, transform: nil)
    }
    
    override func updateAttributes(with attributes: [String : String]) {
        let formatter = NumberFormatter()
        
        if let att = attributes["width"], let number = formatter.number(from: att) {
            rect.size.width = CGFloat(truncating: number)
        }
        
        if let att = attributes["height"], let number = formatter.number(from: att) {
            rect.size.height = CGFloat(truncating: number)
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
