//
//  Color.swift
//  SVGParser
//
//  Created by Mike Muszynski on 12/2/19.
//  Copyright © 2019 Mike Muszynski. All rights reserved.
//

import SwiftUI
import RegexBuilder

extension Color {
    public init?(svgString string: String) {
        if let color = Color.hexString(string) {
            //three digit hex
            //six digit hex
            self = color
            return
        } else if let color = Color.integerFunctionalString(string) {
            //integer functional
            self = color
            return
        } else if let color = Color.floatFunctionalString(string) {
            //float functional
            self = color
            return
        } else if let color = Color.cssKeyword(string) {
            //color keyword
            self = color
            return
        }
        
        return nil
    }
    
    static private func hexString(_ string: String) -> Self? {
        let string: String = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines.union(CharacterSet(charactersIn: "#")))
        
        // Scanner creation
        let scanner = Scanner(string: string)
        
        guard string != "none" else {
            return .clear
        }
        guard let color = scanner.scanUInt64(representation: .hexadecimal) else {
            print("Unable to scan hex color: \(string)")
            return nil
        }
        
        if string.count == 2 {
            let mask: Int = 0xFF
            let g: Int = Int(color) & mask
            let gray: Double = Double(g) / 255.0
            return Color(.sRGB, red: gray, green: gray, blue: gray, opacity: 1)
        } else if string.count == 3 {
            var newString = ""
            for character in string {
                newString.append(character)
                newString.append(character)
            }
            
            return Color.hexString(newString)
        } else if string.count == 4 {
            let mask: Int = 0x00FF
            
            let g: Int = Int(color >> 8) & mask
            let a: Int = Int(color) & mask
            
            let gray: Double = Double(g) / 255.0
            let alpha: Double = Double(a) / 255.0
            
            return Color(.sRGB, red: gray, green: gray, blue: gray, opacity: alpha)
            
        } else if string.count == 6 {
            let mask = 0x0000FF
            let r: Int = Int(color >> 16) & mask
            let g: Int = Int(color >> 8) & mask
            let b: Int = Int(color) & mask
            
            let red: Double = Double(r) / 255.0
            let green: Double = Double(g) / 255.0
            let blue: Double = Double(b) / 255.0
            
            return Color(.sRGB, red: red, green: green, blue: blue, opacity: 1)
            
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
            
            return Color(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
            
        } else {
            return Color(.sRGB, red: 1, green: 1, blue: 1, opacity: 1)
        }
    }
    
    static func cssKeyword(_ name: String) -> Color? {
        if let hex = Color.cssColors.filter( { $0.key.localizedCaseInsensitiveCompare(name) == .orderedSame } ).first?.value {
            return Self.hexString(hex)
        }
        return nil
    }
    
    static func integerFunctionalString(_ string: String) -> Color? {
        let regex = Regex {
            Optionally("rgb")
            "("
            Capture {
                OneOrMore {
                    OneOrMore(.digit)
                    Optionally {
                        OneOrMore(.whitespace.union(CharacterClass.anyOf(",")))
                    }
                }
            }
            ")"
        }

        if let match = string.firstMatch(of: regex)?.output.1 {
            var components = match.components(separatedBy: CharacterSet(charactersIn: ",% ")).compactMap(Double.init)
            guard components.count > 2 else { return nil }
            
            components.reverse()
            
            return Color(.sRGB,
                         red: (components.popLast() ?? 255) / 255,
                         green: (components.popLast() ?? 255) / 255,
                         blue: (components.popLast() ?? 255) / 255,
                         opacity: (components.popLast() ?? 255) / 255)
        }

        return nil
    }
    
    static func floatFunctionalString(_ string: String) -> Color? {
        let regex = Regex {
            Optionally("rgb")
            "("
            Capture {
                OneOrMore {
                    OneOrMore(.digit)
                    Optionally(".")
                    OneOrMore(.digit)
                    "%"
                    Optionally {
                        OneOrMore(.whitespace.union(CharacterClass.anyOf(",")))
                    }
                }
            }
            ")"
        }

        if let match = string.firstMatch(of: regex)?.output.1 {
            var components = match.components(separatedBy: CharacterSet(charactersIn: ",% ")).compactMap(Double.init)
            guard components.count > 2 else { return nil }
            
            components = components.map { $0 * 255 / 100 }.reversed()
            print(components)
            
            return Color(.sRGB,
                         red: (components.popLast() ?? 255),
                         green: (components.popLast() ?? 255),
                         blue: (components.popLast() ?? 255),
                         opacity: (components.popLast()) ?? 1)
        }

        return nil    }
}

extension Color {
    static let cssColors: [String: String] = {
        ["Black": "#000000",
        "Navy": "#000080",
        "DarkBlue": "#00008B",
        "MediumBlue": "#0000CD",
        "Blue": "#0000FF",
        "DarkGreen": "#006400",
        "Green": "#008000",
        "Teal": "#008080",
        "DarkCyan": "#008B8B",
        "DeepSkyBlue": "#00BFFF",
        "DarkTurquoise": "#00CED1",
        "MediumSpringGreen": "#00FA9A",
        "Lime": "#00FF00",
        "SpringGreen": "#00FF7F",
        "Aqua": "#00FFFF",
        "Cyan": "#00FFFF",
        "MidnightBlue": "#191970",
        "DodgerBlue": "#1E90FF",
        "LightSeaGreen": "#20B2AA",
        "ForestGreen": "#228B22",
        "SeaGreen": "#2E8B57",
        "DarkSlateGray": "#2F4F4F",
        "DarkSlateGrey": "#2F4F4F",
        "LimeGreen": "#32CD32",
        "MediumSeaGreen": "#3CB371",
        "Turquoise": "#40E0D0",
        "RoyalBlue": "#4169E1",
        "SteelBlue": "#4682B4",
        "DarkSlateBlue": "#483D8B",
        "MediumTurquoise": "#48D1CC",
        "Indigo": "#4B0082",
        "DarkOliveGreen": "#556B2F",
        "CadetBlue": "#5F9EA0",
        "CornflowerBlue": "#6495ED",
        "RebeccaPurple": "#663399",
        "MediumAquaMarine": "#66CDAA",
        "DimGray": "#696969",
        "DimGrey": "#696969",
        "SlateBlue": "#6A5ACD",
        "OliveDrab": "#6B8E23",
        "SlateGray": "#708090",
        "SlateGrey": "#708090",
        "LightSlateGray": "#778899",
        "LightSlateGrey": "#778899",
        "MediumSlateBlue": "#7B68EE",
        "LawnGreen": "#7CFC00",
        "Chartreuse": "#7FFF00",
        "Aquamarine": "#7FFFD4",
        "Maroon": "#800000",
        "Purple": "#800080",
        "Olive": "#808000",
        "Gray": "#808080",
        "Grey": "#808080",
        "SkyBlue": "#87CEEB",
        "LightSkyBlue": "#87CEFA",
        "BlueViolet": "#8A2BE2",
        "DarkRed": "#8B0000",
        "DarkMagenta": "#8B008B",
        "SaddleBrown": "#8B4513",
        "DarkSeaGreen": "#8FBC8F",
        "LightGreen": "#90EE90",
        "MediumPurple": "#9370DB",
        "DarkViolet": "#9400D3",
        "PaleGreen": "#98FB98",
        "DarkOrchid": "#9932CC",
        "YellowGreen": "#9ACD32",
        "Sienna": "#A0522D",
        "Brown": "#A52A2A",
        "DarkGray": "#A9A9A9",
        "DarkGrey": "#A9A9A9",
        "LightBlue": "#ADD8E6",
        "GreenYellow": "#ADFF2F",
        "PaleTurquoise": "#AFEEEE",
        "LightSteelBlue": "#B0C4DE",
        "PowderBlue": "#B0E0E6",
        "FireBrick": "#B22222",
        "DarkGoldenRod": "#B8860B",
        "MediumOrchid": "#BA55D3",
        "RosyBrown": "#BC8F8F",
        "DarkKhaki": "#BDB76B",
        "Silver": "#C0C0C0",
        "MediumVioletRed": "#C71585",
        "IndianRed": "#CD5C5C",
        "Peru": "#CD853F",
        "Chocolate": "#D2691E",
        "Tan": "#D2B48C",
        "LightGray": "#D3D3D3",
        "LightGrey": "#D3D3D3",
        "Thistle": "#D8BFD8",
        "Orchid": "#DA70D6",
        "GoldenRod": "#DAA520",
        "PaleVioletRed": "#DB7093",
        "Crimson": "#DC143C",
        "Gainsboro": "#DCDCDC",
        "Plum": "#DDA0DD",
        "BurlyWood": "#DEB887",
        "LightCyan": "#E0FFFF",
        "Lavender": "#E6E6FA",
        "DarkSalmon": "#E9967A",
        "Violet": "#EE82EE",
        "PaleGoldenRod": "#EEE8AA",
        "LightCoral": "#F08080",
        "Khaki": "#F0E68C",
        "AliceBlue": "#F0F8FF",
        "HoneyDew": "#F0FFF0",
        "Azure": "#F0FFFF",
        "SandyBrown": "#F4A460",
        "Wheat": "#F5DEB3",
        "Beige": "#F5F5DC",
        "WhiteSmoke": "#F5F5F5",
        "MintCream": "#F5FFFA",
        "GhostWhite": "#F8F8FF",
        "Salmon": "#FA8072",
        "AntiqueWhite": "#FAEBD7",
        "Linen": "#FAF0E6",
        "LightGoldenRodYellow": "#FAFAD2",
        "OldLace": "#FDF5E6",
        "Red": "#FF0000",
        "Fuchsia": "#FF00FF",
        "Magenta": "#FF00FF",
        "DeepPink": "#FF1493",
        "OrangeRed": "#FF4500",
        "Tomato": "#FF6347",
        "HotPink": "#FF69B4",
        "Coral": "#FF7F50",
        "DarkOrange": "#FF8C00",
        "LightSalmon": "#FFA07A",
        "Orange": "#FFA500",
        "LightPink": "#FFB6C1",
        "Pink": "#FFC0CB",
        "Gold": "#FFD700",
        "PeachPuff": "#FFDAB9",
        "NavajoWhite": "#FFDEAD",
        "Moccasin": "#FFE4B5",
        "Bisque": "#FFE4C4",
        "MistyRose": "#FFE4E1",
        "BlanchedAlmond": "#FFEBCD",
        "PapayaWhip": "#FFEFD5",
        "LavenderBlush": "#FFF0F5",
        "SeaShell": "#FFF5EE",
        "Cornsilk": "#FFF8DC",
        "LemonChiffon": "#FFFACD",
        "FloralWhite": "#FFFAF0",
        "Snow": "#FFFAFA",
        "Yellow": "#FFFF00",
        "LightYellow": "#FFFFE0",
        "Ivory": "#FFFFF0",
        "White": "#FFFFFF"]
    }()
}
