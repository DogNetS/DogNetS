//
//  DogProfileViewController.swift
//  DogNet
//
//  Created by Sean Nam on 4/17/17.
//  Copyright © 2017 dognets. All rights reserved.
//

import UIKit
import Parse

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
    var statuses: [NSDictionary]!
    //need to add pals list, age.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusTableView.estimatedRowHeight = 150
        statusTableView.rowHeight = UITableViewAutomaticDimension
        
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        cell.dog = dog
        return cell
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
