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
        addSubview(emptyImageView)
        emptyImageView.setDimension(wConst: 320, hConst: 356)
        emptyImageView.anchor(top: topAnchor, right: rightAnchor, bottom: bottomAnchor, left: leftAnchor, paddingRight: 28, paddingLeft: 28)
    }
}
