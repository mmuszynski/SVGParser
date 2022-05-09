//
//  SVGImage.swift
//  SVGParser
//
//  Created by Mike Muszynski on 12/3/19.
//  Copyright © 2019 Mike Muszynski. All rights reserved.
//

import Foundation
import CoreGraphics
import SwiftUI

public struct SVGImage {
    var content: SVGContent
    
    public init(contentsOf url: URL) throws {
        content = try SVGContent(contentsOf: url)
    }
}
