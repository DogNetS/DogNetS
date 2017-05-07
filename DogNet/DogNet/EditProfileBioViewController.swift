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
        print("editprofile: \(user_data[0])")
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
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func updateProfile(bio: String?, withCompletion completion: PFBooleanResultBlock?) {
        let query = PFQuery(className: "user_data")
        query.order(byDescending: "createdAt")
        query.includeKey("owner")
        query.whereKey("owner", equalTo: PFUser.current()!)
        query.limit = 20
        query.findObjectsInBackground { (user_data: [PFObject]?, error: Error?) -> Void in
            if let data = user_data {
                self.user_data = data

                user_data?[0]["bio"] = self.bioTextView.text
                user_data?[0].saveInBackground(block: completion)
            } else {
                print("error while getting user_data")
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
