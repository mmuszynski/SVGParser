//
//  SVGCircle.swift
//  SVGParser
//
//  Created by Mike Muszynski on 12/2/19.
//  Copyright © 2019 Mike Muszynski. All rights reserved.
//

import Foundation
import CoreGraphics

class SVGCircle: SVGElement {
    var _path: CGPath {
        let rect = CGRect(x: center.x - radius, y: center.y - radius, width: 2 * radius, height: 2 * radius)
        return CGPath(ellipseIn: rect, transform: nil)
    }
    var center: CGPoint = .zero
    var radius: CGFloat = 0
    
    init(attributes attributeDict: [String:String] = [:]) {
        super.init()
        self.updateAttributes(with: attributeDict)
    }
    
    override func updateAttributes(with attributes: [String : String]) {
        let formatter = NumberFormatter()
        
        if let cx = attributes["cx"], let number = formatter.number(from: cx) {
            center.x = CGFloat(truncating: number)
        }
        if let cy = attributes["cy"], let number = formatter.number(from: cy) {
            center.y = CGFloat(truncating: number)
        }
        if let rad = attributes["radius"], let number = formatter.number(from: rad) {
            radius = CGFloat(truncating: number)
        }
        
        super.updateAttributes(with: attributes)
    }
}
