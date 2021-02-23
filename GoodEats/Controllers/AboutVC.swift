//
//  MoreVC.swift
//  GoodEats
//
//  Created by William Yeung on 2/16/21.
//

import UIKit
import SafariServices

class AboutVC: UIViewController {
    // MARK: - Properties
    var sectionTitles = ["", NSLocalizedString("Feedback", comment: "Feedback"), NSLocalizedString("Follow Us", comment: "Follow Us")]
    var sectionContent = [
        [(image: "", text: "", link: "")],
        [(image: "store", text: NSLocalizedString("Rate us on App Store", comment: "Rate us on App Store"), link: "https://www.apple.com/ios/app-store"), (image: "chat", text: NSLocalizedString("Tell us your feedback", comment: "Tell us your feedback"), link: "https://wy34.github.io./")],
        [(image: "twitter", text: NSLocalizedString("Twitter", comment: "Twitter"), link: "https://twitter.com/williamyeung34"), (image: "facebook", text: NSLocalizedString("Facebook", comment: "Facebook"), link: "https://www.facebook.com/william.yeung.79"), (image: "instagram", text: NSLocalizedString("Instagram", comment: "Instagram"), link: "https://www.instagram.com/williamyeung34/")]
    ]
    
    // MARK: - Views
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.delegate = self
        tv.dataSource = self
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "About")
        tv.register(HeaderCell.self, forCellReuseIdentifier: HeaderCell.reuseId)
        tv.cellLayoutMarginsFollowReadableWidth = true
        tv.tableFooterView = UIView()
        tv.backgroundColor = UIColor(named: "DarkMode")
        tv.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        return tv
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("About", comment: "About")
        layoutViews()
    }
    
    // MARK: - UI
    func layoutViews() {
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor)
    }
}

// MARK: - UITableView Delegate/Datasource
extension AboutVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionContent[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HeaderCell.reuseId, for: indexPath) as! HeaderCell
            cell.backgroundColor = UIColor(named: "DarkMode")
            cell.isUserInteractionEnabled = false
            cell.separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0) // removes only the separators of the first cell
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "About", for: indexPath)
        cell.backgroundColor = UIColor(named: "AboutCell")
        cell.textLabel?.text = sectionContent[indexPath.section][indexPath.row].text
        cell.imageView?.image = UIImage(named: sectionContent[indexPath.section][indexPath.row].image)?.withRenderingMode(.alwaysTemplate)
        cell.imageView?.tintColor = UIColor(named: "InvertedDarkMode")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        }
        
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let link = sectionContent[indexPath.section][indexPath.row].link
        
        switch indexPath.section {
            case 1:
                if indexPath.row == 0 {
                    if let url = URL(string: link) {
                        UIApplication.shared.open(url)
                    }
                } else {
                    let webView = WebViewVC()
                    webView.urlString = link
                    navigationController?.pushViewController(webView, animated: true)
                }
            case 2:
                if let url = URL(string: link) {
                    let config = SFSafariViewController.Configuration()
                    config.entersReaderIfAvailable = true
                    
                    let safariController = SFSafariViewController(url: url, configuration: config)
                    view.window?.rootViewController?.present(safariController, animated: true, completion: nil)
                }
            default:
                break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
