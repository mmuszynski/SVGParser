//
//  SVGPaintingInstruction.swift
//  SVGParser
//
//  Created by Mike Muszynski on 12/1/19.
//  Copyright © 2019 Mike Muszynski. All rights reserved.
//

import Foundation

extension SVGElement {
    enum PaintingInstruction: Hashable {
        case fill(_ color: String, opacity: CGFloat? = nil)
        case stroke(_ color: String, opacity: CGFloat? = nil, strokeWidth: CGFloat = 1.0)
        
        static let defaultFillInstruction: PaintingInstruction = PaintingInstruction.fill("000000")
    }
}
