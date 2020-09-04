//
//  File.swift
//  
//
//  Created by Mike Muszynski on 9/3/20.
//

import Foundation
import SwiftUI

struct SVGExamplesRotations_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SVGImageView(image: .svg(named: "rotatedSquare"))
        }
    }
}
