//
//  SVGDrawable.swift
//  SVGParser
//
//  Created by Mike Muszynski on 12/2/19.
//  Copyright © 2019 Mike Muszynski. All rights reserved.
//

import CoreGraphics

protocol SVGDrawable {
    func path(in rect: CGRect) -> CGPath
    var paintingInstructions: [SVGPaintingInstruction] { get }
}
