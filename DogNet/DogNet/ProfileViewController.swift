//
//  ProfileViewController.swift
//  DogNet
//
//  Created by Sean Nam on 4/17/17.
//  Copyright © 2017 dognets. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class ProfileViewController: UIViewController {

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
    var profileImage: UIImage?
    var birthday: String?
    let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Add edit button and set titile
        let edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(ProfileViewController.segueToEditProfile))
        self.navigationItem.rightBarButtonItem = edit
        self.navigationItem.title = "Profile"
        
        // start animating loadingIndicator
        loadingIndicator.center = view.center
        loadingIndicator.startAnimating()
        view.addSubview(loadingIndicator)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // clear fields while data is loading
        self.profileImageView.image = nil
        self.nameLabel.text = ""
        self.ageLabel.text = ""
        self.locationLabel.text = ""
        self.bioTextView.text = ""
        
        // search for PFObject with matching "owner" field
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
                //print("\(self.user_data)")
                
                self.saveData()
                self.loadingIndicator.stopAnimating()
                self.updateTextLabels()
                
            } else {
                MBProgressHUD.hide(for: self.view , animated: true)
                let alertController = UIAlertController(title: "Could not get user profile", message: "Try again!", preferredStyle: .alert)
                // create a cancel action
                let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                    // handle cancel response here. Doing nothing will dismiss the view.
                }
                // add the cancel action to the alertController
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true) {
                    // optional code for what happens after the alert controller has finished presenting
                }

                print("error while getting user_data")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // sets the data from parse
    func saveData() {
        
        if(self.user_data?[0]["name"] != nil) {
            self.nameLabel.text = self.user_data?[0]["name"] as? String
        } else {
            self.nameLabel.text = PFUser.current()?.username
            self.user_data?[0]["name"] = PFUser.current()?.username
        }
        
        if(self.user_data?[0]["age"] != nil) {
            //self.age = self.user_data?[0]["age"] as! Int
        }
        
        if(self.user_data?[0]["num_dogs"] != nil) {
            self.num_dogs = self.user_data?[0]["num_dogs"] as! Int
        }
        
        if(self.user_data?[0]["location"] != nil) {
            self.location = self.user_data?[0]["location"] as! String
        }
        else {
            self.location = "Location not found"
        }
        
        if(self.user_data?[0]["bio"] != nil) {
            self.bioText = self.user_data?[0]["bio"] as! String
        }
        
        if(self.user_data?[0]["birthday"] != nil) {
            self.birthday = self.user_data?[0]["birthday"] as? String
        }
    }
    
    // updates all the labels
    func updateTextLabels() {
        
        let birthday = self.birthday?.toDate(dateFormat: "MM/dd/yyyy")
        self.age = Int((birthday?.timeIntervalSinceNow)!/(-60*60*24*365))
        
        ageLabel.text = "\(self.age) years old"
        bioTextView.text = self.bioText
        locationLabel.text = self.location
        
        if let userPic = user_data[0].value(forKey: "profilePic") as? PFFile {
            userPic.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                let image = UIImage(data: imageData!)
                if image != nil {
                    self.profileImageView.image = image!
                }
            })
        } else {
            self.profileImageView.image = #imageLiteral(resourceName: "profile_avatar")
            print("ERROR: image not found")
        }
    }
    
    func segueToEditProfile() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "editProfileVC") as! EditProfileViewController
        vc.user_data = self.user_data
        vc.profileImage = self.profileImageView.image
        self.present(vc, animated: true, completion: nil)
        
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
