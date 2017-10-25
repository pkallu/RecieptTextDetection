//
//  ViewController.swift
//  Receiptdetection
//
//  Created by Pragathi Kallu on 10/25/17.
//  Copyright © 2017 pkallu. All rights reserved.
//

import UIKit
import TesseractOCR

class ViewController: UIViewController, G8TesseractDelegate {

    var activityIndicator: UIActivityIndicatorView?
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnTakePictureTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnParseTapped(_ sender: Any) {
        if imageView.image != nil {
            if let tesseract:G8Tesseract = G8Tesseract(language:"eng+fra") {
                //tesseract.language = "eng+ita"
                tesseract.delegate = self
                tesseract.charWhitelist = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                tesseract.image = imageView.image
                addActivityIndicator()
                tesseract.recognize()
                removeActivityIndicator()
                let parsedText = tesseract.recognizedText as String
                let stringArray = parsedText.components(separatedBy: "\n")
                print("\(stringArray) Count is \(stringArray.count)")
                
            }
        }
    }
    
    @IBAction func btnLibraryTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    
    func addActivityIndicator()  {
        activityIndicator = UIActivityIndicatorView(frame: view.bounds)
        activityIndicator?.activityIndicatorViewStyle = .gray
        activityIndicator?.backgroundColor = UIColor(white: 0, alpha: 0.25)
        activityIndicator?.startAnimating()
        view.addSubview(activityIndicator!)
    }
    
    
    func removeActivityIndicator() {
        activityIndicator?.removeFromSuperview()
        activityIndicator = nil
    }
    func shouldCancelImageRecognitionForTesseract(tesseract: G8Tesseract!) -> Bool {
        return false // return true if you need to interrupt tesseract before it finishes
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        dismiss(animated:true, completion: nil)
    }
}

