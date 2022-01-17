//
//  NSLayoutConstraint+XT.swift
//  FLCharts
//
//  Created by Francesco Leoni on 16/01/22.
//

import UIKit

struct LayoutDirection: OptionSet {
    let rawValue: Int

    static let top = LayoutDirection(rawValue: 1 << 0)
    static let bottom = LayoutDirection(rawValue: 1 << 1)
    static let leading = LayoutDirection(rawValue: 1 << 2)
    static let trailing = LayoutDirection(rawValue: 1 << 3)

    static let horizontal: LayoutDirection = [.leading, .trailing]
    static let vertical: LayoutDirection = [.top, .bottom]

    static let all: LayoutDirection = [.horizontal, .vertical]
}

extension UILayoutPriority {
    static var almostRequired: UILayoutPriority {
        return .required - 1
    }
}

extension NSLayoutConstraint {
    func withPriority(_ new: UILayoutPriority) -> NSLayoutConstraint {
        priority = new
        return self
    }
}

extension UIView {
    
    @discardableResult
    func constraints(equalTo other: UIView, directions: LayoutDirection = .all,
                     priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        var constraints: [NSLayoutConstraint] = []
        if directions.contains(.top) {
            constraints.append(topAnchor.constraint(equalTo: other.topAnchor).withPriority(priority))
        }
        if directions.contains(.leading) {
            constraints.append(leadingAnchor.constraint(equalTo: other.leadingAnchor).withPriority(priority))
        }
        if directions.contains(.bottom) {
            constraints.append(bottomAnchor.constraint(equalTo: other.bottomAnchor).withPriority(priority))
        }
        if directions.contains(.trailing) {
            constraints.append(trailingAnchor.constraint(equalTo: other.trailingAnchor).withPriority(priority))
        }
        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    @discardableResult
    func constraints(equalTo layoutGuide: UILayoutGuide, directions: LayoutDirection = .all,
                     priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false

        var constraints: [NSLayoutConstraint] = []
        if directions.contains(.top) {
            constraints.append(topAnchor.constraint(equalTo: layoutGuide.topAnchor).withPriority(priority))
        }
        if directions.contains(.leading) {
            constraints.append(leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).withPriority(priority))
        }
        if directions.contains(.bottom) {
            constraints.append(bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).withPriority(priority))
        }
        if directions.contains(.trailing) {
            constraints.append(trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).withPriority(priority))
        }
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
}
