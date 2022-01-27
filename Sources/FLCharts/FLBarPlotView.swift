//
//  FLBarPlotView.swift
//  FLCharts
//
//  Created by Francesco Leoni on 18/01/22.
//

import UIKit

/// A bar chart that displays one or more bars.
/// It takes a ``ChartBar`` in the initializer that allows to provide a custom bar cell.
internal final class FLBarPlotView: UIView, FLPlotView {

    private let collectionView = HighlightingCollectionView()
        
    /// The configuration of the chart.
    internal var config: FLChartConfig = FLChartConfig() {
        didSet {
            collectionView.config = config
        }
    }
    
    internal var barConfig: FLBarConfig = FLBarConfig()
        
    /// Whether the bars are animated.
    internal var animated: Bool = true
    
    /// Whether to show the axes ticks.
    internal var showTicks: Bool = true
    
    /// Whether the chart should scroll horizontally.
    internal var shouldScroll: Bool = true
    
    /// The data to show in the chart.
    internal private(set) var chartData: FLChartData

    /// The bar view to use in the chart.
    private let bar: ChartBar.Type
        
    private var cellWidth: CGFloat { barConfig.width + barConfig.spacing }

    internal weak var highlightingDelegate: ChartHighlightingDelegate? {
        didSet {
            collectionView.highlightingDelegate = highlightingDelegate
        }
    }

    // MARK: - Inits
        
    /// Creates a bar chart with the provided chart data.
    ///
    /// If you need a different bar style provide a ``ChartBar``.
    ///
    /// If you need a highlight behaviour provide a ``HighlightedView``.
    internal init(data: FLChartData, bar: ChartBar.Type = FLPlainChartBar.self, highlightView: HighlightedView? = nil) {
        self.bar = bar
        self.chartData = data
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.configureCollectionView()
        self.collectionView.getChartData = { data }
        self.collectionView.highlightedView = highlightView

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.animated = false
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Updates the values of the chart.
    internal func updateData(_ data: [PlotableData]) {
        self.chartData.dataEntries = data
        self.collectionView.reloadData()
    }

    // MARK: - Configurations
    
    private func configureCollectionView() {
        addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FLChartBarCell.self, forCellWithReuseIdentifier: FLChartBarCell.identifier)
        collectionView.constraints(equalTo: self, directions: .all)
    }
}

// MARK: - UICollectionView Data Source

extension FLBarPlotView: UICollectionViewDataSource {
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chartData.dataEntries.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FLChartBarCell.identifier, for: indexPath) as! FLChartBarCell
        cell.config = config
        cell.barConfig = barConfig
        cell.shouldShowTicks = showTicks
        cell.configure(withBar: bar.init())
        cell.barView.backgroundColor = chartData.legendKeys.first?.color.mainColor

        if let max = chartData.maxYValue(forType: .bar()) {
            let barData = chartData.dataEntries[indexPath.item]
            let ratio = max == 0 ? 0 : barData.total / max
            
            cell.setBarHeight(ratio, barData: barData, legendKeys: chartData.legendKeys, animated: animated)
        }
        
        if config.granularityX == 0 {
            cell.xAxisLabel.isHidden = true
        } else if indexPath.item % config.granularityX != 0 {
            cell.xAxisLabel.isHidden = true
        }
        
        return cell
    }
}

// MARK: - UICollectionView Flow Layout

extension FLBarPlotView: UICollectionViewDelegateFlowLayout {
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if shouldScroll {
            return CGSize(width: cellWidth, height: collectionView.frame.height)
        } else {
            let numberOfBars = CGFloat(chartData.dataEntries.count)
            let cellWidth = collectionView.frame.width / numberOfBars
            return CGSize(width: cellWidth, height: collectionView.frame.height)
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
