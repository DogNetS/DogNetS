//
//  EditProfileBioViewController.swift
//  DogNet
//
//  Created by Sean Nam on 5/7/17.
//  Copyright © 2017 dognets. All rights reserved.
//

import UIKit
import Parse

class EditProfileBioViewController: ViewController {
    
    var bioText:String?
    var user_data: [PFObject]!
    
    @IBOutlet weak var bioTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSave(_ sender: Any) {
        bioText = bioTextView.text
        updateProfile(bio: bioText) {(success: Bool, error: Error?) in
            if success {
                print("[DEBUG] successfully updated profile")
                self.dismiss(animated: true, completion: nil)
                
            } else {
                print("[DEBUG] fail to update profile")
            }
        }
    }
    
    func updateProfile(bio: String?, withCompletion completion: PFBooleanResultBlock?) {
//        let query = PFQuery(className: "user_data")
//        query.order(byDescending: "createdAt")
//        query.includeKey("owner")
//        query.whereKey("owner", equalTo: PFUser.current()!)
//        query.limit = 20
//        query.findObjectsInBackground { (user_data: [PFObject]?, error: Error?) -> Void in
//            if let userdata = user_data {
//                self.user_data = userdata
//                print("insde: user data: \(self.user_data)")
//                
//            } else {
//                print("error while getting user_data")
//            }
//        }
        
        // Create Parse object PFObject
        let data = PFObject(className: "user_data")
        
        // Add relevant fields to the object
        //post["media"] = getPFFileFromImage(image: image) // PFFile column type
        data["owner"] = PFUser.current()
        data["bio"] = bioTextView.text
        
        data["num_dog"] = self.user_data[0]["num_dogs"]
        data["age"] = self.user_data[0]["age"]
        data["birthday"] = self.user_data[0]["birthday"]
        data["location"] = self.user_data[0]["location"]

        
        // Save object (following function will save the object in Parse asynchronously)
        data.saveInBackground(block: completion)
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
