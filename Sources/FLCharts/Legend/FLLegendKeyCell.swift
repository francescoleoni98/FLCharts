//
//  LegendKeyCell.swift
//  FLCharts
//
//  Created by Francesco Leoni on 17/01/22.
//

import UIKit

class FLLegendKeyCell: UICollectionViewCell {
    
    public static let identifier = "FLLegendKeyCell"
    
    private let squareView = UIView()
    private let keyLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(squareView)
        squareView.clipsToBounds = true
        squareView.layer.cornerRadius = 3
        squareView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(keyLabel)
        keyLabel.font = .preferredFont(forTextStyle: .footnote)
        keyLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            squareView.topAnchor.constraint(equalTo: topAnchor),
            squareView.leadingAnchor.constraint(equalTo: leadingAnchor),
            squareView.bottomAnchor.constraint(equalTo: bottomAnchor),
            squareView.heightAnchor.constraint(equalToConstant: 15),
            squareView.widthAnchor.constraint(equalToConstant: 15),

            keyLabel.topAnchor.constraint(equalTo: topAnchor),
            keyLabel.leadingAnchor.constraint(equalTo: squareView.trailingAnchor, constant: 5),
            keyLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            keyLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    public func configure(key: Key, formatter: FLFormatter) {
        squareView.layer.addSublayer(key.color.gradientLayer(in: CGRect(x: 0, y: 0, width: 15, height: 15)))
        keyLabel.attributedText = key.textWithValue(formatter: formatter)
        keyLabel.textColor = FLColor.black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
