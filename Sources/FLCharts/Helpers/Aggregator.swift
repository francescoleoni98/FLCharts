//
//  Aggregator.swift
//  FLCharts
//
//  Created by Francesco Leoni on 25/02/22.
//

import UIKit

class Aggregator {
    
    let points: [CGPoint]
    var diameter: CGFloat = 0
    
    init(points: [CGPoint]) {
        self.points = points
    }
    
    func aggregate(diameter: CGFloat) -> [(point: CGPoint, numberOfAggregations: Int)] {
        self.diameter = diameter
        var aggregatedPoints: [(CGPoint, Int)] = []
        var pointsToSkip: [CGPoint] = []

        for point in points {
            guard !pointsToSkip.contains(point) else { continue }
            
            let pointsToAggregate = points.filter { pointToIntersect in
                rectFor(point).intersects(rectFor(pointToIntersect))
            }

            let centerPoint = pointsToAggregate.centroid() ?? point
            aggregatedPoints.append((centerPoint, pointsToAggregate.count))
            pointsToSkip.append(contentsOf: pointsToAggregate)
        }
        
        return aggregatedPoints
    }
    
    private func rectFor(_ point: CGPoint) -> CGRect {
        let radius = diameter.half
        return CGRect(x: point.x - radius, y: point.y - radius, width: diameter, height: diameter)
    }
}

extension Array where Element == CGPoint {
    
    /// The center of the polygon created by points.
    func centroid() -> CGPoint? {
        guard let firstCoordinate = first else { return nil }
        
        guard self.count > 1 else { return firstCoordinate }
        
        var minX = firstCoordinate.x
        var maxX = firstCoordinate.x
        var minY = firstCoordinate.y
        var maxY = firstCoordinate.y
        
        for i in 1 ..< self.count {
            let current = self[i]
            if minX > current.x {
                minX = current.x
            } else if maxX < current.x {
                maxX = current.x
            } else if minY > current.y {
                minY = current.y
            } else if maxY < current.y {
                maxY = current.y
            }
        }
        
        let centerX = minX + ((maxX - minX).half)
        let centerY = minY + ((maxY - minY).half)
        return CGPoint(x: centerX, y: centerY)
    }
}
