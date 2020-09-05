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

extension SVGElement: Identifiable {}

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
    
    var strokeColor: Color? {
        //Travel up the parents looking for instructions
        var element: SVGElement? = self
        while element != nil {
            //Return the first one that we find
            if let color = element?.attributes["stroke"] {
                return Color(cssString: color)
            }
            element = element?.parent
        }
        
        return nil
    }
    
    var strokeOpacity: Double {
        return Double(attributes["stroke-opacity"]?.asCGFloat ?? 1)
    }
    
    var strokeWidth: CGFloat {
        return attributes["stroke-width"]?.asCGFloat ?? 1
    }
    
    var fillColor: Color? {
        //Travel up the parents looking for instructions
        var element: SVGElement? = self
        while element != nil {
            //Return the first one that we find
            if let color = element?.attributes["fill"] {
                return Color(cssString: color)
            }
            element = element?.parent
        }
        
        if self.children.isEmpty { return Color.black }
        return nil
    }
    
    var fillOpacity: Double {
        return Double(attributes["fill-opacity"]?.asCGFloat ?? 1)
    }
    
    var opacity: Double {
        return Double(attributes["opacity"]?.asCGFloat ?? 1)
    }
    
    func rendered() -> some View {
        if self.mask == nil {
            return AnyView(
                ZStack {
                    if let color = self.strokeColor {
                        SVGShape(element: self)
                            .stroke(color, lineWidth: strokeWidth)
                            .opacity(self.strokeOpacity)
                    }
                    
                    if let color = self.fillColor {
                        SVGShape(element: self)
                            .fill(color)
                            .opacity(self.fillOpacity)
                    }
                    
                    ForEach(0..<drawableChildren.count) { i in
                        let child = self.drawableChildren[i]
                        AnyView(child.rendered())
                    }
                }
                .compositingGroup()
                .opacity(self.opacity)
            )
        } else {
            return AnyView(
                ZStack {
                    if let color = self.strokeColor {
                        SVGShape(element: self)
                            .stroke(color, lineWidth: strokeWidth)
                            .opacity(self.strokeOpacity)
                    }
                    
                    if let color = self.fillColor {
                        SVGShape(element: self)
                            .fill(color)
                            .opacity(self.fillOpacity)
                    }
                    
                    ForEach(0..<drawableChildren.count) { i in
                        let child = self.drawableChildren[i]
                        AnyView(child.rendered())
                    }
                }
                .compositingGroup()
                .opacity(self.opacity)
                .mask(self.mask?.rendered().compositingGroup().luminanceToAlpha())
            )
        }
    }
}
struct SVGElementView_Previews: PreviewProvider {
    static var previews: some View {
        SVGImageView(image: .svg(named: "Spade"))
            .previewLayout(.fixed(width: 300, height: 300))
    }
}

extension View {
    func alphaMask<Mask>(_ mask: Mask?) -> some View where Mask : View {
        mask?
            .compositingGroup()
            .luminanceToAlpha()
    }
}
