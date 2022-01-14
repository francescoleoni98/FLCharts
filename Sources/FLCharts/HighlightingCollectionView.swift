//
//  HighlightingCollectionView.swift
//  FLCharts
//
//  Created by Francesco Leoni on 09/01/22.
//  Copyright © 2021 Francesco Leoni All rights reserved.
//

import UIKit

/// A collection view that displays an UIView when a cell is highlighted.
/// The user can swipe between cells and the ``HighlightedView`` will update its position and value.
open class HighlightingCollectionView: UnclippedTopCollectionView {
    
    /// A mock view of the collection view used to calculate the position of the highlighted view.
    private let mockView = UIView()
    
    internal var getChartData: (() -> ChartData)?
    
    /// The last index path that was highlighted.
    private var lastHighlightedIndexPath: IndexPath?
    
    /// The line that connects the highlighted view to the chart bar.
    private var lineIndicatorView: UIView?
    
    /// The configuration of the chart
    public var config: ChartConfig = ChartConfig()
    
    /// The view to display when a cell is highlighted.
    public var highlightedView: HighlightedView? {
        didSet {
            guard highlightedView != nil else { return }

            lineIndicatorView = UIView()
            configureHighlightView()
            configureLogTapGesture()
        }
    }
    
    internal weak var highlightingDelegate: ChartHighlightingDelegate?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        insertSubview(mockView, belowSubview: collectionView)
        mockView.isUserInteractionEnabled = false
        mockView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mockView.topAnchor.constraint(equalTo: topAnchor),
            mockView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mockView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -config.margin.bottom),
            mockView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configurations
    
    private func configureLogTapGesture() {
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongTap))
        longTapGesture.minimumPressDuration = 0.25
        collectionView.addGestureRecognizer(longTapGesture)
    }
    
    private func configureHighlightView() {
        if let highlightedView = highlightedView, let lineIndicatorView = lineIndicatorView {
            addSubview(highlightedView)
            insertSubview(lineIndicatorView, belowSubview: collectionView)
            
            highlightedView.isHidden = true
            highlightedView.frame = CGRect(origin: CGPoint(x: 0, y: -highlightedView.intrinsicContentSize.height - 5),
                                           size: highlightedView.intrinsicContentSize)
            
            lineIndicatorView.isHidden = true
            lineIndicatorView.layer.cornerRadius = 1
            lineIndicatorView.frame = CGRect(x: 0, y: -5, width: 2, height: 0)
            lineIndicatorView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            lineIndicatorView.backgroundColor = FLColors.darkGray
        }
    }
    
    // MARK: - Gestures
    
    @objc private func didLongTap(_ panGesture: UIPanGestureRecognizer) {
        let location: CGPoint = panGesture.location(in: collectionView)
        
        switch panGesture.state {
        case .began:
            collectionView.isScrollEnabled = false
            collectionView.isUserInteractionEnabled = false
            handleHighlight(at: location)
            highlightingDelegate?.didBeginHighlighting()
            
        case .changed:
            handleHighlight(at: location)
            
        case .ended, .cancelled:
            defer {
                self.lastHighlightedIndexPath = nil
            }
            
            collectionView.isScrollEnabled = true
            collectionView.isUserInteractionEnabled = true

            if let lastHighlightedIndexPath = lastHighlightedIndexPath {
                collectionView(didUnhighlightItemAt: lastHighlightedIndexPath)
            }
            highlightingDelegate?.didEndHighlighting()
            
        default: break
        }
    }
    
    private func handleHighlight(at location: CGPoint) {
        if let indexPath = collectionView.indexPathForItem(at: location) {
            if let lastHighlightedIndexPath = lastHighlightedIndexPath {
                if lastHighlightedIndexPath != indexPath {
                    collectionView(didUnhighlightItemAt: lastHighlightedIndexPath)
                    collectionView(didHighlightItemAt: indexPath)
                }
            } else {
                collectionView(didHighlightItemAt: indexPath)
            }
        }
    }
    
    // MARK: - Highlighting methods
    
    private func collectionView(didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ChartBarCell, let barData = cell.barData,
           let highlightedView = highlightedView, let lineIndicatorView = lineIndicatorView {
            highlightingDelegate?.didHighlight(cell: cell)
            
            let cellFrame = cell.convert(cell.bounds, to: self.mockView)
            
            highlightedView.update(with: Formatters.toDecimals(value: NSNumber(value: barData.total)))
            highlightedView.update(withChartData: getChartData?())
            highlightedView.update(withBarData: barData)
            highlightedView.frame.size = highlightedView.intrinsicContentSize
            highlightedView.isHidden = false
            
            lineIndicatorView.isHidden = false

            UIView.animate(withDuration: 0.25) {
                highlightedView.center.x = cellFrame.midX
                
                let highlightedViewFrame = highlightedView.convert(highlightedView.bounds, to: self.mockView)
                
                if highlightedViewFrame.minX < 0 {
                    highlightedView.frame.origin.x = 0
                }
                
                if highlightedViewFrame.maxX > self.mockView.frame.width {
                    highlightedView.frame.origin.x = self.mockView.frame.width - highlightedView.intrinsicContentSize.width
                }
                
                lineIndicatorView.center.x = cellFrame.midX
                lineIndicatorView.frame.size.height = self.collectionView.frame.height - self.config.margin.bottom - cell.barView.frame.height
            }
            
            self.lastHighlightedIndexPath = indexPath
            
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }
    
    private func collectionView(didUnhighlightItemAt indexPath: IndexPath) {
        if let highlightedView = highlightedView, let lineIndicatorView = lineIndicatorView {
            highlightedView.isHidden = true
            lineIndicatorView.isHidden = true
        }
    }
}
