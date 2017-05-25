//
//  DogPalListViewController.swift
//  DogNet
//
//  Created by Sean Nam on 4/17/17.
//  Copyright © 2017 dognets. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class DogPalListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dogIDs: [String]! = []
    var dogs: [PFObject] = []
    var currentDog: Dog!
    
    let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    @IBOutlet weak var dogPalsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dogPalsTableView.dataSource = self
        dogPalsTableView.delegate = self
        dogPalsTableView.rowHeight = UITableViewAutomaticDimension
        dogPalsTableView.estimatedRowHeight = 120
        
        dogs = []
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dogs = []
        
        let query = PFQuery(className: "dog_data")
        query.order(byDescending: "createdAt")
        query.includeKey("id")
        query.whereKey("objectId", containedIn: dogIDs)
        query.findObjectsInBackground { (dog: [PFObject]?,error: Error?) in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(dog!.count) dogs.")
                // Do something with the found objects
                if let dog = dog {
                    for doggy in dog{
                        self.dogs.append(doggy)
                    }
                    self.dogPalsTableView.reloadData()
                }
            } else {
                // Log details of the failure
                let alertController = UIAlertController(title: "Could not get dog data", message: "Try again!", preferredStyle: .alert)
                // create a cancel action
                let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                    // handle cancel response here. Doing nothing will dismiss the view.
                }
                // add the cancel action to the alertController
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true) {
                    // optional code for what happens after the alert controller has finished presenting
                }
                print("error")
            }
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dogs != nil {
            return dogs.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dogPalsCell", for: indexPath) as! DogPalsTableViewCell
        
        let dog = dogs[indexPath.row]
        cell.dog = Dog.init(dog: dog)
        if let the_photo = dog["photo"]{
            (the_photo as AnyObject).getDataInBackground(block: {(imageData: Data?,error: Error?) in
                if error == nil {
                    if let imageData = imageData {
                        let image = UIImage(data: imageData)
                        cell.dogImage.image = image
                        cell.dog.dogImage = image
                    }
                }
            })
        }
        
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! DogPalsTableViewCell
        let dogProfile = segue.destination as! PalProfileViewController
        dogProfile.dog = cell.dog
        dogProfile.currentDog = self.currentDog
        cell.dog.dogImage = cell.dogImage.image
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
