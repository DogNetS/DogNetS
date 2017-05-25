//
//  PalProfileViewController.swift
//  DogNet
//
//  Created by Cong Tam Quang Hoang on 22/05/17.
//  Copyright © 2017 dognets. All rights reserved.
//
import Parse
import UIKit
import MBProgressHUD

class PalProfileViewController: UIViewController {

    @IBOutlet weak var addDeleteButton: UIButton!
    var dog: Dog! // Dog model passed from the cell we tapped one.
    var currentDog: Dog!
    
    @IBOutlet weak var dogName: UILabel!
    @IBOutlet weak var dogOwner: UILabel!
    @IBOutlet weak var dogBreed: UILabel!
    @IBOutlet weak var dogAge: UILabel!
    @IBOutlet weak var dogBirthday: UILabel!
    @IBOutlet weak var dogHealth: UILabel!
    @IBOutlet weak var dogTemper: UILabel!
    @IBOutlet weak var dogToys: UILabel!
    @IBOutlet weak var dogImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(currentDog.checkPal(dog: dog)){
            addDeleteButton.titleLabel?.text = "Delete Pal"
        }else{
            addDeleteButton.titleLabel?.text = "Add Pal"
        }

        self.dogName.text = dog.name
        self.dogOwner.text = dog.owner?.username
        self.dogBreed.text = dog.breed
        self.dogHealth.text = "Health: " + dog.health!
        self.dogTemper.text = "Temperament: " + dog.temperament!
        self.dogToys.text = "Toys: " + dog.toys!
        self.dogImage.image = dog.dogImage
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none

        
        var birthdayDate = dog.birthday!.toDate(dateFormat: "MM/dd/yyyy")
        var age = Int(birthdayDate.timeIntervalSinceNow/(-60*60*24*365))
        if (age == 0){
            age = Int(birthdayDate.timeIntervalSinceNow/(-60*60*24*30))
            if (age == 0){
                age = Int(birthdayDate.timeIntervalSinceNow/(-60*60*24))
                if ( age == 1){
                    self.dogAge.text = "Age: " + "\(age)" + " day"
                }else{
                    self.dogAge.text = "Age: " + "\(age)" + " days"
                }
            }else if (age == 1){
                self.dogAge.text = "Age: " + "\(age)" + " month"
            }else{
                self.dogAge.text = "Age: " + "\(age)" + " months"
            }
        }else{
            if ( age == 1){
                self.dogAge.text = "Age: " + "\(age)" + " year"
            }else{
                self.dogAge.text = "Age: " + "\(age)" + " years"
            }
        }
        self.dogBirthday.text = "Birthday: " + dateFormatter.string(from: birthdayDate)

        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(currentDog.checkPal(dog: dog)){
            addDeleteButton.titleLabel?.text = "Delete Pal"
        }else{
            addDeleteButton.titleLabel?.text = "Add Pal"
        }
    }

    @IBAction func addPal(_ sender: Any) {
        if(!currentDog.checkPal(dog: dog)){
            MBProgressHUD.showAdded(to: self.view , animated: true)
            currentDog.updateDog(name: nil, breed: nil, birthday: nil, image: nil, health: nil, temp: nil, toys: nil, palId: dog.id) {(success: Bool, error: Error?) in
                if success {
                    print("[DEBUG] successfully updated current dog")
                    self.addDeleteButton.titleLabel?.text = "Delete Pal"
                } else {
                    print("[DEBUG] fail to update current dog")
                    let alertController = UIAlertController(title: "Could not update pals", message: "Try again!", preferredStyle: .alert)
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
            dog.updateDog(name: nil, breed: nil, birthday: nil, image: nil, health: nil, temp: nil, toys: nil, palId: currentDog.id) {(success: Bool, error: Error?) in
                if success {
                    print("[DEBUG] successfully updated pal dog")
                } else {
                    print("[DEBUG] fail to update pal dog")
                    let alertController = UIAlertController(title: "Could not update pals", message: "Try again!", preferredStyle: .alert)
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
            MBProgressHUD.hide(for: self.view , animated: true)
        }else{
            currentDog.deleteDog(palId: dog.id) {(success: Bool,error: Error?) in
                if success {
                    print("[DEBUG] successfully deleted pal from the current dog")
                    self.addDeleteButton.titleLabel?.text = "Add Pal"
                }else{
                    print("[DEBUG] fail to delete pal from current dog")
                    let alertController = UIAlertController(title: "Could not update pals", message: "Try again!", preferredStyle: .alert)
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
            dog.deleteDog(palId: currentDog.id) {(success: Bool,error: Error?) in
                if success {
                    print("[DEBUG] successfully deleted current dog from the pal dog")
                }else{
                    print("[DEBUG] fail to delete current dog from pal dog")
                    let alertController = UIAlertController(title: "Could not update pals", message: "Try again!", preferredStyle: .alert)
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
            MBProgressHUD.hide(for: self.view , animated: true)

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
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
