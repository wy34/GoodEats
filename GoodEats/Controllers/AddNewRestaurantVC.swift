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
        tv.separatorStyle = .none
        tv.tableFooterView = UIView()
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    var newRestaurantImageView: UIImageView!
    
    var nameTextField: UITextField! {
        didSet {
            nameTextField.becomeFirstResponder()
            nameTextField.tag = 1
            nameTextField.delegate = self
        }
    }
    
    var typeTextField: UITextField! {
        didSet {
            typeTextField.tag = 2
            typeTextField.delegate = self
        }
    }
    
    var addressTextField: UITextField! {
        didSet {
            addressTextField.tag = 3
            addressTextField.delegate = self
        }
    }
    
    var phoneTextField: UITextField! {
        didSet {
            phoneTextField.tag = 4
            phoneTextField.delegate = self
        }
    }
    
    var descriptionTextView: UITextView! {
        didSet {
            descriptionTextView.tag = 5
        }
    }
    
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down"), style: .plain, target: self, action: #selector(handleSaveTapped))
        navigationController?.navigationBar.tintColor = .black
        
        if let largeCustomFont = UIFont(name: "Rubik-Medium", size: 35) {
            navigationController?.navigationBar.largeTitleTextAttributes = [
                NSAttributedString.Key.font: largeCustomFont,
                NSAttributedString.Key.foregroundColor: UIColor(red: 231, green: 76, blue: 60)
            ]
        }
        
        if let smallCustomFont = UIFont(name: "Rubik-Medium", size: 16) {
            navigationController?.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.font: smallCustomFont,
                NSAttributedString.Key.foregroundColor: UIColor.init(red: 231, green: 76, blue: 60)
            ]
        }
    }
    
    func layoutViews() {
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor)
    }
    
    // MARK: - Helpers
    func displayImagePickerFor(type: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(type) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = type
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // MARK: - Selector
    @objc func handleCloseTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSaveTapped() {
        guard let name = nameTextField.text, !name.isEmpty,
              let type = typeTextField.text, !type.isEmpty,
              let address = addressTextField.text, !address.isEmpty,
              let phone = phoneTextField.text, !phone.isEmpty,
              let description = descriptionTextView.text, !description.isEmpty else {
            let validationAlert = UIAlertController(title: "Oops", message: "We can't proceed because one of the fields is blank. Please note that all fields are required.", preferredStyle: .alert)
            validationAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(validationAlert, animated: true, completion: nil)
            return
        }
        
        print("Name: \(name)\nType: \(type)\nLocation: \(address)\nPhone: \(phone)\nDescription: \(description)")
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
                newRestaurantImageView = cell.restaurantImageView
                cell.selectionStyle = .none
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: NameInputCell.reuseId, for: indexPath) as! NameInputCell
                nameTextField = cell.textField
                cell.selectionStyle = .none
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: TypeInputCell.reuseId, for: indexPath) as! TypeInputCell
                typeTextField = cell.textField
                cell.selectionStyle = .none
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: AddressInputCell.reuseId, for: indexPath) as! AddressInputCell
                addressTextField = cell.textField
                cell.selectionStyle = .none
                return cell
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: PhoneInputCell.reuseId, for: indexPath) as! PhoneInputCell
                phoneTextField = cell.textField
                cell.selectionStyle = .none
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: DescriptionInputCell.reuseId, for: indexPath) as! DescriptionInputCell
                descriptionTextView = cell.textView
                cell.selectionStyle = .none
                return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let photoSourceRequestController = UIAlertController(title: "", message: "Choose your photo source", preferredStyle: .actionSheet)
            
            if let popoverController = photoSourceRequestController.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
            }
            
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in
                self.displayImagePickerFor(type: .camera)
            }
            
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { action in
                self.displayImagePickerFor(type: .photoLibrary)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            photoSourceRequestController.addAction(cameraAction)
            photoSourceRequestController.addAction(photoLibraryAction)
            photoSourceRequestController.addAction(cancelAction)
            
            present(photoSourceRequestController, animated: true, completion: nil)
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

// MARK: - UITextfield Delegate
extension AddNewRestaurantVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = view.viewWithTag(textField.tag + 1) {
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        }
        
        return true
    }
}

// MARK: - UIImagePickerController Delegate
extension AddNewRestaurantVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        newRestaurantImageView.contentMode = .scaleAspectFill
        newRestaurantImageView?.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
}
