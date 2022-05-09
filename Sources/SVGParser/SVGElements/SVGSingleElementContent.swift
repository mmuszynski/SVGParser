//
//  File.swift
//  
//
//  Created by Mike Muszynski on 5/9/22.
//

import Foundation
import CoreGraphics

/// If you are certain that your content contains a single element, you can use this class to describe it
public class SVGSingleElementContent {
    
    /// The full description of the content
    private var fullContent: SVGContent
    
    /// The single path described by the content
    public var path: CGPath? {
        self.fullContent.svg.children.first?.path
    }
    
    /// Initializes with a `URL` pointing to an SVG XML file
    /// - Parameter url: The `URL` for the SVG file
    public init(contentsOf url: URL) throws {
        try self.fullContent = SVGContent(contentsOf: url)
    }
    
    /// Initalizese a Single Element Content with a name and extension for a file that resides in the bundle
    /// - Parameters:
    ///   - name: A `String` naming the file
    ///   - ext: A `String` naming the extension for the file
    public convenience init(forResource name: String, withExtenstion ext: String) throws {
        guard let url = Bundle.module.url(forResource: name, withExtension: ext) else {
            fatalError()
        }
        try self.init(contentsOf: url)
    }
}
