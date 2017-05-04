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
    //need to add pals list, age/birthday.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "MyPals", style: .plain, target: self, action: "MyPalsTapped")
        
        //getting dog info through the Dog Model passed from the cell.
        self.dogName.text = dog.name
        self.dogsOwner.text = dog.owner?.username
        self.dogBreed.text = dog.breed
        self.dogsHealth.text = "Health: " + dog.health!
        self.dogsTemperament.text = "Temperament: " + dog.temperament!
        self.dogsToys.text = "Toys: " + dog.toys!

        //set the image too
        
        
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
