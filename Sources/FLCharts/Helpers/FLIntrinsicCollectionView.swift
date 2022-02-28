//
//  FLIntrinsicCollectionView.swift
//  FLCharts
//
//  Created by Francesco Leoni on 17/01/22.
//

import UIKit

public class FLIntrinsicCollectionView: UICollectionView {
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }

    public override var intrinsicContentSize: CGSize {
        self.contentSize
    }
}
