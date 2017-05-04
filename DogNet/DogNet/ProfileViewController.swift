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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let user = PFUser.current()
        nameLabel.text = user?.username
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let query = PFQuery(className: "user_data")
        query.order(byDescending: "createdAt")
        query.includeKey("owner")
        query.whereKey("owner", equalTo: PFUser.current()!)
        query.limit = 20
        query.findObjectsInBackground { (user_data: [PFObject]?, error: Error?) -> Void in
            if let data = user_data {
                self.user_data = data
                print("insde: user data: \(self.user_data)")
                
                self.saveData()
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
    
    func saveData() {
        self.age = self.user_data?[0]["age"] as! Int
        self.num_dogs = self.user_data?[0]["num_dogs"] as! Int
        self.location = self.user_data?[0]["location"] as! String
        self.bioText = self.user_data?[0]["bio"] as! String
    }
    
    func updateTextLabels() {
        ageLabel.text = "\(self.age)"
        bioTextView.text = self.bioText
        locationLabel.text = self.location
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
