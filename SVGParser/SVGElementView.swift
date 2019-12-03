//
//  SVGElementRenderer.swift
//  SVGParser
//
//  Created by Mike Muszynski on 12/2/19.
//  Copyright © 2019 Mike Muszynski. All rights reserved.
//

import SwiftUI

extension SVGElement: Identifiable {
    
}

extension SVGPath {
    func renderPath(with instructions: [SVGPaintingInstruction] = []) -> some View {
        self.paintingInstructions.append(contentsOf: instructions)
        return SVGPathShape(drawable: self).rasterized()
    }
}

extension SVGGroup {
    func renderGroup() -> some View {
        ZStack {
            ForEach(children) { child in
                child.rasterized(with: self.paintingInstructions)
            }
        }
    }
}

extension SVGElement {
    func rasterized(with instructions: [SVGPaintingInstruction] = []) -> some View {
        if let path = self as? SVGPath {
            return AnyView(path.renderPath(with: instructions))
        } else if let group = self as? SVGGroup {
            return AnyView(group.renderGroup())
        }
        return AnyView(EmptyView())
    }
}

public struct SVGImageView: View {
    var image: SVGImage
    
    public init(image: SVGImage) {
        self.image = image
    }
    
    public static var testView: SVGImageView {
        return SVGImageView(image: .testImage)
    }
    
    public var body: some View {
        return image.svg.rasterized()
    }
}

extension SVGElement {
    class var bruinsLogo: SVGGroup {
        let dataURL = Bundle(for: self).url(forResource: "6", withExtension: "svg")!
        let data = try! Data(contentsOf: dataURL)
        let parser = SVGXMLParser(data: data)
        let _ = parser.parse()
        return parser.svg
    }
    
    class var bruinsLogoJustTheGroups: SVGGroup {
        let dataURL = Bundle(for: self).url(forResource: "6groups", withExtension: "svg")!
        let data = try! Data(contentsOf: dataURL)
        let parser = SVGXMLParser(data: data)
        let _ = parser.parse()
        return parser.svg
    }
    
    static func teamLogo(id: Int) -> SVGGroup {
        let url = URL(string: "https://www-league.nhlstatic.com/images/logos/teams-current-primary-light/\(id).svg")!
        let data = try! Data(contentsOf: url)
        let parser = SVGXMLParser(data: data)
        let _ = parser.parse()
        return parser.svg
    }
    
    class var teamLogos: [SVGGroup] {
        var svgs = [SVGGroup]()
        for i in 1...1 {
            let url = URL(string: "https://www-league.nhlstatic.com/images/logos/teams-current-primary-light/\(i).svg")!
            guard let data = try? Data(contentsOf: url) else { continue }
            let parser = SVGXMLParser(data: data)
            let _ = parser.parse()
            
            svgs.append(parser.svg)
        }
        
        return svgs
    }
}

//struct SVGElementRenderer_Preview: PreviewProvider {
//    static let logos = SVGElement.teamLogos
//    
//    static var previews: some View {
//        Group {
//            ForEach(0..<SVGElementRenderer_Preview.logos.count) { id in
//                SVGElementView(element: SVGElementRenderer_Preview.logos[id])
//                    .position(x: 0, y: 0)
//            }
//        }
//    }
//}
