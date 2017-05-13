//
//  ProfileViewController.swift
//  DogNet
//
//  Created by Sean Nam on 4/17/17.
//  Copyright © 2017 dognets. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var bioTextView: UITextView!
    
    var user_data: [PFObject]!
    var age:Int = 0
    var num_dogs:Int = 0
    var bioText:String = ""
    var location:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bioTextView.delegate = self
        
        
        let edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(ProfileViewController.segueToEditProfile))
        self.navigationItem.rightBarButtonItem = edit
        self.navigationController?.title = "Profile"
        
        let query = PFQuery(className: "user_data")
        query.order(byDescending: "createdAt")
        query.includeKey("owner")
        query.whereKey("owner", equalTo: PFUser.current()!)
        query.limit = 20
        query.findObjectsInBackground { (user_data: [PFObject]?, error: Error?) -> Void in
            if let data = user_data {
                self.user_data = data
                print("\(self.user_data)")
                
                self.saveData()
                self.updateTextLabels()
                
            } else {
                print("error while getting user_data")
            }
        }
        

        //let user = PFUser.current()
        //nameLabel.text = user?.username
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        let edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(ProfileViewController.segueToEditProfile))
//        self.navigationItem.rightBarButtonItem = edit
//
//        let query = PFQuery(className: "user_data")
//        query.order(byDescending: "createdAt")
//        query.includeKey("owner")
//        query.whereKey("owner", equalTo: PFUser.current()!)
//        query.limit = 20
//        query.findObjectsInBackground { (user_data: [PFObject]?, error: Error?) -> Void in
//            if let data = user_data {
//                self.user_data = data
//                print("insde: user data: \(self.user_data)")
//                
//                self.saveData()
//                self.updateTextLabels()
//                
//            } else {
//                print("error while getting user_data")
//            }
//        }
        //self.saveData()
        //self.updateTextLabels()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // sets the data from parse
    func saveData() {

        if(self.user_data?[0]["name"] != nil) {
            self.nameLabel.text = self.user_data?[0]["name"] as? String
        }
        if(self.user_data?[0]["age"] != nil) {
            self.age = self.user_data?[0]["age"] as! Int
        }
        
        if(self.user_data?[0]["num_dogs"] != nil) {
            self.num_dogs = self.user_data?[0]["num_dogs"] as! Int
        }
        
        if(self.user_data?[0]["location"] != nil) {
            self.location = self.user_data?[0]["location"] as! String
        }

        if(self.user_data?[0]["bio"] != nil) {
            self.bioText = self.user_data?[0]["bio"] as! String
        }
        
    }
    
    // updates all the labels
    func updateTextLabels() {
        ageLabel.text = "\(self.age)"
        bioTextView.text = self.bioText
        locationLabel.text = self.location
    }
    
    @IBAction func onEditProfileButton(_ sender: Any) {
        segueToEditProfile()
    }
    
//    @IBAction func bioTextTapGestureRecognizer(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "EditProfileBioVC") as! EditProfileBioViewController
//        vc.user_data = self.user_data
//        self.present(vc, animated: true, completion: nil)
//    }
    
    func segueToEditProfile() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "editProfileVC") as! EditProfileViewController
        vc.user_data = self.user_data
        self.present(vc, animated: true, completion: nil)
        
        //self.navigationController?.pushViewController(vc, animated: true)
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
