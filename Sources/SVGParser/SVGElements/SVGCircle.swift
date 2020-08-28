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
    var center: CGPoint = .zero
    var radius: CGFloat = 0
    
    override var path: CGPath {
        let path = CGMutablePath()
        path.addArc(center: center, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        return path
    }
    
    override func updateAttributes(with attributes: [String : String]) {
        let formatter = NumberFormatter()
        
        if let cx = attributes["cx"], let number = formatter.number(from: cx) {
            center.x = CGFloat(truncating: number)
        }
        if let cy = attributes["cy"], let number = formatter.number(from: cy) {
            center.y = CGFloat(truncating: number)
        }
        if let rad = attributes["r"], let number = formatter.number(from: rad) {
            radius = CGFloat(truncating: number)
        }
        
        super.updateAttributes(with: attributes)
    }
}
