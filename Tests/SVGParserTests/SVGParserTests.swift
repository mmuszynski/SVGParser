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

    func testGrouping() {
        let dataURL = Bundle(for: SVGParserTests.self).url(forResource: "6", withExtension: "svg")!
        let data = try! Data(contentsOf: dataURL)
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
                path.parse()
            }
        }
    }

}
