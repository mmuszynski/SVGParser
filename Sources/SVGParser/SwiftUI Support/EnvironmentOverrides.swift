//
//  File.swift
//  SVGParser
//
//  Created by Mike Muszynski on 5/7/25.
//

import SwiftUI

typealias TapGestureOverride = (count: Int, action: () -> Void)

extension EnvironmentValues {
    /// Allows the fill color of an element with a given name to be overridden.
    ///
    /// - Bug: Inheritance doesn't work well in the library, and that can make this tricky to debug.
    @Entry var fillOverrides: [String: Color] = ["" : .black]
    
    @Entry var onTapOverrides: [String: TapGestureOverride] = [:]
}

extension View {
    @available(*, unavailable, renamed: "override(fillColor:forElementID:)")
    public func setFillOverride(_ fillColor: Color?, forElementID element: String) -> some View {
        transformEnvironment(\.fillOverrides) { overrides in
            overrides[element] = fillColor
        }
    }
    
    public func override(fillColor: Color?, forElementID element: String) -> some View {
        transformEnvironment(\.fillOverrides) { overrides in
            overrides[element] = fillColor
        }
    }
    
    public func onTapOfElement(named elementID: String, count: Int = 1, perform action: @escaping () -> Void) -> some View {
        transformEnvironment(\.onTapOverrides) { overrides in
            overrides[elementID] = (count: count, action: action)
        }
    }
}
