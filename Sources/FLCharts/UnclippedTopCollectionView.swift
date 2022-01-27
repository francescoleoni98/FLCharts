//
//  UnclippedTopCollectionView.swift
//  FLCharts
//
//  Created by Francesco Leoni on 09/01/22.
//  Copyright © 2021 Francesco Leoni All rights reserved.
//

import UIKit

/// A horizontal collection view with the top edge unclipped.
open class UnclippedTopCollectionView: UIView {
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    private let clipMask = CALayer()

    var delegate: UICollectionViewDelegate? {
        didSet { collectionView.delegate = delegate }
    }

    var dataSource: UICollectionViewDataSource? {
        didSet { collectionView.dataSource = dataSource }
    }
    
    func register(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    func reloadData() {
        collectionView.reloadData()
    }

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipMask.backgroundColor = UIColor.black.cgColor
        layer.mask = clipMask
        
        addSubview(collectionView)
        collectionView.clipsToBounds = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never // Removes collectionView default top padding
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
        collectionView.constraints(equalTo: self)
    }
        
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        clipMask.frame = bounds.insetBy(dx: 0, dy: -50)
    }
}
