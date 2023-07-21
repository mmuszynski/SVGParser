//
//  File.swift
//
//
//  Created by Mike Muszynski on 9/3/20.
//

import Foundation
import SwiftUI

#if os(macOS)
class SVGSingleElementContentView: NSView {
    init(content: SVGSingleElementContent) {
        self.content = content
        super.init(frame: .zero)
        
        self.makeLayers()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    var content: SVGSingleElementContent
    func makeLayers() {
        let layer = CAShapeLayer()
        
        let path = content.path!
        var flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: path.boundingBox.height)
        let flipped = path.copy(using: &flipVertical)

        layer.path = flipped
        self.layer = layer
    }
    
    override var intrinsicContentSize: NSSize {
        return self.content.path?.boundingBox.size ?? .zero
    }
}

struct SVGView: NSViewRepresentable {
    var content: SVGSingleElementContent
    
    func makeNSView(context: Context) -> some NSView {
        return SVGSingleElementContentView(content: content)
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        
    }
}
#elseif os(iOS)
class SVGSingleElementContentView: UIView {
    init(content: SVGSingleElementContent) {
        self.content = content
        super.init(frame: .zero)
        
        self.makeLayers()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    var content: SVGSingleElementContent
    func makeLayers() {
        let layer = CAShapeLayer()
        let path = content.path!
        layer.path = path

        self.layer.addSublayer(layer)
    }
    
    override var intrinsicContentSize: CGSize {
        return self.content.path?.boundingBox.size ?? .zero
    }
}

struct SVGView: UIViewRepresentable {
    var content: SVGSingleElementContent
    
    func makeUIView(context: Context) -> some UIView {
        return SVGSingleElementContentView(content: content)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}
#endif

struct SVGExamplesUIKitCocoa_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SVGView(content: try! SVGSingleElementContent(forResource: "opusSharp", withExtenstion: "svg"))
            SVGView(content: try! SVGSingleElementContent(forResource: "opusWholeNote", withExtenstion: "svg"))
            SVGView(content: try! SVGSingleElementContent(forResource: "opusNumeral4", withExtenstion: "svg"))
            SVGView(content: try! SVGSingleElementContent(forResource: "opusClefC", withExtenstion: "svg"))
        }
        .fixedSize()
        .previewLayout(.sizeThatFits)
    }
}
