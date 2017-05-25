//
//  SignupViewController.swift
//  DogNet
//
//  Created by Sean Nam on 4/17/17.
//  Copyright © 2017 dognets. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class SignupViewController: UIViewController {
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    var date: Date!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
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
    
    func donePressed(sender: UIBarButtonItem) {
        
        birthdayTextField.resignFirstResponder()
        
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        birthdayTextField.text = dateFormatter.string(from: sender.date)
        
    }
    
    @IBAction func onContinue(_ sender: Any) {
        
        print("Attempting to make a new user")
        
        // confirm passwords match
        if passwordTextField.text != confirmTextField.text {
            let alertController = UIAlertController(title: "Passowrds Do Not Match", message: "Please type the same password", preferredStyle: .alert)
            // create a cancel action
            let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                // handle cancel response here. Doing nothing will dismiss the view.
            }
            // add the cancel action to the alertController
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true) {
                // optional code for what happens after the alert controller has finished presenting
                self.passwordTextField.text = ""
                self.confirmTextField.text = ""
            }

            print("passwords do not match")
            return
        }
        
        let newUser = PFUser()
        newUser.username = usernameTextField.text
        newUser.password = passwordTextField.text
        newUser.email = emailTextField.text
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        newUser.signUpInBackground { (wasSuccessful: Bool, error: Error?) in
            if wasSuccessful {
                print("user created")
                print("initializing user data")
                
                let user_data = PFObject(className: "user_data")
                print("1")
                let birthdayText = self.birthdayTextField.text
                print("2")
                user_data["num_dogs"] = 0
                print("3")
                user_data["age"] = birthdayText?.toDate(dateFormat: "Mm/dd/yyy")
                print("4")
                user_data["birthday"] = birthdayText
                print("5")
                user_data["owner"] = PFUser.current()
                print("will save in background")
                
                user_data.saveInBackground(block: { (wasSuccess: Bool, error: Error?) in
                    if (wasSuccessful) {
                        print("signup successful")
                        self.performSegue(withIdentifier: "signupSegue", sender: nil)
                    } else {
                        print("signup failed")
                        print(error?.localizedDescription ?? "something went wrong")
                    }
                })
                MBProgressHUD.hide(for: self.view, animated: true)

            } else {
                MBProgressHUD.hide(for: self.view, animated: true)

                if error?._code == 202 {
                    let alertController = UIAlertController(title: "Username Taken", message: "Please choose a different username", preferredStyle: .alert)
                    // create a cancel action
                    let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                        // handle cancel response here. Doing nothing will dismiss the view.
                    }
                    // add the cancel action to the alertController
                    alertController.addAction(cancelAction)
                    
                    self.present(alertController, animated: true) {
                        // optional code for what happens after the alert controller has finished presenting
                        self.usernameTextField.text = ""
                    }

                    print("Ah, shucks! Someone already has that username")
                } else if error?._code == 200 {
                    let alertController = UIAlertController(title: "Username Field Required", message: "Please choose a username", preferredStyle: .alert)
                    // create a cancel action
                    let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                        // handle cancel response here. Doing nothing will dismiss the view.
                    }
                    // add the cancel action to the alertController
                    alertController.addAction(cancelAction)
                    
                    self.present(alertController, animated: true) {
                        // optional code for what happens after the alert controller has finished presenting
                    }

                    print("What? You didn't even enter a username")
                } else if error?._code == 201 {
                    let alertController = UIAlertController(title: "Password Field Required", message: "Please choose a password", preferredStyle: .alert)
                    // create a cancel action
                    let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                        // handle cancel response here. Doing nothing will dismiss the view.
                    }
                    // add the cancel action to the alertController
                    alertController.addAction(cancelAction)
                    
                    self.present(alertController, animated: true) {
                        // optional code for what happens after the alert controller has finished presenting
                    }

                    print("Okay you didn't even enter a password. That's not safe")
                } else if error?._code == 203 {
                    let alertController = UIAlertController(title: "Email already exists!", message: "Please choose a different email!", preferredStyle: .alert)
                    // create a cancel action
                    let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                        // handle cancel response here. Doing nothing will dismiss the view.
                    }
                    // add the cancel action to the alertController
                    alertController.addAction(cancelAction)
                    
                    self.present(alertController, animated: true) {
                        // optional code for what happens after the alert controller has finished presenting
                    }
                    
                    print("Okay you didn't even enter a password. That's not safe")
                } else {
                    print(error?.localizedDescription ?? "Ya done fucked up")
                }
            }
        }
    }

    @IBAction func onBirthdaySelect(_ sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.maximumDate = Date()
        
        // datePickerView.maximumDate = maxDate
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
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

