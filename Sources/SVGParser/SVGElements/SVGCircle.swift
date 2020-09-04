//
//  SVGCircle.swift
//  SVGParser
//
//  Created by Mike Muszynski on 12/2/19.
//  Copyright © 2019 Mike Muszynski. All rights reserved.
//

import Foundation

class SVGCircle: SVGElement {
    var center: CGPoint {
        guard let cx = attributes["cx"]?.asCGFloat, let cy = attributes["cy"]?.asCGFloat else {
            return .zero
        }
        
        return CGPoint(x: cx, y: cy)
    }
    
    var radius: CGFloat {
        return attributes["r"]?.asCGFloat ?? 0
    }
    
    override var path: CGPath {
        let path = CGMutablePath()
        path.addArc(center: center, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        return path
    }

}
