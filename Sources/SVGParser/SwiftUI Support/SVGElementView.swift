//
//  SwiftUIView.swift
//  SVGParser
//
//  Created by Mike Muszynski on 5/12/25.
//

import SwiftUI

struct SVGElementView: View {
    var element: SVGElement
    @Environment(\.fillOverrides) var fillOverrides
    @Environment(\.onTapOverrides) var tapGestureOverrides
    
    var body: some View {
        if element.mask == nil {
            SVGUnmaskedElementView(element: element)
        } else {
            SVGMaskedElementView(element: element)
        }
    }
}

#Preview {
    SVGElementView(element: .init())
}
