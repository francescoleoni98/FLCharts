//
//  FLLegend.swift
//  FLCharts
//
//  Created by Francesco Leoni on 17/01/22.
//

import UIKit

class FLLegend: FLIntrinsicCollectionView {
    
    private let config: ChartConfig
    private let chartData: ChartData
        
    public init(config: ChartConfig, chartData: ChartData) {
        self.config = config
        self.chartData = chartData
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

        delegate = self
        dataSource = self
        isScrollEnabled = false
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        register(FLLegendKeyCell.self, forCellWithReuseIdentifier: FLLegendKeyCell.identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FLLegend: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chartData.legendKeys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FLLegendKeyCell.identifier, for: indexPath) as? FLLegendKeyCell else { return UICollectionViewCell() }
        let key = chartData.legendKeys[indexPath.item]
        cell.configure(key: key.key, color: key.color)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let stringWidth = chartData.legendKeys[indexPath.item].key.size(withSystemFontSize: 13)
        return CGSize(width: stringWidth.width + 15 + 10 + 5, height: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
