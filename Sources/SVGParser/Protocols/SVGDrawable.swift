//
//  SVGDrawable.swift
//  SVGParser
//
//  Created by Mike Muszynski on 12/2/19.
//  Copyright © 2019 Mike Muszynski. All rights reserved.
//

//import CoreGraphics
//import SwiftUI
//
//protocol SVGDrawable {
//    var path: CGPath? { get }
//    func path(in rect: CGRect) -> CGPath
//    
//    var paintingInstructions: [SVGElement.PaintingInstruction] { get }
//    var transformInstructions: [SVGElement.Transform] { get }
//    var parent: SVGElement? { get }
//    var children: [SVGElement] { get }
//    var viewBox: CGRect? { get }
//}
//
//extension SVGDrawable {
//    func path(in rect: CGRect) -> CGPath {
//        let thePath = path?.mutableCopy() ?? CGMutablePath()
//        
//        //Don't think I want to do this here, but rather when the view is actually being drawn in SwiftUI
////        for child in children {
////            if let child = child as? SVGDrawable {
////                thePath.addPath(child.path(in: rect))
////            }
////        }
//        
////        ///I think I want to scale and translate the view box to the rectangle supplied by the drawing system
////        ///Let's see what happens if I do that
////        if let box = viewBox {
////            var transform = CGAffineTransform(scaleX: rect.width / box.width, y: rect.height / box.height)
////            transform = transform.translatedBy(x: rect.minX - box.minX, y: rect.minY - box.minY)
////            return thePath.copy(using: &transform)!
////        }
//        
//        return thePath
//    }
//}
