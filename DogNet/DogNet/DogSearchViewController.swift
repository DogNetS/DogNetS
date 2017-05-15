//
//  DogSearchViewController.swift
//  DogNet
//
//  Created by Naveen Kashyap on 5/7/17.
//  Copyright © 2017 dognets. All rights reserved.
//

import UIKit
import Parse

class DogSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var dogSearchBar: UISearchBar!
    @IBOutlet weak var dogSearchTableView: UITableView!
    var dogs: [Dog]! = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dogSearchTableView.dataSource = self
        dogSearchTableView.delegate = self
        dogSearchTableView.rowHeight = UITableViewAutomaticDimension
        dogSearchTableView.estimatedRowHeight = 120
        dogSearchBar.delegate = self
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "dogSearchCell", for: indexPath) as! DogSearchTableViewCell
        let dog = dogs[indexPath.row]
        cell.dog = dog
        return cell
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text
        let query = PFQuery(className: "dog_data")
        query.whereKey("name", contains: searchText)
        
        query.findObjectsInBackground{ (pfdogs: [PFObject]?, error: Error?) in
            if let pfdogs = pfdogs {
                for pfdog in pfdogs {
                    let dog = Dog.init(dog: pfdog)
                    self.dogs.insert(dog, at: 0)
                }
                self.dogSearchTableView.reloadData()
            } else {
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dogs.removeAll(keepingCapacity: false)
        dogSearchTableView.reloadData()
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