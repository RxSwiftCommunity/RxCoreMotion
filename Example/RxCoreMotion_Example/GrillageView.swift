//
//  GrillageView.swift
//  RxCoreMotion_Example
//
//  Created by Carlos García on 23/05/16.
//  Copyright © 2016 RxSwiftCommunity - https://github.com/RxSwiftCommunity. All rights reserved.
//

import UIKit

class GrillageView: UIView {

    override func drawRect(rect: CGRect) {
        
        UIColor.lightGrayColor().setStroke()
        
        let centerX = CGRectGetMidX(rect)
        let centerY = CGRectGetMidY(rect)
        
        // center
        let bp1 = UIBezierPath()
        bp1.lineWidth = 1
        bp1.moveToPoint(CGPointMake(centerX, CGRectGetMinY(rect)))
        bp1.addLineToPoint(CGPointMake(centerX, CGRectGetMaxY(rect)))
        bp1.moveToPoint(CGPointMake(CGRectGetMinX(rect), centerY))
        bp1.addLineToPoint(CGPointMake(CGRectGetMaxX(rect), centerY))
        bp1.stroke()
        
        // 100 square
        let square1Rect = CGRectMake(centerX-100, centerY-100, 200, 200)
        let bp2 = UIBezierPath(ovalInRect: square1Rect)
        bp2.lineWidth = 1
        bp2.stroke()
        
        // 200 square
        let square2Rect = CGRectMake(centerX-200, centerY-200, 400, 400)
        let bp3 = UIBezierPath(ovalInRect: square2Rect)
        bp3.lineWidth = 1
        bp3.stroke()
        
        // 300 square
        let square3Rect = CGRectMake(centerX-300, centerY-300, 600, 600)
        let bp4 = UIBezierPath(ovalInRect: square3Rect)
        bp4.lineWidth = 1
        bp4.stroke()
        
        
        
    }
 

}
