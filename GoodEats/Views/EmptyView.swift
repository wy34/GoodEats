//
//  EmptyView.swift
//  GoodEats
//
//  Created by William Yeung on 2/13/21.
//

import UIKit

class EmptyView: UIView {
    // MARK: - Views
    private let emptyImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "empty")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let nothingHereLabel = UILabel.createEmptyViewLabel(text: "Nothing Here", textColor: "InvertedDarkMode", fontSize: 26)
    
    private let tapToAddLabel = UILabel.createEmptyViewLabel(text: "Tap + to add some restaurants", textColor: "DescriptionText", fontSize: 18)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    func layoutViews() {
        addSubviews(emptyImageView, nothingHereLabel, tapToAddLabel)
        emptyImageView.setDimension(width: widthAnchor, height: widthAnchor, wMult: 0.45, hMult: 0.45)
        emptyImageView.center(x: self.centerXAnchor, y: self.centerYAnchor, yPadding: -25)
        nothingHereLabel.anchor(top: emptyImageView.bottomAnchor, right: rightAnchor, left: leftAnchor, paddingTop: 10, paddingRight: 25, paddingLeft: 25)
        tapToAddLabel.anchor(top: nothingHereLabel.bottomAnchor, right: rightAnchor, left: leftAnchor, paddingTop: 5, paddingRight: 25, paddingLeft: 25)
    }
}
