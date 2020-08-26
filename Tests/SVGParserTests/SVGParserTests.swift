//
//  SVGParserTests.swift
//  SVGParserTests
//
//  Created by Mike Muszynski on 12/1/19.
//  Copyright © 2019 Mike Muszynski. All rights reserved.
//

import XCTest
@testable import SVGParser

class SVGParserTests: XCTestCase {
    
    func svgData(named name: String) throws -> Data? {
        guard let dataURL = Bundle.module.url(forResource: name, withExtension: "svg") else {
            return nil
        }
        
        return try Data(contentsOf: dataURL)
    }
    
    func testGrouping() {
        let data = try! self.svgData(named: "6")!
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
    
    func testClub() {
        let data = try! self.svgData(named: "Club")!
        let parser = SVGXMLParser(data: data)
        
        XCTAssertTrue(parser.parse())
        parser.svg.path(in: CGRect(origin: .zero, size: CGSize(width: 300, height: 300)))
    }
    
    func testTransformStrings() {
        let translate = SVGElement.Transform.translate(CGSize(width: 0, height: 512))
        let scale = SVGElement.Transform.scale(CGSize(width: 0.1, height: -0.1))
        
        XCTAssertEqual(translate, translate)
        XCTAssertEqual("translate(0.000000,512.000000)", translate)
        XCTAssertEqual("scale(0.100000,-0.100000)", scale)
        
        let array = Array<SVGElement.Transform>(string: "translate(0.000000,512.000000) scale(0.100000,-0.100000)")
        XCTAssertEqual(array, [translate,scale])
    }
    
}
