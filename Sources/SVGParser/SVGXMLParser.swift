//
//  SVGXMLParser.swift
//  SVGParser
//
//  Created by Mike Muszynski on 12/1/19.
//  Copyright © 2019 Mike Muszynski. All rights reserved.
//

import Foundation
import CoreGraphics

final class SVGXMLParser: XMLParser, XMLParserDelegate {
    public var svg = SVGTopElement(attributes: [:])
    private var currentElement: SVGElement?
    
    override func parse() -> Bool {
        self.delegate = self
        return super.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        switch elementName {
        case "svg":
            svg = SVGTopElement(attributes: attributeDict)
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
            if let group = currentElement as? SVGGroup {
                group.append(newGroup)
                newGroup.parent = group
                currentElement = newGroup
            }
            newGroup.updateAttributes(with: attributeDict)
        case "circle":
            let newPath = SVGCircle(attributes: attributeDict)
            if let currentGroup = currentElement as? SVGGroup {
                newPath.parent = currentGroup
                currentGroup.append(newPath)
                currentElement = newPath
            }
            
            newPath.updateAttributes(with: attributeDict)
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElement = currentElement?.parent
    }
}
