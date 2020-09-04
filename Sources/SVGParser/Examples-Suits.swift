//
//  File.swift
//  
//
//  Created by Mike Muszynski on 9/3/20.
//

import SwiftUI

struct SVGExamples_Suits_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SVGImageView(image: .svg(named: "Spade"))
            SVGImageView(image: .svg(named: "Club"))
        }
    }
}
