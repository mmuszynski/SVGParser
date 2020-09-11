//
//  SVGMask.swift
//  
//
//  Created by Mike Muszynski on 9/4/20.
//

import Foundation
import CoreGraphics

class SVGMask: SVGGroup {
    var x: CGFloat? {
        attributes["x"]?.asCGFloat
    }
    
    var y: CGFloat? {
        attributes["y"]?.asCGFloat
    }
    
    var width: CGFloat? {
        attributes["width"]?.asCGFloat
    }
    
    var height: CGFloat? {
        attributes["height"]?.asCGFloat
    }
}

