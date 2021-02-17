//
//  WebViewVC.swift
//  GoodEats
//
//  Created by William Yeung on 2/16/21.
//

import UIKit
import WebKit

class WebViewVC: UIViewController {
    var urlString: String? {
        didSet {
            guard let urlString = urlString, let url = URL(string: urlString) else { return }
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    // MARK: - Views
    private let webView: WKWebView = {
        let wv = WKWebView()
        return wv
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutViews()
        navigationItem.largeTitleDisplayMode = .never
    }
    
    // MARK: - UI
    func layoutViews() {
        view.addSubview(webView)
        webView.anchor(top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor)
    }
}
