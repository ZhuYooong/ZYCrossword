//
//  TrelloFunction.swift
//  TrelloNavigation
//
//  Created by 宋宋 on 15/11/12.
//  Copyright © 2015年 Qing. All rights reserved.
//

import UIKit

/// Taste Function Programming
// TODO: Combine CGPoint
typealias TransformPoint = (CGPoint) -> CGPoint
func addX(x: CGFloat) -> TransformPoint {
    return { point in
        return CGPoint(x: point.x + x, y: point.y)
    }
}
func addY(y: CGFloat) -> TransformPoint {
    return { point in
        return CGPoint(x: point.x, y: point.y + y)
    }
}
func addXY(x: CGFloat, y: CGFloat) -> TransformPoint {
    return { point in
        return addY(y: y)( addX(x: x)(point) )
    }
}
extension UIBezierPath {
    func addSquare(center: CGPoint, width: CGFloat) {
        self.move(to: addXY(x: center.x - width / 2.0, y: center.y - width / 2.0)(center))
        self.addLine(to: addXY(x: center.x + width / 2.0, y: center.y - width / 2.0)(center))
        self.addLine(to: addXY(x: center.x + width / 2.0, y: center.y + width / 2.0)(center))
        self.addLine(to: addXY(x: center.x - width / 2.0, y: center.y + width / 2.0)(center))
        self.addLine(to: addXY(x: center.x - width / 2.0, y: center.y - width / 2.0)(center))
    }
}
