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
        case fill(_ color: String)
        case stroke(_ color: String, strokeWidth: CGFloat)
        
        static let defaultFillInstruction: PaintingInstruction = PaintingInstruction.fill("000000")
    }
}
