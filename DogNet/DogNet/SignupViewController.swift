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
    @IBOutlet weak var birthdayDP: UIDatePicker!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                self.birthdayDP.datePickerMode = .date
                let dateFormater = DateFormatter()
                dateFormater.dateFormat = "MM/dd/yyyy"
                let user_data = PFObject(className: "user_data")
                user_data["num_dogs"] = 0
                user_data["age"] = self.birthdayDP.date.timeIntervalSinceNow/(-60*60*24*365)
                user_data["birthday"] = dateFormater.string(from: self.birthdayDP.date)
                user_data["owner"] = PFUser.current()
                
                user_data.saveInBackground(block: { (wasSuccess: Bool, error: Error?) in
                    if (wasSuccessful) {
                        self.performSegue(withIdentifier: "signupSegue", sender: nil)
                    } else {
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
                } else {
                    print(error?.localizedDescription ?? "Ya done fucked up")
                }
            }
        }
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
