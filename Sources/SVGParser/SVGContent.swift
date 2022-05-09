//
//  File.swift
//  
//
//  Created by Mike Muszynski on 5/9/22.
//

import Foundation

/// The output of a SVGXMLParser
///
/// In order to render SVG data, the XML must first be parsed. After this, it is up to the renderer to actually draw the information on screen. Initially, this library was written with SwiftUI in mind, so the rendering has all taken place in SwiftUI Views. This intermediate step is an attempt to provide public information to a rendering implementation so that the SwiftUI portion of the library can be moved to a submodule (and so there can be a Cocoa/UIKit implementation).
class SVGContent {
    
    /// A parser to decode the SVG XML.
    private var parser: SVGXMLParser
    
    /// A cache for the parsed SVG data, which can be complex
    private var _svg: SVGTopElement?
    
    public var svg: SVGTopElement {
        if let svg = _svg { return svg }
        
        guard self.parser.parse() else { fatalError("Unable to parse svg data") }
        self._svg = parser.svg
        return _svg!
    }
    
    public init(contentsOf url: URL) throws {
        let data = try Data(contentsOf: url)
        self.parser = SVGXMLParser(data: data)
    }
    
    public convenience init(forResource name: String, withExtenstion ext: String) throws {
        guard let url = Bundle.module.url(forResource: name, withExtension: ext) else {
            fatalError()
        }
        try self.init(contentsOf: url)
    }
}
