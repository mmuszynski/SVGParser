//
//  SVGParserTests.swift
//  SVGParserTests
//
//  Created by Mike Muszynski on 12/1/19.
//  Copyright © 2019 Mike Muszynski. All rights reserved.
//

import XCTest
import SwiftUI
@testable import SVGParser

class SVGParserTests: XCTestCase {
    
    func svgData(named name: String) throws -> Data {
        guard let dataURL = Bundle.module.url(forResource: name, withExtension: "svg") else {
            fatalError("Could not get data for test")
        }
        
        return try Data(contentsOf: dataURL)
    }
    
    func testGrouping() {
        let data = try! self.svgData(named: "6")
        let parser = SVGXMLParser(data: data)
        
        if !parser.parse() {
            XCTFail("Parser failed")
        }
        XCTAssert(parser.svg.children.count == 7)
        XCTAssert(parser.svg.children[0] is SVGPath)
        XCTAssert(parser.svg.children[1] is SVGPath)
        XCTAssert(parser.svg.children[2] is SVGPath)
        XCTAssert(parser.svg.children[3] is SVGPath)
        XCTAssert(parser.svg.children[4] is SVGGroup)
        XCTAssert(parser.svg.children[5] is SVGGroup)
        XCTAssert(parser.svg.children[6] is SVGGroup)
        
        for element in parser.svg.children {
            if let path = element as? SVGPath {
                XCTAssertNotNil(path.path)
            }
        }
    }
    
    func testTransformStrings() {
        let translate = SVGElement.Transform.translate(0, 512)
        let scale = SVGElement.Transform.scale(0.1, -0.1)
        
        XCTAssertEqual(translate, translate)
        XCTAssertEqual("translate(0.000000,512.000000)", translate)
        XCTAssertEqual("scale(0.100000,-0.100000)", scale)
        
        let array = Array<SVGElement.Transform>(string: "translate(0.000000,512.000000) scale(0.100000,-0.100000)")
        XCTAssertEqual(array, [translate,scale])
    }
    
    func testTransforms() {
        let translate = SVGElement.Transform.translate(0, 512)
        let scale = SVGElement.Transform.scale(0.1, -0.1)

        print(translate.transform)
        print(scale.transform)
        print(scale.transform.concatenating(translate.transform))
        print(translate.transform.concatenating(scale.transform))
    }
    
    func testBeaconExample() {
        let data = try! svgData(named: "beacon")
        let parser = SVGXMLParser(data: data)
        XCTAssertTrue(parser.parse())
    }
    
    func testHexColor() {
        let color = Color(cssString: "red")
        XCTAssertEqual(color, Color(cssString: "#FF0000"))
    }
    
    func testDescription() {
        let data = try! svgData(named: "6")
        let parser = SVGXMLParser(data: data)
        XCTAssertTrue(parser.parse())
        XCTAssertNotNil(parser.svg)
        print(parser.svg.debugDescription)
    }
    
    func testCGFloatConversion() {
        let string = "123"
        measure {
            let _ = string.asCGFloat
        }
    }
    
    func test2() {
        let string = "123"
        measure {
            let _ = CGFloat(string)
        }
    }
    
    func testNoGroupSVG() throws {
        let single = try SVGSingleElementContent(forResource: "opusNatural", withExtenstion: "svg")
    }
    
}
