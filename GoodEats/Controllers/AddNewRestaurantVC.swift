//
//  AddNewRestaurantVC.swift
//  GoodEats
//
//  Created by William Yeung on 2/11/21.
//

import UIKit
//import CloudKit

class AddNewRestaurantVC: UITableViewController {
    // MARK: - Views
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
        setupTableView()
    }
    
    // MARK: - UI
    func setupTableView() {
        tableView.register(NewRestaurantImageCell.self, forCellReuseIdentifier: NewRestaurantImageCell.reuseId)
        tableView.register(NameInputCell.self, forCellReuseIdentifier: NameInputCell.reuseId)
        tableView.register(TypeInputCell.self, forCellReuseIdentifier: TypeInputCell.reuseId)
        tableView.register(AddressInputCell.self, forCellReuseIdentifier: AddressInputCell.reuseId)
        tableView.register(PhoneInputCell.self, forCellReuseIdentifier: PhoneInputCell.reuseId)
        tableView.register(DescriptionInputCell.self, forCellReuseIdentifier: DescriptionInputCell.reuseId)
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(named: "DarkMode")
    }
    
    func configureNavBar() {
        navigationItem.title = NSLocalizedString("New Restaurant", comment: "New Restaurant")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(weight: .bold)), style: .plain, target: self, action: #selector(handleCloseTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down", withConfiguration: UIImage.SymbolConfiguration(weight: .bold)), style: .plain, target: self, action: #selector(handleSaveTapped))
        navigationController?.navigationBar.tintColor = UIColor(named: "InvertedDarkMode")
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
            let validationAlert = UIAlertController(title: NSLocalizedString("Oops", comment: "Oops"), message: NSLocalizedString("We can't proceed because one of the fields is blank. Please note that all fields are required.", comment: "We can't proceed because one of the fields is blank. Please note that all fields are required."), preferredStyle: .alert)
            validationAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil))
            present(validationAlert, animated: true, completion: nil)
            return
        }
        
        var selectedImage: UIImage
        
        if let image = newRestaurantImageView.image {
            selectedImage = image
        } else {
            selectedImage = UIImage(systemName: "photo")!.withTintColor(UIColor.init(red: 231, green: 76, blue: 60))
        }
        
        CoreDataManager.shared.createRestaurantWith(name: name, type: type, location: address, phone: phone, summary: description, image: selectedImage)
        CoreDataManager.shared.save()
        
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableView Delegate/Datasource
extension AddNewRestaurantVC {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let photoSourceRequestController = UIAlertController(title: "", message: NSLocalizedString("Choose your photo source", comment: "Choose your photo source"), preferredStyle: .actionSheet)
            
            if let popoverController = photoSourceRequestController.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
            }
            
            let cameraAction = UIAlertAction(title: NSLocalizedString("Camera", comment: "Camera"), style: .default) { action in
                self.displayImagePickerFor(type: .camera)
            }
            
            let photoLibraryAction = UIAlertAction(title: NSLocalizedString("Photo Library", comment: "Photo Library"), style: .default) { action in
                self.displayImagePickerFor(type: .photoLibrary)
            }
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: nil)
            
            photoSourceRequestController.addAction(cameraAction)
            photoSourceRequestController.addAction(photoLibraryAction)
            photoSourceRequestController.addAction(cancelAction)
            
            present(photoSourceRequestController, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
