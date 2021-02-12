//
//  AddNewRestaurantVC.swift
//  GoodEats
//
//  Created by William Yeung on 2/11/21.
//

import UIKit

class AddNewRestaurantVC: UIViewController {
    // MARK: - Views
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(NewRestaurantImageCell.self, forCellReuseIdentifier: NewRestaurantImageCell.reuseId)
        tv.register(NameInputCell.self, forCellReuseIdentifier: NameInputCell.reuseId)
        tv.register(TypeInputCell.self, forCellReuseIdentifier: TypeInputCell.reuseId)
        tv.register(AddressInputCell.self, forCellReuseIdentifier: AddressInputCell.reuseId)
        tv.register(PhoneInputCell.self, forCellReuseIdentifier: PhoneInputCell.reuseId)
        tv.register(DescriptionInputCell.self, forCellReuseIdentifier: DescriptionInputCell.reuseId)
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        layoutViews()
    }
    
    // MARK: - UI
    func configureNavBar() {
        title = "New Restaurant"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(handleCloseTapped))
    }
    
    func layoutViews() {
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor)
    }
    
    // MARK: - Selector
    @objc func handleCloseTapped() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableView Delegate/Datasource
extension AddNewRestaurantVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: NewRestaurantImageCell.reuseId, for: indexPath) as! NewRestaurantImageCell
                cell.selectionStyle = .none
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: NameInputCell.reuseId, for: indexPath) as! NameInputCell
                cell.selectionStyle = .none
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: TypeInputCell.reuseId, for: indexPath) as! TypeInputCell
                cell.selectionStyle = .none
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: AddressInputCell.reuseId, for: indexPath) as! AddressInputCell
                cell.selectionStyle = .none
                return cell
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: PhoneInputCell.reuseId, for: indexPath) as! PhoneInputCell
                cell.selectionStyle = .none
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: DescriptionInputCell.reuseId, for: indexPath) as! DescriptionInputCell
                cell.selectionStyle = .none
                return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
            case 0:
                return 200
            case 5:
                return 150
            default:
                return 88
        }
    }
}
