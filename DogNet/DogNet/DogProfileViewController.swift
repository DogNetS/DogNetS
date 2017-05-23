//
//  DogProfileViewController.swift
//  DogNet
//
//  Created by Sean Nam on 4/17/17.
//  Copyright © 2017 dognets. All rights reserved.
//

import UIKit
import Parse

class DogProfileViewController: UIViewController {
    
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
    //need to add pals list, age.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "MyPals", style: .plain, target: self, action: #selector(DogProfileViewController.MyPalsTapped))
        
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
        
        var birthdayDate = dog.birthday!.toDate(dateFormat: "MM/dd/yyyy")
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func MyPalsTapped(){
        let mainStoryboard = UIStoryboard( name: "Main", bundle: nil)
        let dogPalsVC = mainStoryboard.instantiateViewController(withIdentifier: "dogPalsVC") as! DogPalListViewController
        self.navigationController?.pushViewController(dogPalsVC, animated: true)

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
