//
//  PlayfulCurveLine.swift
//  FLCharts
//
//  Created by Francesco Leoni on 20/01/22.
//

import UIKit

struct PlayfulCurveLine {
    
    public static func createCurve(from data: [CGFloat], in rect: CGRect, smoothness: CGFloat = 0.1, addZeros: Bool = false) -> UIBezierPath {
        let points = data.enumerated().map { (index, entry) -> CGPoint in
            let step = rect.width / CGFloat(data.count - 1)
            let x = (step * CGFloat(index))
            let y = rect.height - (rect.height * (entry / (data.max() ?? 0)))
            return CGPoint(x: x, y: y)
        }
        
        return createCurve(from: points, smoothness: smoothness, addZeros: addZeros)
    }
    
    /// Create UIBezierPath.
    ///
    /// - Parameters:
    ///   - points: The points.
    ///   - smoothness: The smoothness: 0 - no smooth at all, 1 - maximum smoothness
    public static func createCurve(from points: [CGPoint], smoothness: CGFloat = 0.5, addZeros: Bool = false) -> UIBezierPath {
        let path = UIBezierPath()
        guard points.count > 0 else { return path }
        
        var prevPoint: CGPoint = points.first!
        
        if addZeros {
            path.move(to: .zero)
            path.addLine(to: points[0])
        } else {
            path.move(to: points[0])
        }
        
        for i in 1..<points.count {
            let cp = controlPoints(p1: prevPoint, p2: points[i], smoothness: smoothness)
            path.addCurve(to: points[i], controlPoint1: cp.0, controlPoint2: cp.1)
            prevPoint = points[i]
        }
        
        if addZeros {
            path.addLine(to: CGPoint(x: prevPoint.x, y: 0))
        }
        
        return path
    }
    
    /// Create control points with given smoothness
    ///
    /// - Parameters:
    ///   - p1: the first point
    ///   - p2: the second point
    ///   - smoothness: the smoothness: 0 - no smooth at all, 1 - maximum smoothness
    /// - Returns: two control points
    private static func controlPoints(p1: CGPoint, p2: CGPoint, smoothness: CGFloat) -> (CGPoint, CGPoint) {
        let cp1: CGPoint!
        let cp2: CGPoint!
        let percent = min(1, max(0, smoothness))
        
        do {
            var cp = p2
            // Apply smoothness
            let x0 = max(p1.x, p2.x)
            let x1 = min(p1.x, p2.x)
            let x = x0 + (x1 - x0) * percent
            cp.x = x
            cp2 = cp
        }
        
        do {
            var cp = p1
            // Apply smoothness
            let x0 = min(p1.x, p2.x)
            let x1 = max(p1.x, p2.x)
            let x = x0 + (x1 - x0) * percent
            cp.x = x
            cp1 = cp
        }
        
        return (cp1, cp2)
    }
}
