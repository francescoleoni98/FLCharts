//
//  FLLegend.swift
//  FLCharts
//
//  Created by Francesco Leoni on 17/01/22.
//

import UIKit

public class FLLegend: FLIntrinsicCollectionView {
    
    private let keys: [Key]
    private var formatter: FLFormatter
    private var maxCellWidth: CGFloat = 0
    
    public init(keys: [Key], formatter: FLFormatter = .decimal(2)) {
        self.keys = keys
        self.formatter = formatter
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
            
        for key in keys {
            let stringWidth = key.textWithValue(formatter: formatter).string.size(withSystemFontSize: 13).width
            
            if maxCellWidth < stringWidth {
                maxCellWidth = stringWidth
            }
        }
        
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

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keys.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FLLegendKeyCell.identifier, for: indexPath) as? FLLegendKeyCell else { return UICollectionViewCell() }
        let key = keys[indexPath.item]
        cell.configure(key: key, formatter: formatter)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: maxCellWidth + 15 + 5 + 5, height: 15)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
