//
//  EditProfileViewController.swift
//  DogNet
//
//  Created by Sean Nam on 5/7/17.
//  Copyright © 2017 dognets. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class EditProfileViewController: ViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    
    @IBOutlet weak var bioTextView: UITextView!
    
    var user_data: [PFObject]!
    var bioText: String?
    var name: String?
    var email: String?
    var birthday: String?
    
    var resizeImage: UIImage!
    var profileImage: UIImage!
    let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // for selecting new profile pic
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onProfileTapGesture(sender:)))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
        nameTextField.text = user_data?[0]["name"] as? String
        print("**********  \(user_data)")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

        self.birthday = user_data?[0]["birthday"] as? String
        
        // update fields using data from Profile VC
        nameTextField.text = user_data?[0]["name"] as? String
        print("**********  \(user_data)")
        print("name in text field: \(nameTextField.text)")
        emailTextField.text = PFUser.current()?.email
        bioTextView.text = user_data?[0]["bio"] as? String

        birthdayTextField.text = birthday
        profileImageView.image = self.profileImage
        
        /* setting the date picker, etc*/
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.blackTranslucent
        toolBar.tintColor = UIColor.white
        
        let okBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.donePressed))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label.font = UIFont(name: "Helvetica", size: 12)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.text = "Select the birthday"
        label.textAlignment = NSTextAlignment.center
        let textBtn = UIBarButtonItem(customView: label)
        toolBar.setItems([textBtn,flexSpace,okBarBtn], animated: true)
        birthdayTextField.inputAccessoryView = toolBar
        
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
        
        // save values from fields
        name = nameTextField.text
        email = emailTextField.text
        birthday = birthdayTextField.text
        bioText = bioTextView.text
        
        MBProgressHUD.showAdded(to: self.view , animated: true)
        updateProfile(name: name, email: email, bio: bioText, image: resizeImage) {(success: Bool, error: Error?) in

            self.loadingIndicator.center = self.view.center
            self.loadingIndicator.startAnimating()
            self.view.addSubview(self.loadingIndicator)
            if success {
                MBProgressHUD.hide(for: self.view , animated: true)
                print("[DEBUG] successfully updated profile")
                self.loadingIndicator.stopAnimating()
                self.dismiss(animated: true, completion: nil)
            } else {
                print("[DEBUG] fail to update profile")
            }
        }
        
    }
    
    @IBAction func onBirthdaySelect(_ sender: UITextField) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let date = dateFormatter.date(from:self.birthday!)!
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.date = date
        datePickerView.maximumDate = Date()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        birthdayTextField.text = dateFormatter.string(from: sender.date)
        
    }
    
    func donePressed(sender: UIBarButtonItem) {
        birthdayTextField.resignFirstResponder()
    }
    
    func updateProfile(name: String?, email: String?, bio: String?, image: UIImage?, withCompletion completion: PFBooleanResultBlock?) {
        
        let query = PFQuery(className: "user_data")
        query.order(byDescending: "createdAt")
        query.includeKey("owner")
        query.whereKey("owner", equalTo: PFUser.current()!)
        query.limit = 20
        MBProgressHUD.showAdded(to: self.view , animated: true)
        query.findObjectsInBackground { (user_data: [PFObject]?, error: Error?) -> Void in
            if let data = user_data {
                MBProgressHUD.hide(for: self.view , animated: true)
                self.user_data = data
                
                user_data?[0]["name"] = self.nameTextField.text
                PFUser.current()?.email = self.emailTextField.text
                user_data?[0]["bio"] = self.bioTextView.text
                user_data?[0]["birthday"] = self.birthdayTextField.text

                if(image == nil) {
                    print("no image found")
                } else {
                    user_data?[0]["profilePic"] = self.getPFFileFromImage(image: image) // PFFile column type
                }
                
                // save to parse in background
                user_data?[0].saveInBackground(block: completion)
                
            } else {
                MBProgressHUD.hide(for: self.view , animated: true)
                let alertController = UIAlertController(title: "Edit not successful", message: "Try again!", preferredStyle: .alert)
                // create a cancel action
                let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                    // handle cancel response here. Doing nothing will dismiss the view.
                }
                // add the cancel action to the alertController
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true) {
                    // optional code for what happens after the alert controller has finished presenting
                }
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

