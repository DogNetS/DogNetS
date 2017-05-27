//
//  DogEditViewController.swift
//  DogNet
//
//  Created by Cong Tam Quang Hoang on 20/05/17.
//  Copyright © 2017 dognets. All rights reserved.
//
import Parse
import UIKit
import MBProgressHUD

class DogEditViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var breedField: UITextField!
    @IBOutlet weak var birthdayField: UITextField!
    @IBOutlet weak var healthField: UITextField!
    @IBOutlet weak var tempField: UITextField!
    @IBOutlet weak var toysField: UITextField!
    @IBOutlet weak var photoField: UIImageView!
    
    var dog: Dog!
    var pickedImage: UIImage! //for adding the photo of the dog
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickedImage = UIImage(named: "dog_default")
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addPhoto(_:)))
        photoField.isUserInteractionEnabled = true
        photoField.addGestureRecognizer(tapGestureRecognizer)
        
        
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
        
        birthdayField.inputAccessoryView = toolBar

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        nameField.text = dog.name
        breedField.text = dog.breed
        birthdayField.text = dog.birthday
        
        if(dog.health != "Not specified"){
            healthField.text = dog.health
        }
        if(dog.temperament != "Not specified"){
            tempField.text = dog.temperament
        }
        if(dog.toys != "Not specified"){
            toysField.text = dog.toys
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func onSaveButton(_ sender: Any) {
        MBProgressHUD.showAdded(to: self.view , animated: true)
        dog.updateDog(name: nameField.text, breed: breedField.text, birthday: birthdayField.text, image: pickedImage, health: healthField.text, temp: tempField.text, toys: toysField.text, palId: nil) {(success: Bool, error: Error?) in
            if success {
                MBProgressHUD.hide(for: self.view , animated: true)
                print("[DEBUG] successfully updated dog")
                self.dismiss(animated: true, completion: nil)
            } else {
                MBProgressHUD.hide(for: self.view , animated: true)
                let alertController = UIAlertController(title: "Could update dog", message: "Try again!", preferredStyle: .alert)
                // create a cancel action
                let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                    // handle cancel response here. Doing nothing will dismiss the view.
                }
                // add the cancel action to the alertController
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true) {
                    // optional code for what happens after the alert controller has finished presenting
                }

                print("[DEBUG] fail to update dog")
            }
        }
    }
    
    @IBAction func birthdaySelect(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.maximumDate = Date()
        
        // datePickerView.maximumDate = maxDate
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
    }
    
    func donePressed(sender: UIBarButtonItem) {
        
        birthdayField.resignFirstResponder()
        
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        birthdayField.text = dateFormatter.string(from: sender.date)
        
    }
    
    @IBAction func addPhoto(_ sender: UITapGestureRecognizer) {
        MBProgressHUD.showAdded(to: self.view , animated: true)
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        
        /* implement choosing between camera and photo library
         if UIImagePickerController.isSourceTypeAvailable(.camera) {
         print("Camera is available 📸")
         vc.sourceType = UIImagePickerControllerSourceType.camera
         } else {
         print("Camera 🚫 available so we will use photo library instead")
         vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
         }
         */
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        MBProgressHUD.hide(for: self.view , animated: true)
        self.present(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        let size = CGSize(width: photoField.frame.size.width, height: photoField.frame.size.height)
        pickedImage = resize(image: editedImage, newSize: size)
        
        self.photoField.image = pickedImage!
        if let size = photoField.image?.size{
            let multiplier = size.width / size.height
            let aspectRatioConstraint = NSLayoutConstraint(item: photoField, attribute: .width, relatedBy: .equal, toItem: photoField, attribute: .height, multiplier: multiplier, constant: 0)
            photoField.addConstraint(aspectRatioConstraint)
        }
        photoField.contentMode = UIViewContentMode.scaleAspectFill
        
        // Do something with the images (based on your use case)
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
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
