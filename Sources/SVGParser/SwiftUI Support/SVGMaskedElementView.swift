//
//  SwiftUIView.swift
//  SVGParser
//
//  Created by Mike Muszynski on 5/12/25.
//

import SwiftUI

struct SVGMaskedElementView: View {
    var element: SVGElement
    var shape: SVGShape {
        SVGShape(element: element)
    }
    
    @Environment(\.fillOverrides) var fillOverrides
    @Environment(\.onTapOverrides) var tapGestureOverrides
    
    //Get the fill color for the element
    func getFillColor() -> Color? {
        if let id = element.id, let color = fillOverrides[id] {
            return color
        }
        return element.fillColor
    }
    
    func getTapGestureOverride() -> TapGestureOverride? {
        if let id = element.id, let gesture = tapGestureOverrides[id] {
            return gesture
        }
        return nil
    }
    
    var body: some View {
        ZStack {
            if let color = element.strokeColor {
                shape
                    .stroke(color, lineWidth: element.strokeWidth)
                    .opacity(element.strokeOpacity)
                    .zIndex(1)
            }
            
            if let color = element.fillColor {
                shape
                    .fill(color)
                    .opacity(element.fillOpacity)
                    .zIndex(0)
            }
            
            ForEach(0..<element.drawableChildren.count, id: \.self) { i in
                let child = element.drawableChildren[i]
                SVGElementView(element: child)
            }
        }
            .compositingGroup()
            .opacity(element.opacity)
            .alphaMask(SVGElementView(element: element.mask!))
            .onTapGesture(count: getTapGestureOverride()?.count ?? 1) {
                getTapGestureOverride()?.action()
            }
    }
}

extension View {
    func alphaMask<Mask: View>(_ view: Mask?) -> some View {
        self.mask(
            view?
                .compositingGroup()
                .luminanceToAlpha()
        )
    }
}
