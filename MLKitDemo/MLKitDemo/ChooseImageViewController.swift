//
//  ChooseImageViewController.swift
//  MLKitDemo
//
//  Created by Ekachai Limpisoot on 2/6/2562 BE.
//  Copyright © 2562 Ekachai Limpisoot. All rights reserved.
//

import UIKit
import FirebaseMLVision
class ChooseImageViewController: UIViewController {

    let picker = UIImagePickerController()
    lazy var vision = Vision.vision()
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        self.title = "Text recognition"
        
    }

    @IBAction func didTapCameraButton(_ sender: Any) {
        picker.sourceType = .camera
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func didTapLibraryButton(_ sender: Any) {
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
}

// MARK: ML Kit text detect
extension ChooseImageViewController{
    
    func detectTextOnDevice(image: UIImage?) {
        guard let image = image else { return }
        // [START init_text]
        let onDeviceTextRecognizer = vision.onDeviceTextRecognizer()
        // [END init_text]
        
        // Define the metadata for the image.
        let imageMetadata = VisionImageMetadata()
        imageMetadata.orientation = UIUtilities.visionImageOrientation(from: image.imageOrientation)
        
        // Initialize a VisionImage object with the given UIImage.
        let visionImage = VisionImage(image: image)
        visionImage.metadata = imageMetadata
        
        onDeviceTextRecognizer.process(visionImage) { text, error in
            guard error == nil, let text = text else {
                self.showError(errorMessage: error?.localizedDescription ?? "Something went wrong")
                return
            }
            
            self.showResultScreen(image: image, resultString: "\(text.text)\n")
        }
    }
}

//MARK: UIImagePickerController's delegate
extension ChooseImageViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let image = info[.originalImage] as? UIImage {
            self.detectTextOnDevice(image: image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: UI
extension ChooseImageViewController{
    func showError(errorMessage : String){
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "dismiss", style: .default)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showResultScreen(image : UIImage,resultString : String){
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
        vc.image = image
        vc.resultString = resultString
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
