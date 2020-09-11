//
//  File.swift
//  
//
//  Created by Mike Muszynski on 9/4/20.
//

import Foundation
import CoreGraphics

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
    
    func asCGFloat(in dimension: CGFloat) -> CGFloat? {
        if let float = self.asCGFloat { return float }
        
        //check for percentage
        let percentage = self.replacingOccurrences(of: "%", with: "")
        if self != percentage, let float = percentage.asCGFloat {
            return float * dimension / 100
        }
        
        return nil
    }
}
