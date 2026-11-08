//
//  ImageUploadVC.swift
//  SatApi
//
//  Created by comviva on 08/11/26.
//

import UIKit

class ImageUploadVC: UIViewController {
    @IBOutlet weak var activityController: UIActivityIndicatorView?
    
    @IBOutlet weak var choosenImageView: UIImageView?
    let manager: ImageManager? = ImageManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    func setupUI() {
        self.activityController?.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Upload Image"
    }
    
    @IBAction func chooseImgAction(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.navigationController?.present(imagePicker, animated: true)
    }
    
    @IBAction func uploadImageAction(_ sender: Any) {
        if choosenImageView?.image != nil {
            self.activityController?.startAnimating()
            self.activityController?.isHidden = false
            let uploadData = choosenImageView?.image?.jpegData(compressionQuality: 0.2)
            manager?.uploadImage(data: uploadData!) { result in
                if !result.path.isEmpty {
                    DispatchQueue.main.async {
                        self.activityController?.stopAnimating()
                        self.activityController?.isHidden = true
                        let alert = UIAlertController(title: "Image Uploaded", message: "Image Uploaded Successfully", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .cancel)
                        alert.addAction(okAction)
                        self.present(alert, animated: true)
                    }
                    
                }
                
                
            }
        }
    }
}

extension ImageUploadVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            
            self.choosenImageView?.image = image
        }
        self.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
