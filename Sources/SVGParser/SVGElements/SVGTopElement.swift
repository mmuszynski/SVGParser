//
//  SVGTopElement.swift
//  SVGParser
//
//  Created by Mike Muszynski on 12/2/19.
//  Copyright © 2019 Mike Muszynski. All rights reserved.
//

import Foundation

class SVGTopElement: SVGGroup {
    private var _viewBox: CGRect?
    override var viewBox: CGRect? {
        return _viewBox
    }
    
    /// The width of the SVG element, defined at the top level
    var width: CGFloat?
    
    /// The height of the SVG element, defined at the top level
    var height: CGFloat?
    
    override func updateAttributes(with attributes: [String: String]) {
        if let viewBox = attributes["viewBox"] {
            let scanner = Scanner(string: viewBox)
            scanner.charactersToBeSkipped = .whitespacesAndNewlines
            var numbers: [Double] = []
            while let number = scanner.scanDouble() {
                numbers.append(number)
            }
            
            let floats = numbers.map { CGFloat($0) }
            self._viewBox = CGRect(x: floats[0], y: floats[1], width: floats[2], height: floats[3])
        }
        
        super.updateAttributes(with: attributes)
    }
}
