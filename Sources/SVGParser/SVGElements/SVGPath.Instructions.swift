//
//  SVGPathInstructions.swift
//  SVGParser
//
//  Created by Mike Muszynski on 12/1/19.
//  Copyright © 2019 Mike Muszynski. All rights reserved.
//

import Foundation
import CoreGraphics

extension SVGPath {
    enum Instruction {
        case moveTo(point: CGPoint, relative: Bool)
        case horizontal(to: CGFloat, relative: Bool)
        case vertical(to: CGFloat, relative: Bool)
        case closePath
        case lineTo(point: CGPoint, relative: Bool)
        case curveTo(point: CGPoint, cp1: CGPoint, cp2: CGPoint, relative: Bool)
        case smoothCurveTo(point: CGPoint, cp1: CGPoint, relative: Bool)
        case arc(to: CGPoint, radii: CGPoint, largeArcFlag: Bool, sweepFlag: Bool, xAxisRotation: Double, relative: Bool)
    }
}
