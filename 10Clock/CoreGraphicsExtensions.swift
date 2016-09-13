//
//  CoreGraphicsExtensions.swift
//  SwiftClock
//
//  Created by Joseph Daniels on 01/09/16.
//  Copyright © 2016 Joseph Daniels. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    func modified(withAdditionalHue hue: CGFloat, additionalSaturation: CGFloat, additionalBrightness: CGFloat) -> UIColor {
        
        var currentHue: CGFloat = 0.0
        var currentSaturation: CGFloat = 0.0
        var currentBrigthness: CGFloat = 0.0
        var currentAlpha: CGFloat = 0.0
        
        if self.getHue(&currentHue, saturation: &currentSaturation, brightness: &currentBrigthness, alpha: &currentAlpha){
            return UIColor(hue: currentHue + hue,
                           saturation: currentSaturation + additionalSaturation,
                           brightness: currentBrigthness + additionalBrightness,
                           alpha: currentAlpha)
        } else {
            return self
        }
    }
}


extension FloatingPointType{
    var isBad:Bool{ return isNaN || isInfinite }
    var checked:Self{
        guard !isBad && !isInfinite else {
            fatalError("bad number!")
        }
        return self
    }

}

typealias Angle = CGFloat
func df() -> CGFloat {
    return    CGFloat(drand48()).checked
}
func clockDescretization(val: CGFloat) -> CGFloat{
    let min:Double  = 0
    let max:Double = 2 * Double(M_PI)
    let steps:Double = 144
    let stepSize = (max - min) / steps
    let nsf = floor(Double(val) / stepSize)
    let rest = Double(val) - stepSize * nsf
    return CGFloat(rest > stepSize / 2 ? stepSize * (nsf + 1) : stepSize * nsf).checked
    
}
extension CALayer {
    func doDebug(){
        self.borderColor = UIColor(hue: df() , saturation: df(), brightness: 1, alpha: 1).CGColor
        self.borderWidth = 2;
        self.sublayers?.forEach({$0.doDebug()})
    }
}
extension CGSize{
    var hasNaN:Bool{return width.isBad || height.isBad }
    var checked:CGSize{
        guard !hasNaN else {
            fatalError("bad number!")
        }
        return self
    }
}
extension CGRect{
    var center:CGPoint { return CGPoint(x:midX, y: midY).checked}
    var hasNaN:Bool{return size.hasNaN || origin.hasNaN}
    var checked:CGRect{
        guard !hasNaN else {
            fatalError("bad number!")
        }
        return self
    }

}
extension CGPoint{
    var vector:CGVector { return CGVector(dx: x, dy: y).checked}
    var checked:CGPoint{
        guard !hasNaN else {
            fatalError("bad number!")
        }
        return self
    }
    var hasNaN:Bool{return x.isBad || y.isBad }
}
extension CGVector{
    var hasNaN:Bool{return dx.isBad || dy.isBad}
    var checked:CGVector{
        guard !hasNaN else {
            fatalError("bad number!")
        }
        return self
    }

    static var root:CGVector{ return CGVector(dx:1, dy:0).checked}
    var magnitude:CGFloat { return sqrt(pow(dx, 2) + pow(dy,2)).checked}
    var normalized: CGVector { return CGVector(dx:dx / magnitude,  dy: dy / magnitude).checked }
    var point:CGPoint { return CGPoint(x: dx, y: dy).checked}
    func rotate(angle:Angle) -> CGVector { return CGVector(dx: dx * cos(angle) - dy * sin(angle), dy: dx * sin(angle) + dy * cos(angle) ).checked}
    
    func dot(vec2:CGVector) -> CGFloat { return (dx * vec2.dx + dy * vec2.dy).checked}
    func add(vec2:CGVector) -> CGVector { return CGVector(dx:dx + vec2.dx , dy: dy + vec2.dy).checked}
    func cross(vec2:CGVector) -> CGFloat { return (dx * vec2.dy - dy * vec2.dx).checked}
    
    init( from:CGPoint, to:CGPoint){
        guard !from.hasNaN && !to.hasNaN  else {
                fatalError("Nan point!")
            }
        dx = to.x - from.x
        dy = to.y - from.y
        _ = self.checked
    }
    
    init(angle:Angle){
        let compAngle = angle < 0 ? (angle + CGFloat(2 * M_PI)) : angle
        dx = cos(compAngle.checked)
        dy = sin(compAngle.checked)
        _ = self.checked
    }
    static func theta(vec1:CGVector, vec2:CGVector) -> Angle{
        return acos(vec1.normalized.dot(vec2.normalized)).checked
    }
    static func signedTheta(vec1:CGVector, vec2:CGVector) -> Angle{
        
        return (vec1.normalized.cross(vec2.normalized) > 0 ?  -1 : 1) * theta(vec1.normalized, vec2: vec2.normalized).checked
    }
    
}
