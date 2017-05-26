//
//  DogSignup1ViewController.swift
//  DogNet
//
//  Created by Sean Nam on 4/17/17.
//  Copyright © 2017 dognets. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class DogSignup1ViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var dogNameTextField: UITextField!
    @IBOutlet weak var dogBreedTextField: UITextField!
    @IBOutlet weak var dogBirthdayTextField: UITextField!
    @IBOutlet weak var dogHealthTextField: UITextField!
    @IBOutlet weak var dogFavToysTextField: UITextField!
    @IBOutlet weak var dogTemperTextField: UITextField!
    @IBOutlet weak var dogPhoto: UIImageView!
    
    var pickedImage: UIImage! //for adding the photo of the dog
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*adding tap gesture recognizer to the photo*/
        pickedImage = UIImage(named: "dog_default")
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addPhoto(_:)))
        dogPhoto.isUserInteractionEnabled = true
        dogPhoto.addGestureRecognizer(tapGestureRecognizer)
  
        
        
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
        
        dogBirthdayTextField.inputAccessoryView = toolBar

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addedDog(_ sender: Any) {
        
        let dog = PFObject(className: "dog_data")
        
        dog["name"] = dogNameTextField.text
        dog["breed"] = dogBreedTextField.text
        dog["birthday"] = dogBirthdayTextField.text
        dog["health"] = (dogHealthTextField.text?.isEmpty)! ? "Not specified" : dogHealthTextField.text
        dog["fav_toy"] = (dogFavToysTextField.text?.isEmpty)! ? "Not specified" : dogFavToysTextField.text
        dog["temper"] = (dogTemperTextField.text?.isEmpty)! ? "Not specified" : dogTemperTextField.text
        dog["owner"] = PFUser.current()

        dog["photo"] = Dog.getPFFileFromImage(image: pickedImage)
        dog["statuses"] = NSDictionary.init()
        
        if ((!(dogNameTextField.text?.isEmpty)!) && (!(dogBreedTextField.text?.isEmpty)!) && (!(dogBirthdayTextField.text?.isEmpty)!)){
        
            MBProgressHUD.showAdded(to: self.view , animated: true)
            dog.saveInBackground { (wasSuccessful: Bool, error: Error?) in
                if (wasSuccessful) {
                    MBProgressHUD.hide(for: self.view , animated: true)
                    print("dog added!")
                    self.dismiss(animated: true, completion: nil)
                } else {
                    MBProgressHUD.hide(for: self.view , animated: true)
                    let alertController = UIAlertController(title: "Could not add dog", message: "Try again!", preferredStyle: .alert)
                    // create a cancel action
                    let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                        // handle cancel response here. Doing nothing will dismiss the view.
                    }
                    // add the cancel action to the alertController
                    alertController.addAction(cancelAction)
                    
                    self.present(alertController, animated: true) {
                        // optional code for what happens after the alert controller has finished presenting
                    }

                    print(error?.localizedDescription ?? "Something went wrong while adding dog")
                }
            }
            
        }else{
            let alertController = UIAlertController(title: "Missing Required Info", message: "Fill in all the required information", preferredStyle: .alert)
            // create a cancel action
            let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                // handle cancel response here. Doing nothing will dismiss the view.
            }
            // add the cancel action to the alertController
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true) {
                // optional code for what happens after the alert controller has finished presenting
            }
            print("Fill in all the required information")
        }
    }
    @IBAction func cancelAdding(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func addPhoto(_ sender: UITapGestureRecognizer) {
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
        self.present(vc, animated: true, completion: nil)
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
        
        dogBirthdayTextField.resignFirstResponder()
        
    }

    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        dogBirthdayTextField.text = dateFormatter.string(from: sender.date)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        let size = CGSize(width: dogPhoto.frame.size.width, height: dogPhoto.frame.size.height)
        pickedImage = resize(image: editedImage, newSize: size)
        
        self.dogPhoto.image = pickedImage!
        if let size = dogPhoto.image?.size{
            let multiplier = size.width / size.height
            let aspectRatioConstraint = NSLayoutConstraint(item: dogPhoto, attribute: .width, relatedBy: .equal, toItem: dogPhoto, attribute: .height, multiplier: multiplier, constant: 0)
            dogPhoto.addConstraint(aspectRatioConstraint)
        }
        dogPhoto.contentMode = UIViewContentMode.scaleAspectFill
        
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
// string to date
extension String
{
    func  toDate( dateFormat format  : String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        if let date = dateFormatter.date(from: self)
        {
            return date
        }
        print("Invalid arguments ! Returning Current Date . ")
        return Date()
    }
}
