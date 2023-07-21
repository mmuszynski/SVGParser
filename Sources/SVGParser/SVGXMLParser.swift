//
//  SVGXMLParser.swift
//  SVGParser
//
//  Created by Mike Muszynski on 12/1/19.
//  Copyright © 2019 Mike Muszynski. All rights reserved.
//

import Foundation
import CoreGraphics
import OSLog

@available(macOS 11.0, *)
fileprivate let logger = Logger(subsystem: "com.mmuszynski.svgparser", category: "SVGXMLParser")

final class SVGXMLParser: XMLParser, XMLParserDelegate {
    //Not sure why this is public when the class is not.
    public var svg = SVGTopElement()
    private var currentElement: SVGElement?
    
    override func parse() -> Bool {
        self.delegate = self
        return super.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if #available(macOS 11.0, *), SVGParser.debug {
            logger.trace("Encountered \(elementName)")
        }
        
        switch elementName {
        case "svg":
            svg = SVGTopElement()
            currentElement = svg
            currentElement?.updateAttributes(with: attributeDict)
        case "path":
            let newPath = SVGPath()
            if let currentGroup = currentElement as? SVGGroup {
                newPath.parent = currentGroup
                currentGroup.append(newPath)
                currentElement = newPath
            }
            
            newPath.updateAttributes(with: attributeDict)
        case "g":
            let newGroup = SVGGroup()
            currentElement?.append(newGroup)
            newGroup.parent = currentElement
            newGroup.updateAttributes(with: attributeDict)
            currentElement = newGroup
        case "circle":
            let newPath = SVGCircle()
            if let currentGroup = currentElement as? SVGGroup {
                newPath.parent = currentGroup
                currentGroup.append(newPath)
                currentElement = newPath
            }
            
            newPath.updateAttributes(with: attributeDict)
        case "rect":
            let rect = SVGRectangle()
            if let currentGroup = currentElement as? SVGGroup {
                rect.parent = currentGroup
                currentGroup.append(rect)
                currentElement = rect
            }
            
            rect.updateAttributes(with: attributeDict)
        case "mask":
            let newGroup = SVGMask()
            currentElement?.append(newGroup)
            newGroup.parent = currentElement
            newGroup.updateAttributes(with: attributeDict)
            currentElement = newGroup
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if #available(macOS 11.0, *), SVGParser.debug {
            logger.trace("Did end \(elementName)")
        }
        
        if !(currentElement is SVGTopElement) {
            currentElement = currentElement?.parent
        }
    }
}
