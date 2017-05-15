//
//  EditProfileViewController.swift
//  DogNet
//
//  Created by Sean Nam on 5/7/17.
//  Copyright © 2017 dognets. All rights reserved.
//

import UIKit
import Parse

class EditProfileViewController: ViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var bioTextView: UITextView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    var user_data: [PFObject]!
    var bioText: String?
    var name: String?
    var email: String?
    var resizeImage: UIImage!
    var profileImage: UIImage!
    let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onProfileTapGesture(sender:)))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGestureRecognizer)

    }
    
    override func viewWillAppear(_ animated: Bool) {

        nameTextField.text = user_data?[0]["name"] as? String
        emailTextField.text = PFUser.current()?.email
        bioTextView.text = user_data?[0]["bio"] as? String
        profileImageView.image = self.profileImage
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func chooseProfile() {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = .camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            vc.sourceType = .photoLibrary
        }
        
        self.present(vc, animated: true, completion: nil)
        
        print("profile pic tapped")
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // Get the image captured by the UIImagePickerController
        profileImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        self.profileImageView.image = profileImage
        
        let size = profileImage.size

        let smallerWidth = size.width * 0.7
        let smallerHeight = size.height * 0.7
        
        var smallerSize = CGSize()
        smallerSize.width = smallerWidth
        smallerSize.height = smallerHeight
        
        self.resizeImage = resize(image: profileImage, newSize: smallerSize)
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: newSize))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func onProfileTapGesture(sender: UITapGestureRecognizer) {
        print("onProfileTapGesture")
        chooseProfile()
    }
    
    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onSaveButton(_ sender: Any) {
        
        name = nameTextField.text
        email = emailTextField.text
        bioText = bioTextView.text
        
        updateProfile(name: name, email: email, bio: bioText, image: resizeImage) {(success: Bool, error: Error?) in
            print("resizeimage: \(self.resizeImage)")
            self.loadingIndicator.center = self.view.center
            self.loadingIndicator.startAnimating()
            self.view.addSubview(self.loadingIndicator)
            if success {
                print("[DEBUG] successfully updated profile")
                self.loadingIndicator.stopAnimating()
                self.dismiss(animated: true, completion: nil)
            } else {
                print("[DEBUG] fail to update profile")
            }
        }
        
    }
    
    func updateProfile(name: String?, email: String?, bio: String?, image: UIImage?, withCompletion completion: PFBooleanResultBlock?) {
        print("resizeimage: \(self.resizeImage)")
        
        let query = PFQuery(className: "user_data")
        query.order(byDescending: "createdAt")
        query.includeKey("owner")
        query.whereKey("owner", equalTo: PFUser.current()!)
        query.limit = 20
        query.findObjectsInBackground { (user_data: [PFObject]?, error: Error?) -> Void in
            if let data = user_data {
                self.user_data = data
                
                user_data?[0]["name"] = self.nameTextField.text
                PFUser.current()?.email = self.emailTextField.text
                user_data?[0]["bio"] = self.bioTextView.text

                if(image == nil) {
                    print("no image found")
                } else {
                    user_data?[0]["profilePic"] = self.getPFFileFromImage(image: image) // PFFile column type
                }
                
                // save to parse in background
                user_data?[0].saveInBackground(block: completion)
                
            } else {
                print("error while setting user_data")
            }
        }
    }
    
    
    /**
     Method to convert UIImage to PFFile
     
     - parameter image: Image that the user wants to upload to parse
     
     - returns: PFFile for the the data in the image
     */
    func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

