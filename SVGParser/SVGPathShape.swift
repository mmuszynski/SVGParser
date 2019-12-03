//
//  SVGElementRenderer.swift
//  SVGParser
//
//  Created by Mike Muszynski on 12/2/19.
//  Copyright © 2019 Mike Muszynski. All rights reserved.
//

import SwiftUI

struct SVGPathShape: Shape {
    var drawable: SVGDrawable
    
    func path(in rect: CGRect) -> Path {
        return Path(drawable.path(in: rect))
    }
    
    func rasterized() -> some View {
        ZStack {
            ForEach(drawable.paintingInstructions, id: \.self) { instruction -> AnyView in
                switch instruction {
                case .stroke(let colorString):
                    return AnyView(self.offset(x: 0, y: 0).scale(x: 1, y: 1, anchor: .topLeading).stroke(Color(hex: colorString)))
                case .fill(let colorString):
                    return AnyView(self.offset(x: 0, y: 0).scale(x: 1, y: 1, anchor: .topLeading).fill(Color(hex: colorString)))

                }
            }
        }
    }
}

extension SVGPath {
    class var testPath: SVGPath {
        let dataURL = Bundle(for: self).url(forResource: "6", withExtension: "svg")!
        let data = try! Data(contentsOf: dataURL)
        let parser = SVGXMLParser(data: data)
        let _ = parser.parse()
        return parser.svg.children[2] as! SVGPath
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SVGPathShape(drawable: SVGPath.testPath)
            .rasterized()
            .previewLayout(.fixed(width: 1000, height: 1000))
    }
}
