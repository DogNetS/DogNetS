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
        // Do any additional setup after loading the view.
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
