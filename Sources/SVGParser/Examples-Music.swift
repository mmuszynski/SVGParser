//
//  File.swift
//
//
//  Created by Mike Muszynski on 9/3/20.
//

import SwiftUI

struct SVGExampleMusic_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SVGImageView(image: .svg(named: "opusClefC"))
            SVGImageView(image: .svg(named: "opusFlat"))
        }
        .previewLayout(.sizeThatFits)
    }
}
