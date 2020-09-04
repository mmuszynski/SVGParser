//
//  File.swift
//  
//
//  Created by Mike Muszynski on 9/3/20.
//

import SwiftUI

struct SVGExamplesMasking_Previews: PreviewProvider {
    static var mask: some View {
        //<rect width="300" height="300" x="50" y="50" fill="white"/>
        //<circle cx="200" cy="200" r="100" fill="black" maskContentUnits="objectBoundingBox"/>
        
        ZStack {
            Rectangle()
                .fill(Color.white)
                .frame(width: 300, height: 300, alignment: .center)
            Circle()
                .fill(Color.black)
                .frame(width: 200, height: 200, alignment: .center)
        }.frame(width: 400, height: 400, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
    
    static var previews: some View {
        Rectangle()
            .frame(width: 400, height: 400, alignment: .center)
            .alphaMask(mask)
    }
}

extension View {
    func alphaMask<Mask>(_ mask: Mask) -> some View where Mask : View {
        mask
            .compositingGroup()
            .luminanceToAlpha()
    }
}
