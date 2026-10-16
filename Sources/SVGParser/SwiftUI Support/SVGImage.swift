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
    enum SVGImageError: Error {
        case resourceNotFound
        case isDirectory
    }
    
    var content: SVGContent
    
    public init(contentsOf url: URL) throws {
        content = try SVGContent(contentsOf: url)
    }
}

extension SVGImage {
    public static func svg(named name: String) throws -> SVGImage {
        guard name != "" else {
            throw SVGImageError.resourceNotFound
        }
        
        guard let dataURL = Bundle.module.url(forResource: name, withExtension: "svg") else {
            throw SVGImageError.resourceNotFound
        }
        
        let image = try SVGImage(contentsOf: dataURL)
        return image
    }
}
