//
//  ProfileViewController.swift
//  DogNet
//
//  Created by Sean Nam on 4/17/17.
//  Copyright © 2017 dognets. All rights reserved.
//

import UIKit
import Parse

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
    let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(ProfileViewController.segueToEditProfile))
        self.navigationItem.rightBarButtonItem = edit
        self.navigationItem.title = "Profile"
        
        loadingIndicator.center = view.center
        loadingIndicator.startAnimating()
        view.addSubview(loadingIndicator)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // clear fields while data is loading
        self.profileImageView.image = nil
        self.nameLabel.text = ""
        self.ageLabel.text = ""
        self.locationLabel.text = ""
        self.bioTextView.text = ""
        
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
                self.loadingIndicator.stopAnimating()
                self.updateTextLabels()
                
            } else {
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
        
        // check if image exists before setting
        if let userPic = user_data[0].value(forKey: "profilePic") as? PFFile {
            userPic.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                let image = UIImage(data: imageData!)
                if image != nil {
                    self.profileImageView.image = image!
                }
            })
        } else {
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
