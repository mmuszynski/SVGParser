//
//  SVGElementRenderer.swift
//  SVGParser
//
//  Created by Mike Muszynski on 12/2/19.
//  Copyright © 2019 Mike Muszynski. All rights reserved.
//

import SwiftUI

struct SVGShape: Shape {
    var drawable: SVGDrawable
    
    func path(in rect: CGRect) -> Path {
        return Path(drawable.path(in: rect))
    }
    
    func rasterized() -> some View {
        ZStack {
            ForEach(drawable.paintingInstructions, id: \.self) { instruction in
                switch instruction {
                case .stroke(let colorString):
                    self.stroke(Color(hex: colorString))
                case .fill(let colorString):
                    self.fill(Color(hex: colorString))
                }
            }
        }
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
}

struct SVGShape_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SVGShape(drawable: SVGPath.testPath)
                .rasterized()
                .previewLayout(.sizeThatFits)
            SVGShape(drawable: SVGPath.testGroup)
                .rasterized()
                .previewLayout(.sizeThatFits)
        }
    }
}
