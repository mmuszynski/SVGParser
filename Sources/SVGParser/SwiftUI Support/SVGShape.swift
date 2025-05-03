//
//  SVGElementRenderer.swift
//  SVGParser
//
//  Created by Mike Muszynski on 12/2/19.
//  Copyright © 2019 Mike Muszynski. All rights reserved.
//

import SwiftUI

struct SVGShape: Shape {
    var _path: Path
    var instructions: [SVGElement.Transform]
    var aspectRatio: SVGElement.PreserveAspectRatio
    var viewBox: CGRect?
        
    init(element: SVGElement) {
        instructions = element.allTransformInstructions
        _path = Path(element.path ?? CGMutablePath())
        aspectRatio = element.preserveAspectRatio
        viewBox = element.viewBox
    }
    
    func path(in rect: CGRect) -> Path {
        let path = _path
        
        func finalTransform(in rect: CGRect) -> CGAffineTransform {
            var final = CGAffineTransform.identity
            
            var allTransforms = instructions
            let viewBoxTransforms = SVGElement.transform(from: viewBox, to: rect, preserveAspectRatio: aspectRatio)
            allTransforms = (viewBoxTransforms + allTransforms).reversed()
            
            for instruction in allTransforms {
                final = final.concatenating(instruction.transform)
            }
            
            return final
        }
        
        let transform = finalTransform(in: rect)
        return path.applying(transform)
    }
}

extension SVGPath {
    class var testPath: SVGPath {
        guard let dataURL = Bundle.module.url(forResource: "Bruins", withExtension: "svg") else {
            fatalError()
        }
        
        let data = try! Data(contentsOf: dataURL)
        let parser = SVGXMLParser(data: data)
        let _ = parser.parse()
        return parser.svg.children[2] as! SVGPath
    }
    
    class var testGroup: SVGGroup {
        guard let dataURL = Bundle.module.url(forResource: "Bruins", withExtension: "svg") else {
            fatalError()
        }
        
        let data = try! Data(contentsOf: dataURL)
        let parser = SVGXMLParser(data: data)
        let _ = parser.parse()
        return parser.svg.children[6] as! SVGGroup
    }
    
    class var circle: SVGCircle {
        guard let dataURL = Bundle.module.url(forResource: "circle100", withExtension: "svg") else {
            fatalError()
        }
        
        let data = try! Data(contentsOf: dataURL)
        let parser = SVGXMLParser(data: data)
        let _ = parser.parse()
        return parser.svg.children[0] as! SVGCircle
    }
}

struct SVGShape_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SVGShape(element: SVGPath.testPath)
                .previewLayout(.sizeThatFits)
            SVGShape(element: SVGPath.circle)
                .previewLayout(.sizeThatFits)
        }
    }
}
