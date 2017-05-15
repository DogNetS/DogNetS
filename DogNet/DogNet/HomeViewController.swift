//
//  HomeViewController.swift
//  DogNet
//
//  Created by Sean Nam on 4/17/17.
//  Copyright © 2017 dognets. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController {
    
    var user_data: [PFObject]!
    var name: String?
    var age:Int = 0
    var num_dogs:Int = 0
    var bioText:String = ""
    var location:String = ""
    let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBAction func onLogout(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "logout"), object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingIndicator.center = view.center
        loadingIndicator.startAnimating()
        view.addSubview(loadingIndicator)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        // clear fields while data is loading
        self.profileImageView.image = nil
        self.nameLabel.text = ""
        self.locationLabel.text = ""
        
        let query = PFQuery(className: "user_data")
        query.order(byDescending: "createdAt")
        query.includeKey("owner")
        query.whereKey("owner", equalTo: PFUser.current()!)
        query.limit = 20
        query.findObjectsInBackground { (user_data: [PFObject]?, error: Error?) -> Void in
            if let data = user_data {
                self.user_data = data
                
                self.saveData()
                self.updateTextLabels()
                self.loadingIndicator.stopAnimating()
                
                
            } else {
                print("error while getting user_data")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func profileButtonTapped(_ sender: Any) {
        let mainStoryboard = UIStoryboard( name: "Main", bundle: nil)
        let profileVC = mainStoryboard.instantiateViewController(withIdentifier: "profileVC") as! ProfileViewController
        //profileVC.user_data = self.user_data
        self.navigationController?.pushViewController(profileVC, animated: true)
    }

    @IBAction func addDog(_ sender: Any) {
        let mainStoryboard = UIStoryboard( name: "Main", bundle: nil)
        let dogSignUpVC = mainStoryboard.instantiateViewController(withIdentifier: "dogSignUpVC") as! DogSignup1ViewController
        self.navigationController?.present(dogSignUpVC, animated: true, completion: nil)
    }
    
    // saves the data from parse locally
    func saveData() {
        
        if(self.user_data?[0]["name"] != nil) {
            self.name = self.user_data?[0]["name"] as? String
        } else {
            self.name = (PFUser.current()?.username)! as String
        }

        if(self.user_data?[0]["location"] != nil) {
            self.location = self.user_data?[0]["location"] as! String
        } else {
            self.location = "Location not found"
        }

    }
    
    func updateTextLabels() {
        nameLabel.text = self.name
        locationLabel.text = self.location
        
        if(self.user_data?[0]["profilePic"] != nil) {
            //self.nameLabel.text = self.user_data?[0]["profilePic"] as? String
            if let userPic = user_data[0].value(forKey: "profilePic")! as? PFFile {
                userPic.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                    let image = UIImage(data: imageData!)
                    if image != nil {
                        self.profileImageView.image = image!
                    }
                })
            }
        } else {
            self.profileImageView.image =  UIImage(named: "profile_avatar")
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        
        let dogprofile = segue.destination as! DogProfileViewController
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
