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
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
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
        spinner.hidesWhenStopped = true
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
    
    private lazy var welcomeAlertView: WelcomeAlertView = {
        let view = WelcomeAlertView()
        view.delegate = self
        view.alpha = 0
        view.transform = CGAffineTransform(scaleX: 0, y: 0)
        return view
    }()
    
    // MARK: - Init
    override init() {
        super.init()
    }
    
    // MARK: - Helpers
    func showWelcomeAlertView() {
        if let keyWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.blackView.frame = keyWindow.frame
                keyWindow.addSubview(self.blackView)

                keyWindow.addSubview(self.welcomeAlertView)
                self.welcomeAlertView.center(x: keyWindow.centerXAnchor, y: keyWindow.centerYAnchor)
                self.welcomeAlertView.setDimension(width: keyWindow.widthAnchor, height: keyWindow.heightAnchor)

                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.55, initialSpringVelocity: 1, options: .curveEaseIn) {
                    self.blackView.alpha = 1
                    self.welcomeAlertView.alpha = 1
                    self.welcomeAlertView.transform = .identity
                }
            }
        }
    }
    
    func showCustomLoadView() {
        if let keyWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first {
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
                self.customSpinnerBgView.alpha = 1
                self.loadingLabel.alpha = 1
            }
        }
    }
    
    func dismissCustomLoadView() {
        if WelcomeAlertManager.shared.isFirstTimeShowing {
            showWelcomeAlertView()
        }
        
        UIView.animate(withDuration: 0.25) {
            self.customSpinnerBgView.removeFromSuperview()
            self.customSpinnerBgView.alpha = 0
            self.loadingLabel.removeFromSuperview()
            self.loadingLabel.alpha = 0
            self.customSpinner.stopAnimating()
        }
    }
}

// MARK: - WelcomeAlertViewDelegate
extension CustomLoadViewLauncher: WelcomeAlertViewDelegate {
    func dismissWelcomeAlert() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.blackView.removeFromSuperview()
            self.welcomeAlertView.alpha = 0
            self.welcomeAlertView.removeFromSuperview()
        }
        
        WelcomeAlertManager.shared.stopShowingWelcomeAlert()
    }
}
