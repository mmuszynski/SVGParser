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

extension SVGElement {
    func rendered(with instructions: [SVGElement.PaintingInstruction] = [], transforms: [SVGElement.Transform] = []) -> some View {
        self.paintingInstructions.append(contentsOf: instructions)
        self.transformInstructions.append(contentsOf: transforms)
        
        return ZStack {
            SVGShape(drawable: self).rasterized()
            ForEach(self.children) { child in
                AnyView(child.rendered(with: self.paintingInstructions, transforms: self.transformInstructions))
            }
        }
    }
}

//extension SVGPath {
//    func renderPath(with instructions: [SVGElement.PaintingInstruction] = []) -> some View {
//        self.paintingInstructions.append(contentsOf: instructions)
//        return SVGShape(drawable: self).rasterized()
//    }
//}

//extension SVGGroup {
//    func renderGroup() -> some View {
//        ZStack {
//            ForEach(children) { child in
//                child.rasterized(with: self.paintingInstructions)
//            }
//        }
//    }
//}

//extension SVGElement {
//    func rasterized() -> some View {
//        SVGShape(drawable: self).rasterized()
//    }
//    
////    func rasterized(with instructions: [SVGElement.PaintingInstruction] = []) -> some View {
////        if let path = self as? SVGPath {
////            return AnyView(path.renderPath(with: instructions))
////        } else if let group = self as? SVGGroup {
////            return AnyView(group.renderGroup())
////        }
////        return AnyView(EmptyView())
////    }
//}


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

