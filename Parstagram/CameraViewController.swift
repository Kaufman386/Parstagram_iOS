//
//  CameraViewController.swift
//  Parstagram
//
//  Created by Mikael Joseph Kaufman on 3/18/21.
//

import UIKit
import AlamofireImage
import Parse

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var onSubmitButton: UIButton!
    
    var attrs = [
        NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20.0),
        NSAttributedString.Key.foregroundColor : UIColor.systemBlue,
        NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]
    
    var attributedString = NSMutableAttributedString(string:"")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentField.layer.cornerRadius = 5
        commentField.layer.borderWidth = 2
        commentField.layer.borderColor = UIColor.black.cgColor
        
        let buttonTitleStr = NSMutableAttributedString(string:"Submit", attributes: attrs)
        attributedString.append(buttonTitleStr)
        onSubmitButton.setAttributedTitle(attributedString, for: [])
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSubmitButton(_ sender: Any) {
        let post = PFObject(className: "Posts")
        
        post["caption"] = commentField.text!
        post["author"] = PFUser.current()!
        
        let imageData = imageView.image!.pngData()
        let file = PFFileObject(data: imageData!)
        
        post["image"] = file
        
        post.saveInBackground{ (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
                print("Saved!")
            } else {
                print("error!")
            }
        }
    }
    
    @IBAction func onCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    // Function for selecting the image, it will replace imageView with selected photo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageScaled(to: size)
        
        imageView.image = scaledImage
        
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
