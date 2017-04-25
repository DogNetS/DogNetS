//
//  SignupViewController.swift
//  DogNet
//
//  Created by Sean Nam on 4/17/17.
//  Copyright © 2017 dognets. All rights reserved.
//

import UIKit
import Parse

class SignupViewController: UIViewController {
    @IBOutlet weak var birthdayDP: UIDatePicker!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!

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
            print("passwords do not match")
            passwordTextField.text = ""
            confirmTextField.text = ""
            return
        }
        
        let newUser = PFUser()
        newUser.username = usernameTextField.text
        newUser.password = passwordTextField.text
        newUser.signUpInBackground { (wasSuccessful: Bool, error: Error?) in
            if wasSuccessful {
                print("user created")
                self.performSegue(withIdentifier: "signupSegue", sender: nil)
            } else {
                if error?._code == 202 {
                    print("Ah, shucks! Someone already has that username")
                } else if error?._code == 200 {
                    print("What? You didn't even enter a username")
                } else if error?._code == 201 {
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