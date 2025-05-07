//
//  File.swift
//  SVGParser
//
//  Created by Mike Muszynski on 5/7/25.
//

import SwiftUI

extension EnvironmentValues {
    @Entry var fillOverrides: [String: Color] = ["" : .black]
}

extension View {
    public func setFillOverride(_ fillColor: Color?, forElementID element: String) -> some View {
        transformEnvironment(\.fillOverrides) { overrides in
            overrides[element] = fillColor
        }
    }
}
