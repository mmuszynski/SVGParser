//
//  SVGElement.Transform.swift
//  
//
//  Created by Mike Muszynski on 8/26/20.
//

import Foundation

extension SVGElement {
    enum Transform {
        case matrix(_ transform: CGAffineTransform)
        case translate(_ size: CGSize)
        case scale(_ size: CGSize)
        case rotate(_ degrees: CGFloat, around: CGPoint?)
        case skewX(_ degrees: CGFloat)
        case skewY(_ degrees: CGFloat)
    }
}

extension SVGElement.Transform: ExpressibleByStringLiteral {
    init?(string: String) {
        guard let element = Array<SVGElement.Transform>(string: string).first else { return nil }
        self = element
    }
    
    init(stringLiteral value: String) {
        guard let value = SVGElement.Transform(string: value) else {
            fatalError()
        }
        self = value
    }
}

extension SVGElement.Transform: Equatable {
    static func ==(lhs: SVGElement.Transform, rhs: SVGElement.Transform) -> Bool {
        switch lhs {
        case .matrix(let transform):
            if case let .matrix(rhsTransform) = rhs { return transform == rhsTransform }
        case .translate(let lhsAmount):
            if case let .translate(rhsAmount) = rhs { return lhsAmount == rhsAmount }
        case .scale(let lhsAmount):
            if case let .scale(rhsAmount) = rhs { return lhsAmount == rhsAmount }
        default:
            fatalError()
        //        case .scale(_):
        //        case .rotate(_, around: let around):
        //        case .skewX(_):
        //        case .skewY(_):
        
        }
        return false
    }
}

extension Array where Element == SVGElement.Transform {
    init(string: String) {
        var elements: [SVGElement.Transform] = []
        let string = string.lowercased()
        
        let typePatterns = [
            "matrix",
            "translate",
            "scale",
            "rotate",
            "skewx",
            "skewy"
        ]
        
        for pattern in typePatterns {
            let valuePattern = "\\(([0-9,.-]*)\\)"
            let fullPattern = pattern + valuePattern
            guard let range = string.range(of: fullPattern, options: .regularExpression) else {
                continue
            }
            
            let coordinates = String(string[range])
            let scanner = Scanner(string: coordinates)
            scanner.charactersToBeSkipped = CharacterSet(charactersIn: "()," + pattern)
            
            var scannedCoordinates: [CGFloat] = []
            while let coordinate = scanner.scanDouble() {
                scannedCoordinates.append(CGFloat(coordinate))
            }
            
            switch pattern {
            case "matrix":
                guard scannedCoordinates.count == 6 else { fatalError() }
                //#warning("Check to see if this is the right format of the transform")
                //CGAffineTransform asks for abcd tx ty
                //SVG Standard suggests abcdef
                let transform = CGAffineTransform(a: scannedCoordinates[0],
                                                  b: scannedCoordinates[1],
                                                  c: scannedCoordinates[2],
                                                  d: scannedCoordinates[3],
                                                  tx: scannedCoordinates[4],
                                                  ty: scannedCoordinates[5])
                elements.append(.matrix(transform))
            case "translate":
                guard scannedCoordinates.count > 0 else { fatalError() }
                if scannedCoordinates.count == 1 {
                    scannedCoordinates[1] = 0
                }
                elements.append(.translate(CGSize(width: scannedCoordinates[0], height: scannedCoordinates[1])))
            case "scale":
                guard scannedCoordinates.count > 0 else { fatalError() }
                if scannedCoordinates.count == 1 {
                    scannedCoordinates[1] = scannedCoordinates[0]
                }
                elements.append(.scale(CGSize(width: scannedCoordinates[0], height: scannedCoordinates[1])))
            case "rotate":
                guard scannedCoordinates.count > 0 else { fatalError() }
                if scannedCoordinates.count == 3 {
                    elements.append(.rotate(scannedCoordinates[0], around: CGPoint(x: scannedCoordinates[1], y: scannedCoordinates[2])))
                } else {
                    elements.append(.rotate(scannedCoordinates[0], around: nil))
                }
            case "skewx":
                guard scannedCoordinates.count > 0 else { fatalError() }
                elements.append(.skewX(scannedCoordinates[0]))
            case "skewy":
                guard scannedCoordinates.count > 0 else { fatalError() }
                elements.append(.skewY(scannedCoordinates[0]))
            default:
                fatalError("Unhandled pattern \(pattern)")
            }
        }
        
        self = elements
    }
}
