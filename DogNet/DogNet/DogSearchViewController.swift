//
//  DogSearchViewController.swift
//  DogNet
//
//  Created by Naveen Kashyap on 5/7/17.
//  Copyright © 2017 dognets. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class DogSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var dogSearchBar: UISearchBar!
    @IBOutlet weak var dogSearchTableView: UITableView!
    var dogs: [PFObject]! = []
    var currentDog: Dog!

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        dogSearchTableView.dataSource = self
        dogSearchTableView.delegate = self
        dogSearchTableView.rowHeight = UITableViewAutomaticDimension
        dogSearchTableView.estimatedRowHeight = 120
        dogSearchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.dogSearchTableView.reloadData()
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dogSearchCell", for: indexPath) as! DogSearchTableViewCell
        let PFdog = dogs[indexPath.row]
        cell.dog = Dog.init(dog: PFdog)
        if let the_photo = PFdog["photo"]{
            (the_photo as AnyObject).getDataInBackground(block: {(imageData: Data?,error: Error?) in
                if error == nil {
                    if let imageData = imageData {
                        let image = UIImage(data: imageData)
                        cell.dogImageView.image = image
                        cell.dog.dogImage = image
                    }
                }
            })
        }

        

        return cell
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dogs.removeAll()
        let searchText = searchBar.text
        let query = PFQuery(className: "dog_data")
        query.whereKey("name", contains: searchText)
        query.whereKey("owner", notEqualTo: PFUser.current()!)
        
        MBProgressHUD.showAdded(to: self.view , animated: true)
        query.findObjectsInBackground{ (pfdogs: [PFObject]?, error: Error?) in
            if error == nil {
                if let pfdogs = pfdogs {
                    MBProgressHUD.hide(for: self.view , animated: true)
                    for pfdog in pfdogs {
                        let dog = pfdog
                        self.dogs.insert(dog, at: 0)
                    }
                    self.dogSearchTableView.reloadData()
                }
            } else {
                MBProgressHUD.hide(for: self.view , animated: true)
                let alertController = UIAlertController(title: "Could not search for dog", message: "Try again!", preferredStyle: .alert)
                // create a cancel action
                let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                    // handle cancel response here. Doing nothing will dismiss the view.
                }
                // add the cancel action to the alertController
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true) {
                    // optional code for what happens after the alert controller has finished presenting
                }

                print(error?.localizedDescription as Any)
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dogs.removeAll()
        dogSearchTableView.reloadData()
    }

    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! DogSearchTableViewCell
        let dogProfile = segue.destination as! PalProfileViewController
        dogProfile.dog = cell.dog
        dogProfile.currentDog = self.currentDog
        cell.dog.dogImage = cell.dogImageView.image
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
