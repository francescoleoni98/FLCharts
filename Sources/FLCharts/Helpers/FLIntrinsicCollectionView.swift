//
//  FLIntrinsicCollectionView.swift
//  FLCharts
//
//  Created by Francesco Leoni on 17/01/22.
//

import UIKit

class FLIntrinsicCollectionView: UICollectionView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        self.contentSize
    }
}
