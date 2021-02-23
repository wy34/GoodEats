//
//  CustomLoadViewLauncher.swift
//  GoodEats
//
//  Created by William Yeung on 2/23/21.
//

import UIKit

class CustomLoadViewLauncher: NSObject {
    // MARK: - Views
    private let blackView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        return view
    }()
    
    private let customSpinnerBgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "InvertedDarkMode")?.withAlphaComponent(0.3)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.alpha = 0
        return view
    }()
    
    private let customSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.style = .large
        spinner.color = .white
        return spinner
    }()
    
    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Loading...", comment: "Loading...")
        label.textAlignment = .center
        label.textColor = .white
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: UIFont.init(name: "Rubik-Regular", size: 16)!)
        label.alpha = 0
        return label
    }()
    
    // MARK: - Init
    override init() {
        super.init()
    }
    
    // MARK: - Helpers
    func showCustomLoadView() {
        if let keyWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first {
            blackView.frame = keyWindow.frame
            keyWindow.addSubview(blackView)
            
            keyWindow.addSubview(customSpinnerBgView)
            customSpinnerBgView.setDimension(wConst: 115, hConst: 115)
            customSpinnerBgView.center(x: keyWindow.centerXAnchor, y: keyWindow.centerYAnchor)
            
            keyWindow.addSubview(customSpinner)
            customSpinner.center(x: keyWindow.centerXAnchor, y: keyWindow.centerYAnchor, yPadding: -12)
            customSpinner.startAnimating()
            
            keyWindow.addSubview(loadingLabel)
            loadingLabel.center(to: keyWindow, by: .centerX)
            loadingLabel.anchor(top: customSpinner.bottomAnchor, paddingTop: 5)
            
            UIView.animate(withDuration: 0.25) {
                self.blackView.alpha = 1
                self.customSpinnerBgView.alpha = 1
                self.loadingLabel.alpha = 1
            }
        }
    }
    
    func dismissCustomLoadView() {
        UIView.animate(withDuration: 0.25) {
            self.blackView.removeFromSuperview()
            self.blackView.alpha = 0
            self.customSpinnerBgView.removeFromSuperview()
            self.customSpinnerBgView.alpha = 0
            self.loadingLabel.removeFromSuperview()
            self.loadingLabel.alpha = 0
            self.customSpinner.stopAnimating()
        }
    }
}
