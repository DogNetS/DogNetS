//
//  HomeViewController.swift
//  DogNet
//
//  Created by Sean Nam on 4/17/17.
//  Copyright © 2017 dognets. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var PFDogs: [PFObject]!
    var dogs: [Dog]!
    var user_data: [PFObject]!
    var name: String?
    var age:Int = 0
    var num_dogs:Int = 0
    var bioText:String = ""
    var location:String = ""
    var birthday:String?
    let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func onLogout(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "logout"), object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let query = PFQuery(className: "dog_data")
        query.order(byDescending: "createdAt")
        query.includeKey("owner")
        query.whereKey("owner", equalTo: PFUser.current()!)
        query.findObjectsInBackground { (dogs: [PFObject]?,error: Error?) in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(dogs!.count) dogs.")
                // Do something with the found objects
                if let dogs = dogs {
                    self.PFDogs = dogs
                    self.tableView.reloadData()
                }
            } else {
                // Log details of the failure
                print("error")
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /*  Get dog data from Parse */
        var query = PFQuery(className: "dog_data")
        query.order(byDescending: "createdAt")
        query.includeKey("owner")
        query.whereKey("owner", equalTo: PFUser.current())
        query.findObjectsInBackground { (dogs: [PFObject]?,error: Error?) in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(dogs!.count) dogs.")
                // Do something with the found objects
                if let dogs = dogs {
                    self.PFDogs = dogs
                    self.tableView.reloadData()
                }
            } else {
                // Log details of the failure
                print("error")
            }
        }
        
        /*  Get user_data from Parse */
        // clear fields while data is loading
        self.profileImageView.image = nil
        self.nameLabel.text = ""
        self.locationLabel.text = ""
        
        // search for PFObject with matching "owner" field
        query = PFQuery(className: "user_data")
        query.order(byDescending: "createdAt")
        query.includeKey("owner")
        query.whereKey("owner", equalTo: PFUser.current()!)
        query.limit = 20
        query.findObjectsInBackground { (user_data: [PFObject]?, error: Error?) -> Void in
            if let data = user_data {
                self.user_data = data
                
                print("user data: \(self.user_data)")
                    
                self.saveData()                         // save data from parse to local variables
                self.updateTextLabels()                 // update text labels with new values
                self.loadingIndicator.stopAnimating()   // stop activity indicator and show updated views
                
            } else {
                print("error while getting user_data")
            }
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DogCell", for: indexPath) as! DogTableViewCell
        
        let PFDog = PFDogs[indexPath.row] as! PFObject
        cell.dog = Dog.init(dog: PFDog)
        
        if let the_photo = PFDog["photo"]{
            (the_photo as AnyObject).getDataInBackground(block: {(imageData: Data?,error: Error?) in
                if error == nil {
                    if let imageData = imageData {
                        let image = UIImage(data: imageData)
                        cell.dogPhoto.image = image
                    }
                }
            })
        }else{
            cell.dogPhoto.image = UIImage(named: "dog_default")
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let PFDogs = PFDogs{
            return PFDogs.count
        }else{
            return 0
        }
    }
    
    @IBAction func profileButtonTapped(_ sender: Any) {
        let mainStoryboard = UIStoryboard( name: "Main", bundle: nil)
        let profileVC = mainStoryboard.instantiateViewController(withIdentifier: "profileVC") as! ProfileViewController
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
        self.nameLabel.text = self.name
        self.locationLabel.text = self.location
        
        if(self.user_data?[0]["profilePic"] != nil) {
            if let userPic = user_data[0].value(forKey: "profilePic")! as? PFFile {
                userPic.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                    let image = UIImage(data: imageData!)
                    if image != nil {
                        self.profileImageView.image = image!
                    }
                })
            }
        } else {
            // set default profile image
            self.profileImageView.image =  UIImage(named: "profile_avatar")
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! DogTableViewCell
        let dogProfile = segue.destination as! DogProfileViewController
        dogProfile.dog = cell.dog
        cell.dog.dogImage = cell.dogPhoto.image
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
