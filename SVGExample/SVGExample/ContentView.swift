//
//  ContentView.swift
//  SVGExample
//
//  Created by Mike Muszynski on 12/3/19.
//  Copyright © 2019 Mike Muszynski. All rights reserved.
//

import SwiftUI
import SVGParser

struct ContentView: View {
    var body: some View {
        SVGImageView.testView.frame(width: 1000, height: 1000, alignment: .center)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
