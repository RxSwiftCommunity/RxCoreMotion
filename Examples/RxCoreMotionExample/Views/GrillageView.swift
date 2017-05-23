//
//  GrillageView.swift
//  RxCoreMotion_Example
//
//  Created by Carlos García on 23/05/16.
//  Copyright © 2016 RxSwiftCommunity - https://github.com/RxSwiftCommunity. All rights reserved.
//

import UIKit

class GrillageView: UIView {

    override func draw(_ rect: CGRect) {
        
        UIColor.lightGray.setStroke()
        
        let centerX = rect.midX
        let centerY = rect.midY
        
        // center
        let bp1 = UIBezierPath()
        bp1.lineWidth = 1
        bp1.move(to: CGPoint(x: centerX, y: rect.minY))
        bp1.addLine(to: CGPoint(x: centerX, y: rect.maxY))
        bp1.move(to: CGPoint(x: rect.minX, y: centerY))
        bp1.addLine(to: CGPoint(x: rect.maxX, y: centerY))
        bp1.stroke()
        
        // 100 square
        let square1Rect = CGRect(x: centerX-100, y: centerY-100, width: 200, height: 200)
        let bp2 = UIBezierPath(ovalIn: square1Rect)
        bp2.lineWidth = 1
        bp2.stroke()
        
        // 200 square
        let square2Rect = CGRect(x: centerX-200, y: centerY-200, width: 400, height: 400)
        let bp3 = UIBezierPath(ovalIn: square2Rect)
        bp3.lineWidth = 1
        bp3.stroke()
        
        // 300 square
        let square3Rect = CGRect(x: centerX-300, y: centerY-300, width: 600, height: 600)
        let bp4 = UIBezierPath(ovalIn: square3Rect)
        bp4.lineWidth = 1
        bp4.stroke()
        
        
        
    }
 

}
