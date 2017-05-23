//
//  PalProfileViewController.swift
//  DogNet
//
//  Created by Cong Tam Quang Hoang on 22/05/17.
//  Copyright © 2017 dognets. All rights reserved.
//

import UIKit

class PalProfileViewController: UIViewController {

    var dog: Dog! // Dog model passed from the cell we tapped one.
    
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
