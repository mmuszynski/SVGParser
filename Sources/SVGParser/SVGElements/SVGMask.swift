//
//  SVGMask.swift
//  
//
//  Created by Mike Muszynski on 9/4/20.
//

import Foundation

class SVGMask: SVGGroup {
//    readonly attribute SVGAnimatedEnumeration maskUnits;
//      readonly attribute SVGAnimatedEnumeration maskContentUnits;
//      readonly attribute SVGAnimatedLength x;
//      readonly attribute SVGAnimatedLength y;
//      readonly attribute SVGAnimatedLength width;
//      readonly attribute SVGAnimatedLength height;
    
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

