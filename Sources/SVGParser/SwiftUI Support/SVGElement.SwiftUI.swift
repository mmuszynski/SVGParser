//
//  SVGElementRenderer.swift
//  SVGParser
//
//  Created by Mike Muszynski on 12/2/19.
//  Copyright © 2019 Mike Muszynski. All rights reserved.
//

import SwiftUI

fileprivate extension String {
    var cssValue: Double {
        if self.contains("%") {
            let percent = self.replacingOccurrences(of: "%", with: "")
            let amt = Double(percent) ?? 1
            return 1.0 * amt / 100
        }
        
        return Double(self) ?? 1
    }
}

extension SVGElement {
    var drawableChildren: [SVGElement] {
        return children.filter { child in
            return !(child is SVGMask)
        }
    }
    
    var mask: SVGMask? {
        guard let maskURL = attributes["mask"] else { return nil }
        let parts = maskURL.components(separatedBy: "#")
        let name = parts[1].replacingOccurrences(of: ")", with: "")
        let mask = self.rootElement.descendant(named: name)
        
        return mask as? SVGMask
    }
    
    func getStyleAttributeString(named attributeName: String) -> String? {
        if let color = self.attributes[attributeName] {
            return color
        }
        
        //fill:rgb(84,84,84);stroke:black;stroke-width:7.5px;
        let styleAttributes = self.attributes["style"]?.components(separatedBy: ";")
        let styles = styleAttributes?.reduce([String:String]()) { partialResult, string in
            var partialResult = partialResult
            let parts = string.components(separatedBy: ":")
            guard parts.count == 2 else { return partialResult }
            let key = parts[0]
            let value = parts[1]
            partialResult[key] = value
            return partialResult
        }
        
        return styles?[attributeName]
    }
    
    var strokeColor: Color? {
        if let color = self.getStyleAttributeString(named: "stroke") {
            return Color(svgString: color)
        }
        return nil
    }
    
    var strokeOpacity: Double {
        if let strokeOpacityString = getStyleAttributeString(named: "stroke-opacity") {
            return Double(strokeOpacityString) ?? 1
        }
        return 1
    }
    
    var strokeWidth: CGFloat {
        if let width = self.getStyleAttributeString(named: "stroke-width") {
            let scanner = Scanner(string: width)
            if let width = scanner.scanDouble() {
                return width
            }
        }
        return 0
    }
        
    var fillColor: Color? {
        //Use the color set by the attributes of the element
        if let color = self.getStyleAttributeString(named: "fill") {
            return Color(svgString: color)
        }
        
        //Otherwise, return the base color.
        return .black
    }
    
    var fillOpacity: Double {
        return Double(attributes["fill-opacity"]?.asCGFloat ?? 1)
    }
    
    var opacity: Double {
        return Double(attributes["opacity"]?.asCGFloat ?? 1)
    }
}

struct SVGElementView_Previews: PreviewProvider {
    static var previews: some View {
        SVGImageView(image: .svg(named: "Spade"))
    }
}
