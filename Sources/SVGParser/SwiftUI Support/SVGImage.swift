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
    var svg: SVGTopElement
    
    public init(contentsOf url: URL) throws {
        let data = try Data(contentsOf: url)
        let parser = SVGXMLParser(data: data)
        guard parser.parse() else {
            fatalError()
        }
        
        self.svg = parser.svg
    }
}
