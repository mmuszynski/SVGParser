//
//  SVGParserTests.swift
//  SVGParserTests
//
//  Created by Mike Muszynski on 12/1/19.
//  Copyright © 2019 Mike Muszynski. All rights reserved.
//

import Testing
import SwiftUI
@testable import SVGParser

struct SVGParserTests {
    
    func svgData(named name: String) throws -> Data {
        guard let dataURL = Bundle.module.url(forResource: name, withExtension: "svg") else {
            fatalError("Could not get data for test")
        }
        
        return try Data(contentsOf: dataURL)
    }
    
    @Test
    func testGrouping() throws {
        let data = try! self.svgData(named: "6")
        let parser = SVGXMLParser(data: data)
        
        try #require(parser.parse(), "Parser failed")
        
        #expect(parser.svg.children.count == 7)
        #expect(parser.svg.children[0] is SVGPath)
        #expect(parser.svg.children[1] is SVGPath)
        #expect(parser.svg.children[2] is SVGPath)
        #expect(parser.svg.children[3] is SVGPath)
        #expect(parser.svg.children[4] is SVGGroup)
        #expect(parser.svg.children[5] is SVGGroup)
        #expect(parser.svg.children[6] is SVGGroup)
        
        for element in parser.svg.children {
            if let path = element as? SVGPath {
                #expect(path.path != nil)
            }
        }
    }
    
    @Test
    func testTransformStrings() {
        let translate = SVGElement.Transform.translate(0, 512)
        let scale = SVGElement.Transform.scale(0.1, -0.1)
        
        #expect(translate == translate)
        #expect("translate(0.000000,512.000000)" == translate)
        #expect("scale(0.100000,-0.100000)" == scale)
        
        let array = Array<SVGElement.Transform>(string: "translate(0.000000,512.000000) scale(0.100000,-0.100000)")
        #expect(array == [translate,scale])
    }
    
    @Test
    func testTransforms() {
        let translate = SVGElement.Transform.translate(0, 512)
        let scale = SVGElement.Transform.scale(0.1, -0.1)

        print(translate.transform)
        print(scale.transform)
        print(scale.transform.concatenating(translate.transform))
        print(translate.transform.concatenating(scale.transform))
    }
    
    @Test
    func testBeaconExample() throws {
        let data = try! svgData(named: "beacon")
        let parser = SVGXMLParser(data: data)
        try #require(parser.parse(), "Parser failed")
    }
    
    @Test
    func testHexColor() {
        let color = Color(svgString: "red")
        #expect(color == Color(svgString: "#FF0000"))
    }
    
    @Test
    func testDescription() throws {
        let data = try! svgData(named: "6")
        let parser = SVGXMLParser(data: data)
        try #require(parser.parse(), "Parser failed")
        //print(parser.svg.debugDescription)
    }
    
    @Test
    @MainActor func testNoGroupSVG() throws {
        SVGParser.debug = true
        let single = try SVGSingleElementContent(forResource: "opusNatural", withExtenstion: "svg")
        #expect(single.path != nil)
        SVGParser.debug = false
    }
    
    @Test
    @MainActor func testBassoonKey() throws {
        let _ = try! svgData(named: "HighCKey")
        let image = SVGImage.svg(named: "HighCKey")
        let _ = SVGImageView(image: image)
        
        #expect(image.content.svg.descendant(named: "High-C-Key") != nil)
        #expect(image.content.svg.descendant(named: "High-C-Key")?.strokeColor == .black)
    }
    
    @Test
    @MainActor func testSpade() throws {
        let _ = try! svgData(named: "Spade")
        let image = SVGImage.svg(named: "Spade")
        let _ = SVGImageView(image: image)
        
        image.content.svg.descendant(named: "stem-mask")?.children.forEach {
            #expect($0.fillColor != nil)
        }
    }
    
    @Test
    func testBassoonKeyExample() async throws {
        let dataURL = try #require(Bundle.module.url(forResource: "Wing Keys", withExtension: "svg"))

        #expect(throws: Never.self) {
            try SVGImage(contentsOf: dataURL)
        }
        
    }
}
