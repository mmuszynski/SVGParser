//
//  SVGPaintingInstruction.swift
//  SVGParser
//
//  Created by Mike Muszynski on 12/1/19.
//  Copyright © 2019 Mike Muszynski. All rights reserved.
//

import Foundation

enum SVGPaintingInstruction: Hashable {
    case fill(_ color: String)
    case stroke(_ color: String)
}
