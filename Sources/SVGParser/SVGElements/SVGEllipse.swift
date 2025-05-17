//
//  SVGEllipse.swift
//  SVGParser
//
//  Created by Mike Muszynski on 5/17/25.
//

import Foundation
import CoreGraphics

//<ellipse id="F-Tone-Hole" serif:id="F Tone Hole" cx="538.875" cy="134.243" rx="41.735" ry="42.619" style="fill:none;stroke:#000;stroke-width:3.93px;stroke-linejoin:round;"/>

class SVGEllipse: SVGElement {
    
    private var _center: CGPoint?
    var center: CGPoint {
        if let center = _center { return center }
        
        guard let cx = attributes["cx"]?.asCGFloat, let cy = attributes["cy"]?.asCGFloat else {
            return .zero
        }
        
        self._center = CGPoint(x: cx, y: cy)
        return self.center
    }
    
    private var _radius: CGPoint?
    var radius: CGPoint {
        if let radius = _radius { return radius }
        let rx = attributes["rx"]?.asCGFloat ?? 0
        let ry = attributes["ry"]?.asCGFloat ?? 0
        _radius = CGPoint(x: rx, y: ry)
        return self.radius
    }
    
    private var ellipseBox: CGRect {
        CGRect(origin: center.applying(CGAffineTransform(translationX: -radius.x, y: -radius.y)), size: CGSize(width: radius.x * 2, height: radius.y * 2))
    }
    
    override var path: CGPath {
        let path = CGPath(ellipseIn: ellipseBox, transform: nil)
        return path
    }

}

