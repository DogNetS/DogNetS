//
//  DogProfileViewController.swift
//  DogNet
//
//  Created by Sean Nam on 4/17/17.
//  Copyright © 2017 dognets. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class DogProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dog: Dog! // Dog model passed from the cell we tapped one.
    
    @IBOutlet weak var dogImage: UIImageView!
    @IBOutlet weak var dogName: UILabel!
    @IBOutlet weak var dogsOwner: UILabel!
    @IBOutlet weak var dogBreed: UILabel!
    @IBOutlet weak var dogsHealth: UILabel!
    @IBOutlet weak var dogsTemperament: UILabel!
    @IBOutlet weak var dogsToys: UILabel!
    @IBOutlet weak var dogsBirthday: UILabel!
    @IBOutlet weak var dogsAge: UILabel!
    @IBOutlet weak var statusTableView: UITableView!
    var statuses: [NSDictionary]! = []
    //need to add pals list, age.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.statusTableView.estimatedRowHeight = 150
        self.statusTableView.rowHeight = UITableViewAutomaticDimension
        self.statusTableView.delegate = self
        self.statusTableView.dataSource = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit Info", style: .plain, target: self, action: #selector(DogProfileViewController.EditInfoTapped))
        
        //getting dog info through the Dog Model passed from the cell.
        self.dogName.text = dog.name
        self.dogsOwner.text = dog.owner?.username
        self.dogBreed.text = dog.breed
        self.dogsHealth.text = "Health: " + dog.health!
        self.dogsTemperament.text = "Temperament: " + dog.temperament!
        self.dogsToys.text = "Toys: " + dog.toys!
        self.dogImage.image = dog.dogImage
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        let birthdayDate = dog.birthday!.toDate(dateFormat: "MM/dd/yyyy")
        var age = Int(birthdayDate.timeIntervalSinceNow/(-60*60*24*365))
        if (age == 0){
            age = Int(birthdayDate.timeIntervalSinceNow/(-60*60*24*30))
            if (age == 0){
                age = Int(birthdayDate.timeIntervalSinceNow/(-60*60*24))
                if ( age == 1){
                    self.dogsAge.text = "\(age)" + " day old"
                }else{
                    self.dogsAge.text = "\(age)" + " days old"
                }
            }else if (age == 1){
                self.dogsAge.text = "\(age)" + " month old"
            }else{
                self.dogsAge.text = "\(age)" + " months old"
            }
        }else{
            if ( age == 1){
                self.dogsAge.text = "\(age)" + " year old"
            }else{
                self.dogsAge.text = "\(age)" + " years old"
            }
        }
        self.dogsBirthday.text = "Birthday: " + dateFormatter.string(from: birthdayDate)

        //set age etc
        
        // Do any additional setup after loading the view.
        fetchStatuses()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.dogName.text = dog.name
        self.dogsOwner.text = dog.owner?.username
        self.dogBreed.text = dog.breed
        self.dogsHealth.text = "Health: " + dog.health!
        self.dogsTemperament.text = "Temperament: " + dog.temperament!
        self.dogsToys.text = "Toys: " + dog.toys!
        self.dogImage.image = dog.dogImage
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none

        let birthdayDate = dog.birthday!.toDate(dateFormat: "MM/dd/yyyy")
        var age = Int(birthdayDate.timeIntervalSinceNow/(-60*60*24*365))
        if (age == 0){
            age = Int(birthdayDate.timeIntervalSinceNow/(-60*60*24*30))
            if (age == 0){
                age = Int(birthdayDate.timeIntervalSinceNow/(-60*60*24))
                if ( age == 1){
                    self.dogsAge.text = "Age: " + "\(age)" + " day"
                }else{
                    self.dogsAge.text = "Age: " + "\(age)" + " days"
                }
            }else if (age == 1){
                self.dogsAge.text = "Age: " + "\(age)" + " month"
            }else{
                self.dogsAge.text = "Age: " + "\(age)" + " months"
            }
        }else{
            if ( age == 1){
                self.dogsAge.text = "Age: " + "\(age)" + " year"
            }else{
                self.dogsAge.text = "Age: " + "\(age)" + " years"
            }
        }
        self.dogsBirthday.text = "Birthday: " + dateFormatter.string(from: birthdayDate)
        
        if let selectedCellIndex = statusTableView.indexPathForSelectedRow {
            statusTableView.deselectRow(at: selectedCellIndex, animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchStatuses(){
        /*
         go through list of pals
         for each pal, get statuses
         perhaps order them by time
         */
        print("**********fetching statuses")
        statuses.removeAll()
        var palIDs = dog.pals
        palIDs.append(dog.id!)
        
        let query = PFQuery(className: "dog_data")
        query.order(byDescending: "updatedAt")
        query.includeKey("statuses")
        query.whereKey("objectId", containedIn: palIDs)
        MBProgressHUD.showAdded(to: self.view , animated: true)
        query.findObjectsInBackground { (PFdogs: [PFObject]?, error: Error?) in
            if let PFdogs = PFdogs {
                print("1")
                MBProgressHUD.hide(for: self.view , animated: true)
                for PFdog in PFdogs {
                    let dogStatusList = (PFdog["statuses"] as? [NSDictionary]) ?? ([])
                    print("2")
                    print(dogStatusList)
                    for dogStatus in dogStatusList {
                        print("2a")
                        var newStatus = Dictionary<String, Any>()
                        newStatus.updateValue(dogStatus["text"] ?? "no text", forKey: "text")
                        newStatus.updateValue(dogStatus["time"] ?? "no time", forKey: "time")
                        newStatus.updateValue(PFdog, forKey: "dog")
                        print(newStatus)

                        self.statuses.append(newStatus as NSDictionary)
                    }
                    print("self.statuses")
                    print(self.statuses)
                    self.statusTableView.reloadData()
                    
                    //    PFdog["statuses"] = self.statuses
                }
            } else {
                print("4")
                MBProgressHUD.hide(for: self.view , animated: true)
                // Log details of the failure
                let alertController = UIAlertController(title: "Could not get pal statuses", message: "Try again!", preferredStyle: .alert)
                // create a cancel action
                let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                    // handle cancel response here. Doing nothing will dismiss the view.
                }
                // add the cancel action to the alertController
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true) {
                    // optional code for what happens after the alert controller has finished presenting
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let statuses = statuses {
            return statuses.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "statusCell", for: indexPath) as! DogStatusTableViewCell
        let status = statuses[indexPath.row]
        cell.status = Status.init(status: status)
        let PFDog = status["dog"] as! PFObject
        if let the_photo = (PFDog["photo"]){
            (the_photo as AnyObject).getDataInBackground(block: {(imageData: Data?,error: Error?) in
                if error == nil {
                    if let imageData = imageData {
                        let image = UIImage(data: imageData)
                        cell.status.dog?.dogImage = image
                        cell.dogImage.image = image
                        
                    }
                }
            })
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Change the selected background view of the cell.
        
        //tableView.deselectRow(at: indexPath, animated: false)
        //tableView.reloadRows(at: [indexPath], with: .automatic)
        
        print("selecting \(indexPath)")
    }
    
    func EditInfoTapped(){
        let mainStoryboard = UIStoryboard( name: "Main", bundle: nil)
        let dogEditVC = mainStoryboard.instantiateViewController(withIdentifier: "dogEditVC") as! DogEditViewController
        dogEditVC.dog = self.dog
        self.navigationController?.present(dogEditVC, animated: true, completion: nil)
    }
    
    @IBAction func onUpdateStatus(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let updateVC = mainStoryboard.instantiateViewController(withIdentifier: "statusVC") as! StatusViewController
        updateVC.dog = self.dog
        self.navigationController?.pushViewController(updateVC, animated: true)
    }

    @IBAction func MyPalsButtonTapped(_ sender: Any) {
        let mainStoryboard = UIStoryboard( name: "Main", bundle: nil)
        let dogPalsVC = mainStoryboard.instantiateViewController(withIdentifier: "dogPalsVC") as! DogPalListViewController
        dogPalsVC.dogIDs = dog.pals
        dogPalsVC.currentDog = self.dog
        self.navigationController?.pushViewController(dogPalsVC, animated: true)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dogSearch = segue.destination as! DogSearchViewController
        dogSearch.currentDog = self.dog
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
