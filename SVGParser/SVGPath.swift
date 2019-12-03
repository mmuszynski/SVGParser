//
//  SVGPath.swift
//  NHLShotDisplay
//
//  Created by Mike Muszynski on 11/30/19.
//  Copyright © 2019 Mike Muszynski. All rights reserved.
//

import Foundation
import CoreGraphics

extension Scanner {
    fileprivate func scanCGPoint() -> CGPoint? {
        guard let x = self.scanDouble(), let y = self.scanDouble() else { return nil }
        return CGPoint(x: x, y: y)
    }
}

extension CGPoint {
    func relative(to other: CGPoint) -> CGPoint {
        return CGPoint(x: self.x + other.x, y: self.y + other.y)
    }
}


class SVGPath: SVGElement, SVGDrawable {
    private var pathString: String = ""
    
    ///Draws the parsed path in a rectangle supplied by the drawing system
    func path(in rect: CGRect) -> CGPath {
        if _path == nil {
            self.parse()
        }
        
        ///I think I want to scale and translate the view box to the rectangle supplied by the drawing system
        ///Let's see what happens if I do that
        if let box = viewBox {
            var transform = CGAffineTransform(scaleX: rect.width / box.width, y: rect.height / box.height)
            transform = transform.translatedBy(x: rect.minX - box.minX, y: rect.minY - box.minY)
            return self._path!.copy(using: &transform)!
        }
        
        return self._path!
    }
    private var _path: CGPath?
    
    override func updateAttributes(with attributes: [String : String]) {
        if let pathString = attributes["d"] {
            self.pathString = pathString
        }
        
        super.updateAttributes(with: attributes)
    }
    
    func instructionSet(for string: String) -> [Instruction] {
        let scanner = Scanner(string: pathString)
        let commandSet = CharacterSet(charactersIn: "MmZzLlHhVvSsCcQqTtAa")
        let skip = CharacterSet(charactersIn: ",").union(.whitespacesAndNewlines)
        scanner.charactersToBeSkipped = skip

        var instructions: [Instruction] = []

        ///Scans through the SVG data string until it hits characters from the allowable commands
        ///
        /// There is an edge case where the string scanner will pick up two adjacent characters and treat them as one character
        /// An example of this is a close path (z) followed by a move (m), which the string scanner will treat as the string "zm"
        /// Hopefully, enumerating the scanned string will catch this edge case
        while let command = scanner.scanCharacters(from: commandSet) {

            //Parses the command for each character returned by command set
            for character in command {

                //Whether the points are relative or absolute.
                let relative = command == command.lowercased()

                //The various commands
                switch character.lowercased() {
                case "m":
                    //Move to point
                    while let pt = scanner.scanCGPoint() {
                        instructions.append(.moveTo(point: pt, relative: relative))
                    }
                case "h":
                    //A horizontal line. This should hopefully not return more than one point.
                    //The SVG standard suggests that this "does not make sense," but nevertheless is possible
                    while let x = scanner.scanDouble() {
                        let xFloat = CGFloat(x)
                        instructions.append(.horizontal(to: xFloat, relative: relative))
                    }
                case "v":
                    //A vertical line. See the comment above about horizontal lines.

                    while let y = scanner.scanDouble() {
                        instructions.append(.vertical(to: CGFloat(y), relative: relative))
                    }

                case "l":
                    //A line to a point
                    while let point = scanner.scanCGPoint() {
                        instructions.append(.lineTo(point: point, relative: relative))
                    }
                case "s":
                    //A smooth curve.

                    while let cp1 = scanner.scanCGPoint(),
                        let endpoint = scanner.scanCGPoint()
                    {
                        instructions.append(.smoothCurveTo(point: endpoint, cp1: cp1, relative: relative))
                    }

                case "c":
                    //A quadratic curve

                    while let cp1 = scanner.scanCGPoint(),
                        let cp2 = scanner.scanCGPoint(),
                        let point = scanner.scanCGPoint()
                    {
                        instructions.append(.curveTo(point: point, cp1: cp1, cp2: cp2, relative: relative))
                    }

                case "a":
                    //An arc
                    while let radii = scanner.scanCGPoint(),
                        let xAxisRotation = scanner.scanDouble(),
                        let largeArcFlag = scanner.scanDouble(),
                        let sweepFlag = scanner.scanDouble(),
                        let finalPoint = scanner.scanCGPoint()
                    {
                        instructions.append(.arc(to: finalPoint,
                                                 radii: radii,
                                                 largeArcFlag: largeArcFlag != 0,
                                                 sweepFlag: sweepFlag != 0,
                                                 xAxisRotation: xAxisRotation,
                                                 relative: relative))
                    }
                case "z":
                    instructions.append(.closePath)
                default:
                    fatalError()
                }
            }
        }
        
        return instructions
    }
    
    override func parse() {
        let path = CGMutablePath()
        path.move(to: .zero)

        let instructions = instructionSet(for: self.pathString)

        path.move(to: .zero)

        //The instructions that have been completed (so that smooth curves can grab the previous control point)
        var completedInstructions = [Instruction]()

        for index in 0..<instructions.count {

            //Get each instruction and the current point
            let instruction = instructions[index]
            let currentPoint = path.currentPoint

            //For each instruction, move to the point or whatnot
            switch instruction {
            case .moveTo(var point, let relative):
                if relative {
                    point = point.relative(to: currentPoint)
                }
                path.move(to: point)
                completedInstructions.append(.moveTo(point: point, relative: false))
            case .horizontal(let x, let relative):
                var point = currentPoint
                if relative {
                    point.x += x
                } else {
                    point.x = x
                }
                path.addLine(to: point)
                completedInstructions.append(.lineTo(point: point, relative: false))
            case .vertical(let y, let relative):
                var point = currentPoint
                if relative {
                    point.y += y
                } else {
                    point.y = y
                }
                path.addLine(to: point)
                completedInstructions.append(.lineTo(point: point, relative: false))
            case .closePath:
                path.closeSubpath()
                completedInstructions.append(.closePath)
            case .lineTo(var point, let relative):
                if relative {
                    point = point.relative(to: currentPoint)
                }
                path.addLine(to: point)
                completedInstructions.append(.lineTo(point: point, relative: false))
            case .curveTo(var point, var cp1, var cp2, let relative):
                if relative {
                    point = point.relative(to: currentPoint)
                    cp1 = cp1.relative(to: currentPoint)
                    cp2 = cp2.relative(to: currentPoint)
                }
                path.addCurve(to: point, control1: cp1, control2: cp2)
                completedInstructions.append(.curveTo(point: point, cp1: cp1, cp2: cp2, relative: false))
            case .smoothCurveTo(var endpoint, var cp2, let relative):
                /*

                 The S/s commands indicate that the first control point of the given cubic Bézier segment is calculated by reflecting the previous path segments second control point relative to the current point. The exact math is as follows. If the current point is (curx, cury) and the second control point of the previous path segment is (oldx2, oldy2), then the reflected point (i.e., (newx1, newy1), the first control point of the current path segment) is:

                 (newx1, newy1) = (curx - (oldx2 - curx), cury - (oldy2 - cury))
                 = (2*curx - oldx2, 2*cury - oldy2)
                 */

                if relative {
                    endpoint = endpoint.relative(to: currentPoint)
                    cp2 = cp2.relative(to: currentPoint)
                }

                let cp1: CGPoint
                let previous = completedInstructions.last
                switch previous {
                case .curveTo(_, _, let old, _):
                    let x = 2 * currentPoint.x - old.x
                    let y = 2 * currentPoint.y - old.y
                    cp1 = CGPoint(x: x, y: y)
                default:
                    cp1 = currentPoint
                }

                path.addCurve(to: endpoint, control1: cp1, control2: cp2)
                completedInstructions.append(.curveTo(point: endpoint, cp1: cp1, cp2: cp2, relative: false))
            case .arc(var endPoint, let radii, let largeArcFlag, let sweepFlag, let xAxisRotation, let relative):
                if relative {
                    endPoint = endPoint.relative(to: currentPoint)
                }

                //If the endpoint is equal to the current point, disregard it entirely
                if currentPoint == endPoint {
                    continue
                }

                /*
                 (x1, y1) are the absolute coordinates of the current point on the path, obtained from the last two parameters of the previous path command.
                 rx and ry are the radii of the ellipse (also known as its semi-major and semi-minor axes).
                 φ is the angle from the x-axis of the current coordinate system to the x-axis of the ellipse.
                 fA is the large arc flag, and is 0 if an arc spanning less than or equal to 180 degrees is chosen, or 1 if an arc spanning greater than 180 degrees is chosen.
                 fS is the sweep flag, and is 0 if the line joining center to arc sweeps through decreasing angles, or 1 if it sweeps through increasing angles.
                 (x2, y2) are the absolute coordinates of the final point of the arc.
                 */

                //phi in degrees and modded with 360
                //If rx or ry have negative signs, these are dropped; the absolute value is used instead.
                //φ is taken mod 360 degrees.

                let x1 = currentPoint.x
                let y1 = currentPoint.y
                let x2 = endPoint.x
                let y2 = endPoint.y
                var rx = abs(radii.x)
                var ry = abs(radii.y)
                let φ = xAxisRotation.truncatingRemainder(dividingBy: 360)

                //If rx = 0 or ry = 0 then this arc is treated as a straight line segment (a "lineto") joining the endpoints.
                if rx == 0 || ry == 0 {
                    path.addLine(to: endPoint)
                }

                //If rx, ry and φ are such that there is no solution (basically, the ellipse is not big enough to reach from (x1, y1) to (x2, y2)) then the ellipse is scaled up uniformly until there is exactly one solution (until the ellipse is just big enough).

                let cosφ = CGFloat(cos(φ))
                let sinφ = CGFloat(sin(φ))

                var x1p = cosφ * CGFloat(x1-x2)/2
                x1p += sinφ * (y1-y2)/2
                var y1p = -sinφ * CGFloat(x1-x2)/2
                y1p += cosφ * (y1-y2)/2

                var lhs: CGFloat

                var rx_2 = rx * rx
                var ry_2 = ry * ry
                let xp_2 = x1p * x1p
                let yp_2 = y1p * y1p

                let delta = xp_2/rx_2 + yp_2/ry_2

                if (delta > 1.0)
                {
                    rx *= sqrt(delta)
                    ry *= sqrt(delta)
                    rx_2 = rx * rx
                    ry_2 = ry * ry
                }

                let sign = (largeArcFlag == sweepFlag) ? -1 : 1
                var numerator = rx_2 * ry_2 - rx_2 * yp_2 - ry_2 * xp_2
                let denom = rx_2 * yp_2 + ry_2 * xp_2

                numerator = max(0, numerator);

                if (denom == 0) {
                    lhs = 0
                } else {
                     lhs = CGFloat(sign) * sqrt(numerator/denom)
                 }


                let cxp = lhs * (rx*y1p)/ry
                let cyp = lhs * -((ry * x1p)/rx)

                let cx = cosφ * cxp - sinφ * cyp + (x1+x2)/2
                let cy = sinφ * cxp + cosφ * cyp + (y1+y2)/2

                // transform our ellipse into the unit circle

                var tr = CGAffineTransform(translationX: -cx, y: -cy)
                tr = tr.concatenating(CGAffineTransform(rotationAngle: CGFloat(-φ)))
                tr = tr.concatenating(CGAffineTransform(scaleX: 1/rx, y: 1/ry))

                let arcPt1 = CGPoint(x: x1, y: y1).applying(tr)
                let arcPt2 = CGPoint(x: x2, y: y2).applying(tr)

                let startAngle = atan2(arcPt1.y, arcPt1.x)
                let endAngle = atan2(arcPt2.y, arcPt2.x);

                var angleDelta = endAngle - startAngle

                if (sweepFlag)
                {
                    if (angleDelta < 0) {
                        angleDelta += 2 * CGFloat.pi;
                    }
                }
                else
                {
                    if (angleDelta > 0) {
                        angleDelta = angleDelta - 2 * CGFloat.pi;
                    }
                }

                // construct the inverse transform
                var trInv = CGAffineTransform(scaleX: rx, y: ry)
                trInv = trInv.concatenating(CGAffineTransform(rotationAngle: CGFloat(φ)))
                trInv = trInv.concatenating(CGAffineTransform(translationX: cx, y: cy))
                
                path.addRelativeArc(center: .zero, radius: 1, startAngle: startAngle, delta: angleDelta, transform: trInv)
                completedInstructions.append(.arc(to: endPoint, radii: radii, largeArcFlag: largeArcFlag, sweepFlag: sweepFlag, xAxisRotation: xAxisRotation, relative: false))
            }
        }
        
        self._path = path

        super.parse()
    }
}
