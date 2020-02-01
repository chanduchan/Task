//
//  AddVC.swift
//  FrostAssignment
//
//  Created by Chandrasekhar K on 31/01/20.
//  Copyright © 2020 Chandrasekhar K. All rights reserved.
//

import UIKit
import CoreData


class AddVC: UIViewController {

    
    
    @IBOutlet weak var selectecImg: UIImageView!
    @IBOutlet weak var imageUploadBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var descriptionTXt: UITextField!
    @IBOutlet weak var titleTXt: UITextField!
    
    
    var onDoneBlock : ((Bool) -> Void)?
    
    // MARK: - view life cycle starts from here
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTXt.delegate = self
        descriptionTXt.delegate = self
        self.hideKeyboardWhenTappedAround()
        cancelBtn.clipsToBounds = true
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        cancelBtn.layer.cornerRadius = 5
        
        saveBtn.clipsToBounds = true
        saveBtn.layer.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        saveBtn.layer.cornerRadius = 5
        
        view.isOpaque = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    // MARK: - saveButton Action method
    @IBAction func saveBtnAction(_ sender: Any) {
        descriptionTXt.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        titleTXt.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        guard let title = titleTXt.text, let desc = descriptionTXt.text else {
            print("empty")
            return
        }
        if title.count != 0 {
            titleTXt.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            if desc.count != 0 {
                save(title: title, desc: desc)
            }else{
                descriptionTXt.clipsToBounds = true
                descriptionTXt.layer.borderWidth = 1
                descriptionTXt.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            }
        }else{
            titleTXt.clipsToBounds = true
            titleTXt.layer.borderWidth = 1
            titleTXt.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
    }
    // MARK: - cancel button action
    @IBAction func cancelBtnAction(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    
    // MARK: - saving information in coredata
    func save(title:String, desc:String){
         let imageData = selectecImg.image?.pngData()
        CoreDataRepository().saveNotes(title: title, desctiption: desc, imgData: imageData)
        onDoneBlock!(true)
        dismiss(animated: true, completion: nil)
       }
    
    // MARK: - imageupload action
    @IBAction func imageUploadBtnAction(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    deinit {
        print("delocted AddVC")
    }
}

// MARK: - implimenting imagepicker delagte methods
extension AddVC:UIImagePickerControllerDelegate & UINavigationControllerDelegate{

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let userPickedImage = info[.editedImage] as? UIImage else { return }
    selectecImg.image = userPickedImage
    picker.dismiss(animated: true)
    }

}

extension AddVC:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
// MARK: - keyboard hiding extension
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer =     UITapGestureRecognizer(target: self, action:    #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
