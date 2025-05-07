//
//  HexColorTests.swift
//  SVGParser
//
//  Created by Mike Muszynski on 5/2/25.
//

import Testing
import SwiftUI
@testable import SVGParser

struct HexColorTests {
    @Test
    func keywordColors() async throws {
        #expect(Color(svgString: "red") == Color(.sRGB, red: 1, green: 0, blue: 0, opacity: 1))
        #expect(Color(svgString: "blue") == Color(.sRGB, red: 0, green: 0, blue: 1, opacity: 1))
        #expect(Color(svgString: "Green") == Color(.sRGB, red: 0, green: 128 / 255.0, blue: 0, opacity: 1))
        
        #expect(Color(svgString: "black") == .black)
        #expect(Color(svgString: "#000") == .black)
    }
    
    @Test("Integer functional")
    func integerFunctionalInit() async throws {
        #expect(Color(svgString: "rgb(100,200,100)") == Color(.sRGB, red: 100/255, green: 200/255, blue: 100/255, opacity: 1))
        #expect(Color(svgString: "rgb(100, 200, 100)") == Color(.sRGB, red: 100/255, green: 200/255, blue: 100/255, opacity: 1))
        #expect(Color(svgString: "(100, 200, 100)") == Color(.sRGB, red: 100/255, green: 200/255, blue: 100/255, opacity: 1))
        #expect(Color(svgString: "(100,200,100)") == Color(.sRGB, red: 100/255, green: 200/255, blue: 100/255, opacity: 1))
        #expect(Color(svgString: "(100, 200,100)") == Color(.sRGB, red: 100/255, green: 200/255, blue: 100/255, opacity: 1))
    }
    
    @Test("Float functional")
    func floatFunctionalInit() async throws {
        #expect(Color(svgString: "rgb(10%,10%,10%)") == Color(.sRGB, red: 25.5, green: 25.5, blue: 25.5, opacity: 1))
        #expect(Color(svgString: "rgb(10%, 10%,10%)") == Color(.sRGB, red: 25.5, green: 25.5, blue: 25.5, opacity: 1))
        #expect(Color(svgString: "rgb(10%, 10%, 10%)") == Color(.sRGB, red: 25.5, green: 25.5, blue: 25.5, opacity: 1))
        #expect(Color(svgString: "rgb(20%, 10%, 10%)") == Color(.sRGB, red: 51, green: 25.5, blue: 25.5, opacity: 1))
    }
}
