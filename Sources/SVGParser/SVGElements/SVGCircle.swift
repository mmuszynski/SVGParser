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
    
    private var _center: CGPoint?
    var center: CGPoint {
        if let center = _center { return center }
        
        guard let cx = attributes["cx"]?.asCGFloat, let cy = attributes["cy"]?.asCGFloat else {
            return .zero
        }
        
        self._center = CGPoint(x: cx, y: cy)
        return self.center
    }
    
    private var _radius: CGFloat?
    var radius: CGFloat {
        if let radius = _radius { return radius }
        self._radius = attributes["r"]?.asCGFloat ?? 0
        return self.radius
    }
    
    override var path: CGPath {
        let path = CGMutablePath()
        path.addArc(center: center, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        return path
    }

}
