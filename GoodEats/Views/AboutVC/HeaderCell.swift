//
//  AboutCell.swift
//  GoodEats
//
//  Created by William Yeung on 2/16/21.
//

import UIKit

class HeaderCell: UITableViewCell {
    // MARK: - Properties
    static let reuseId = "HeaderCell"
    
    // MARK: - Views
    private let headerView: UIView = {
        let view = UIView()
        let iv = UIImageView(image: UIImage(named: "foodpin-logo"))
        view.addSubview(iv)
        iv.setDimension(wConst: 142, hConst: 53)
        iv.center(x: view.centerXAnchor, y: view.centerYAnchor)
        return view
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(headerView)
        headerView.anchor(top: topAnchor, right: rightAnchor, bottom: bottomAnchor, left: leftAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
