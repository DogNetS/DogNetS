//
//  DogSignup1ViewController.swift
//  DogNet
//
//  Created by Sean Nam on 4/17/17.
//  Copyright © 2017 dognets. All rights reserved.
//

import UIKit
import Parse

class DogSignup1ViewController: UIViewController {
    @IBOutlet weak var dogNameTextField: UITextField!
    @IBOutlet weak var dogBreedTextField: UITextField!
    @IBOutlet weak var dogBirthdayTextField: UITextField!
    @IBOutlet weak var dogHealthTextField: UITextField!
    @IBOutlet weak var dogFavToysTextField: UITextField!
    @IBOutlet weak var dogTemperTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addedDog(_ sender: Any) {
        
        let dog = PFObject(className: "dog_data")
        
        dog["name"] = dogNameTextField.text
        dog["breed"] = dogBreedTextField.text
        dog["birthday"] = dogBirthdayTextField.text
        dog["health"] = dogHealthTextField.text
        dog["fav_toy"] = dogFavToysTextField.text
        dog["temper"] = dogTemperTextField.text
        
        dog.saveInBackground { (wasSuccessful: Bool, error: Error?) in
            if (wasSuccessful) {
                print("dog added!")
                self.dismiss(animated: true, completion: nil)
            } else {
                print(error?.localizedDescription ?? "Something went wrong while adding dog")
            }
        }
        
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
