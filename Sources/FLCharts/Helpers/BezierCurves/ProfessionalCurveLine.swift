//
//  ProfessionalCurveLine.swift
//  FLCharts
//
//  Created by Francesco Leoni on 20/01/22.
//

import UIKit

class Line: UIBezierPath {
    
    init(points: [CGPoint]) {
        super.init()
        
        guard let first = points.first else { return }
        move(to: first)
        
        for point in points.dropFirst() {
            addLine(to: point)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ProfessionalCurveLine {
    
    private static var smoothness: CGFloat = 0.1
    
    public static func quadCurvedPath(data: [CGFloat], smoothness: CGFloat = 0.1, in rect: CGRect, showPoints: Bool = false) -> UIBezierPath {
        let points = data.enumerated().map { (index, entry) -> CGPoint in
            let step = rect.width / CGFloat(data.count - 1)
            let x = (step * CGFloat(index))
            let y = rect.height - (rect.height * (entry / (data.max() ?? 0)))
            return CGPoint(x: x, y: y)
        }
        
        return quadCurvedPath(data: points, smoothness: smoothness, showPoints: showPoints)
    }
    
    public static func quadCurvedPath(data: [CGPoint], smoothness: CGFloat = 0.1, showPoints: Bool = false) -> UIBezierPath {
        self.smoothness = smoothness
        
        let path = UIBezierPath()
        
        var p1 = data[0]
        path.move(to: p1)
        
        if showPoints {
            drawPoint(point: p1, color: UIColor.red, radius: 3)
        }
        
        if (data.count == 2) {
            path.addLine(to: data[1])
            return path
        }
        
        var oldControlP: CGPoint?
        
        for i in 1..<data.count {
            let p2 = data[i]
            
            if showPoints {
                drawPoint(point: p2, color: UIColor.red, radius: 3)
            }
            
            var p3: CGPoint?
            
            if i < data.count - 1 {
                p3 = data[i + 1]
            }
            
            let newControlP = controlPointForPoints(p1: p1, p2: p2, next: p3)
            
            path.addCurve(to: p2, controlPoint1: oldControlP ?? p1, controlPoint2: newControlP ?? p2)
            
            p1 = p2
            oldControlP = antipodalFor(point: newControlP, center: p2)
        }
        return path
    }
    
    /// located on the opposite side from the center point
    private static func antipodalFor(point: CGPoint?, center: CGPoint?) -> CGPoint? {
        guard let p1 = point, let center = center else {
            return nil
        }
        let newX = 2 * center.x - p1.x
        let diffY = abs(p1.y - center.y)
        let newY = center.y + diffY * (p1.y < center.y ? 1 : -1)
        
        return CGPoint(x: newX, y: newY)
    }
    
    /// halfway of two points
    private static func midPointForPoints(p1: CGPoint, p2: CGPoint) -> CGPoint {
        return CGPoint(x: (p1.x + p2.x) / 2, y: (p1.y + p2.y) / 2)
    }
    
    /// Find controlPoint2 for addCurve
    ///
    /// - Parameters:
    ///   - p1: first point of curve
    ///   - p2: second point of curve whose control point we are looking for
    ///   - next: predicted next point which will use antipodal control point for finded
    private static func controlPointForPoints(p1: CGPoint, p2: CGPoint, next p3: CGPoint?) -> CGPoint? {
        guard let p3 = p3 else { return nil }
        
        let leftMidPoint  = midPointForPoints(p1: p1, p2: p2)
        let rightMidPoint = midPointForPoints(p1: p2, p2: p3)
        
        var controlPoint = midPointForPoints(p1: leftMidPoint, p2: antipodalFor(point: rightMidPoint, center: p2)!)
        
        if p1.y.between(a: p2.y, b: controlPoint.y) {
            controlPoint.y = p1.y
        } else if p2.y.between(a: p1.y, b: controlPoint.y) {
            controlPoint.y = p2.y
        }
        
        let imaginContol = antipodalFor(point: controlPoint, center: p2)!
        
        if p2.y.between(a: p3.y, b: imaginContol.y) {
            controlPoint.y = p2.y
        }
        
        if p3.y.between(a: p2.y, b: imaginContol.y) {
            let diffY = abs(p2.y - p3.y)
            controlPoint.y = p2.y + diffY * (p3.y < p2.y ? 1 : -1)
        }
        
        // make lines easier
        controlPoint.x += (p2.x - p1.x) * smoothness
        
        return controlPoint
    }
    
    private static func drawPoint(point: CGPoint, color: UIColor, radius: CGFloat) {
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: point.x - radius, y: point.y - radius, width: radius * 2, height: radius * 2))
        color.setFill()
        ovalPath.fill()
    }
}

extension CGFloat {
    func between(a: CGFloat, b: CGFloat) -> Bool {
        return self >= Swift.min(a, b) && self <= Swift.max(a, b)
    }
}
