//
//  File.swift
//  
//
//  Created by Mike Muszynski on 9/4/20.
//

import Foundation

enum SVGUnitTypes: Int {
    case unknown = 0, userSpaceOnUse, objectBoundingBox
}

internal extension CGFloat {
    init?(_ string: String) {
        guard let number = NumberFormatter().number(from: string) else { return nil }
        let float = CGFloat(truncating: number)
        self = float
    }
}

internal extension String {
    var asCGFloat: CGFloat? {
        return CGFloat(self)
    }
}
