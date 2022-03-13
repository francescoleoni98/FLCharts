//
//  Labels.swift
//  FLCharts
//
//  Created by Francesco Leoni on 06/02/22.
//

import UIKit

class Labels {
    
    var labels: [Label] = []
    private var font: UIFont = .systemFont(ofSize: 15)
    
    convenience init(font: UIFont) {
        self.init()
        self.font = font
    }
    
    func editLabels(types: Label.Role..., handler: (Label) -> Void) {
        var labels: [Label] = []
        
        for type in types {
            labels.append(contentsOf: find(type: type))
        }
        
        for label in labels {
            handler(label)
        }
    }
    
    func find(type: Label.Role) -> [Label] {
        labels.filter { $0.type == type }
    }
    
    func add(_ label: Label) {
        if !labels.contains(label) {
            labels.append(label)
        }
    }
    
    func add(_ labels: [Label]) {
        self.labels.append(contentsOf: labels)
    }
    
    func drawLabels(color: UIColor = FLColor.black) {
        for label in labels {
            (label.text as NSString).draw(at: label.point, withAttributes: [.font: font,
                                                                            .foregroundColor: color])
        }
    }
    
    func clearLabels() {
        labels.removeAll()
    }
}
