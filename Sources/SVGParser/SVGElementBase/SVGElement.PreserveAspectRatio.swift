//
//  File.swift
//  
//
//  Created by Mike Muszynski on 8/28/20.
//

import Foundation

extension SVGElement {
    struct PreserveAspectRatio {
        static let `default` = PreserveAspectRatio()
        var align: Align = .xMidYMid
        var meetOrSlice: MeetOrSlice = .meet
        
        enum xAlign {
            case xMin
            case xMid
            case xMax
        }
        
        enum yAlign {
            case yMin
            case yMid
            case yMax
        }
        
        enum Align {
            //Alignment value
            //The alignment value indicates whether to force uniform scaling and, if so, the alignment method to use in case the aspect ratio of the viewBox doesn't match the aspect ratio of the viewport. The alignment value must be one of the following keywords:
            
            //Do not force uniform scaling. Scale the graphic content of the given element non-uniformly if necessary such that the element's bounding box exactly matches the viewport rectangle. Note that if <align> is none, then the optional <meetOrSlice> value is ignored.
            case none
            //Force uniform scaling.
            
            case some(_ x: xAlign, _ y: yAlign)
            
            //Align the <min-x> of the element's viewBox with the smallest X value of the viewport.
            //Align the <min-y> of the element's viewBox with the smallest Y value of the viewport.
            static let xMinYMin = Align.some(xAlign.xMin, yAlign.yMin)
            //Align the midpoint X value of the element's viewBox with the midpoint X value of the viewport.
            //Align the <min-y> of the element's viewBox with the smallest Y value of the viewport.
            static let xMidYMin = Align.some(xAlign.xMid, yAlign.yMin)
            //Align the <min-x>+<width> of the element's viewBox with the maximum X value of the viewport.
            //Align the <min-y> of the element's viewBox with the smallest Y value of the viewport.
            static let xMaxYMin = Align.some(xAlign.xMax, yAlign.yMin)
            //Align the <min-x> of the element's viewBox with the smallest X value of the viewport.
            //Align the midpoint Y value of the element's viewBox with the midpoint Y value of the viewport.
            static let xMinYMid = Align.some(xAlign.xMin, yAlign.yMid)
            //Align the midpoint X value of the element's viewBox with the midpoint X value of the viewport.
            //Align the midpoint Y value of the element's viewBox with the midpoint Y value of the viewport.
            static let xMidYMid = Align.some(xAlign.xMid, yAlign.yMid)
            //Align the <min-x>+<width> of the element's viewBox with the maximum X value of the viewport.
            //Align the midpoint Y value of the element's viewBox with the midpoint Y value of the viewport.
            static let xMaxYMid = Align.some(xAlign.xMax, yAlign.yMid)
            //Align the <min-x> of the element's viewBox with the smallest X value of the viewport.
            //Align the <min-y>+<height> of the element's viewBox with the maximum Y value of the viewport.
            static let xMinYMax = Align.some(xAlign.xMin, yAlign.yMax)
            //Align the midpoint X value of the element's viewBox with the midpoint X value of the viewport.
            //Align the <min-y>+<height> of the element's viewBox with the maximum Y value of the viewport.
            static let xMidYMax = Align.some(xAlign.xMid, yAlign.yMax)
            //Align the <min-x>+<width> of the element's viewBox with the maximum X value of the viewport.
            //Align the <min-y>+<height> of the element's viewBox with the maximum Y value of the viewport.
            static let xMaxYMax = Align.some(xAlign.xMax, yAlign.yMax)
        }
        
        enum MeetOrSlice {
            //Meet or slice reference
            //The meet or slice reference is optional and, if provided, must be one of the following keywords:
            
            /* ========================================================
            meet (the default) - Scale the graphic such that:
            aspect ratio is preserved
            the entire viewBox is visible within the viewport
            the viewBox is scaled up as much as possible, while still meeting the other criteria
            In this case, if the aspect ratio of the graphic does not match the viewport, some of the viewport will extend beyond the bounds of the viewBox (i.e., the area into which the viewBox will draw will be smaller than the viewport).
             ======================================================== */
            case meet
            
            /* ========================================================
            slice - Scale the graphic such that:
            aspect ratio is preserved
            the entire viewport is covered by the viewBox
            the viewBox is scaled down as much as possible, while still meeting the other criteria
            In this case, if the aspect ratio of the viewBox does not match the viewport, some of the viewBox will extend beyond the bounds of the viewport (i.e., the area into which the viewBox will draw is larger than the viewport).
             ======================================================== */
            case slice
        }
    }
}
