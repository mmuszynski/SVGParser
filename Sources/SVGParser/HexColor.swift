//
//  Color.swift
//  SVGParser
//
//  Created by Mike Muszynski on 12/2/19.
//  Copyright © 2019 Mike Muszynski. All rights reserved.
//

import SwiftUI

extension Color {
    init(hex string: String) {
        let string: String = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines.union(CharacterSet(charactersIn: "#")))

        // Scanner creation
        let scanner = Scanner(string: string)

        guard string != "none" else {
            self = .clear
            return
        }
        guard let color = scanner.scanUInt64(representation: .hexadecimal) else { fatalError() }

        if string.count == 2 {
            let mask: Int = 0xFF
            let g: Int = Int(color) & mask
            let gray: Double = Double(g) / 255.0
            self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: 1)
        } else if string.count == 3 {
            var newString = ""
            for character in string {
                newString.append(character)
                newString.append(character)
            }
            
            self.init(hex: newString)
        } else if string.count == 4 {
            let mask: Int = 0x00FF

            let g: Int = Int(color >> 8) & mask
            let a: Int = Int(color) & mask

            let gray: Double = Double(g) / 255.0
            let alpha: Double = Double(a) / 255.0

            self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: alpha)

        } else if string.count == 6 {
            let mask = 0x0000FF
            let r: Int = Int(color >> 16) & mask
            let g: Int = Int(color >> 8) & mask
            let b: Int = Int(color) & mask

            let red: Double = Double(r) / 255.0
            let green: Double = Double(g) / 255.0
            let blue: Double = Double(b) / 255.0

            self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1)

        } else if string.count == 8 {
            let mask: Int = 0x000000FF
            let r: Int = Int(color >> 24) & mask
            let g: Int = Int(color >> 16) & mask
            let b: Int = Int(color >> 8) & mask
            let a: Int = Int(color) & mask

            let red: Double = Double(r) / 255.0
            let green: Double = Double(g) / 255.0
            let blue: Double = Double(b) / 255.0
            let alpha: Double = Double(a) / 255.0

            self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)

        } else {
            self.init(.sRGB, red: 1, green: 1, blue: 1, opacity: 1)
        }
    }
}

