//
//  SliceShape.swift
//  FLCharts
//
//  Created by Francesco Leoni on 28/02/22.
//

import UIKit

class SliceShape: UIView {
        
    var data: FLPiePlotable
    private let shapeLayer = CAShapeLayer()
    private var animationDuration: TimeInterval = 0.75
    
    init(data: FLPiePlotable, width: FLPieBorder, color: UIColor, rect: CGRect, from: CGFloat, to: CGFloat, animated: Bool) {
        self.data = data
        super.init(frame: rect)
        let path = UIBezierPath(ovalIn: CGRect(origin: .zero, size: rect.size))
        shapeLayer.path = path.cgPath
        shapeLayer.strokeStart = from
        shapeLayer.strokeEnd = from
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.setAffineTransform(CGAffineTransform(rotationAngle: .degrees(-90)).translatedBy(x: -rect.width, y: 0))
        
        switch width {
        case .full: shapeLayer.lineWidth = rect.midY
        case .width(let width): shapeLayer.lineWidth = min(width, rect.midY)
        }
        
        layer.addSublayer(shapeLayer)
        animateShape(from: from, to: to, animated: animated)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func animateShape(from: CGFloat, to: CGFloat, animated: Bool) {
        if animated {
            animate("strokeStart") { animation in
                animation.fromValue = shapeLayer.strokeStart
                animation.toValue = from
                animation.completionBlock { _, _ in
                    self.shapeLayer.strokeStart = from
                }
            }
            
            animate("strokeEnd") { animation in
                animation.fromValue = shapeLayer.strokeEnd
                animation.toValue = to
                animation.completionBlock { _, _ in
                    self.shapeLayer.strokeEnd = to
                }
            }
        } else {
            self.shapeLayer.strokeStart = from
            self.shapeLayer.strokeEnd = to
        }
    }
    
    private func animate(_ name: String, configure: (CABasicAnimation) -> Void) {
        let animation = CABasicAnimation(keyPath: name)
        animation.duration = animationDuration
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        configure(animation)
        shapeLayer.add(animation, forKey: name)
    }
}
