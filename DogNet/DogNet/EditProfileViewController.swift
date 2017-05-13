//
//  EditProfileViewController.swift
//  DogNet
//
//  Created by Sean Nam on 5/7/17.
//  Copyright © 2017 dognets. All rights reserved.
//

import UIKit
import Parse

class EditProfileViewController: ViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var bioTextView: UITextView!
    
    var user_data: [PFObject]!
    var bioText:String?
    var name:String?
    var email:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        bioTextView.delegate = self
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {

        nameTextField.text = user_data?[0]["name"] as? String
        emailTextField.text = PFUser.current()?.email

        bioTextView.text = user_data?[0]["bio"] as? String
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapBioTextView(_ sender: Any) {
        //self.bioTextView.becomeFirstResponder()
        print("biotext tapped")
    }
    
    @IBAction func onTapProfilePic(_ sender: Any) {
        print("profile pic tapped")
    }
    
    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onSaveButton(_ sender: Any) {
        
        name = nameTextField.text
        email = emailTextField.text
        bioText = bioTextView.text
        
        updateProfile(name: name, email: email, bio: bioText /*, profilePic: */) {(success: Bool, error: Error?) in
            if success {
                print("[DEBUG] successfully updated profile")
            } else {
                print("[DEBUG] fail to update profile")
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func updateProfile(name: String?, email: String?, bio: String?, /*profilePic: PFFile, */withCompletion completion: PFBooleanResultBlock?) {
        
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

                user_data?[0].saveInBackground(block: completion)
            } else {
                print("error while setting user_data")
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
