//
//  Dog.swift
//  DogNet
//
//  Created by Cong Tam Quang Hoang on 01/05/17.
//  Copyright © 2017 dognets. All rights reserved.
//

import UIKit
import Parse

class Dog: NSObject {
    
    var name: String?             //name of the dog
    var breed: String?            //breed of the dog
    var birthday: String?         //birthday of the dog, maybe not String?
    var health: String?           //health parameters
    var dogImageUrl: URL?         //image of the dog
    var temperament: String?      //temperament
    var toys: String?             //favorite toys
    //var owner: PFUser?           //owner parameter
    var pals: [Dog] = []     //dictionary of pals
    
    var dog = PFObject(className: "Dog")
    
    //initialize the dog model so that don't need to access parse all the time
    init(dog: PFObject) {
        self.dog = dog
        
        self.name = dog["name"] as! String?
        self.breed = dog["breed"] as! String?
        self.health = dog["health"] as! String?
        self.temperament = dog["temperament"] as! String?
        self.toys = dog["toys"] as! String?
        self.dogImageUrl = dog["dogImageUrl"] as! URL?
        
    }
    
    //need to add more parameters for other info
    class func editDogInfo(name: String?, breed: String?,/* owner: PFUser?, */withCompletion completion: PFBooleanResultBlock?){
        let dog = PFObject(className: "Dog")
        
        
        dog["name"] = name
        dog["breed"] = breed
        //dog["owner"] = owner
        
        dog.saveInBackground(block: completion)
        
    }
}

