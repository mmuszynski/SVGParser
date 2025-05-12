//
//  SwiftUIView.swift
//  SVGParser
//
//  Created by Mike Muszynski on 5/12/25.
//

import SwiftUI

struct SVGUnmaskedElementView: View {
    var element: SVGElement
    var shape: SVGShape {
        SVGShape(element: element)
    }
    var mask: SVGMask! {
        element.mask!
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
            }
            
            if let color = getFillColor() {
                shape
                    .fill(color)
                    .opacity(element.fillOpacity)
            }
            
            ForEach(0..<element.drawableChildren.count, id: \.self) { i in
                let child = element.drawableChildren[i]
                AnyView(SVGElementView(element: child))
            }
        }
        .compositingGroup()
        .opacity(element.opacity)
        .onTapGesture(count: getTapGestureOverride()?.count ?? 1) {
            getTapGestureOverride()?.action()
        }
    }
}

#Preview {
    SVGUnmaskedElementView(element: .init())
}
