//
//  ExampleExpansionMacros.swift
//  SVGParser
//
//  Created by Mike Muszynski on 5/21/25.
//

import Foundation
import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct SVGPreviewExpansion: ExpressionMacro {
    public static func expansion(of node: some SwiftSyntax.FreestandingMacroExpansionSyntax, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> SwiftSyntax.ExprSyntax {
        ExprSyntax(literal: "")
    }
}

@main
struct ExampleExpansionMacros: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        SVGPreviewExpansion.self,
    ]
}
