//
//  ChartHighlightingDelegate.swift
//  FLCharts
//
//  Created by Francesco Leoni on 13/01/22.
//

import Foundation

/// The highlight view delegate that observes different states of the view.
public protocol ChartHighlightingDelegate: AnyObject {
    
    /// This method is called once the ``HighlightedView`` appears.
    func didBeginHighlighting()
    
    /// This method is called every time the user changes the highlighted cell and when the highlighted view appears.
    /// - Parameter cell: The cell that is currently highlighted.
    func didHighlight(cell: FLChartBarCell)
    
    /// This method is called once the ``HighlightedView`` disappears.
    func didEndHighlighting()
}

public extension ChartHighlightingDelegate {
    
    func didBeginHighlighting() { }
    func didHighlight(cell: FLChartBarCell) { }
    func didEndHighlighting() { }
}
