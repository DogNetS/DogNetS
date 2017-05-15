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
    var dogImage: UIImage?            //image of the dog
    var temperament: String?      //temperament
    var toys: String?             //favorite toys
    var owner: PFUser?           //owner parameter
    var pals: [Dog] = []         //dictionary of pals
    
    var dog = PFObject(className: "dog_data")
    var photo_Dog = UIImage(named: "dog_default")
    //initialize the dog model so that don't need to access parse all the time
    init(dog: PFObject) {
        super.init()
        self.dog = dog
        
        self.name = dog["name"] as! String?
        self.breed = dog["breed"] as! String?
        self.birthday = dog["birthday"] as! String?
        self.health = dog["health"] as! String?
        self.temperament = dog["temper"] as! String?
        self.toys = dog["fav_toy"] as! String?
        self.owner = dog["owner"] as! PFUser?
        
        //pals
        
    }
    
    func getPhoto(the_photo: AnyObject, completion: @escaping (UIImage?)->()) {
        (the_photo as AnyObject).getDataInBackground(block: { (imageData: Data?,error: Error?) in
            if error == nil {
                if let imageData = imageData {
                    completion(UIImage(data: imageData))
                }
            }
        })
    }

    
    //need to add more parameters for other info
    class func editDogInfo(name: String?, breed: String?,/* owner: PFUser?, */withCompletion completion: PFBooleanResultBlock?){
        let dog = PFObject(className: "Dog")
        
        dog["name"] = name
        dog["breed"] = breed
        //dog["owner"] = owner
        
        dog.saveInBackground(block: completion)
        
    }
    
    /**
     Method to convert UIImage to PFFile
     
     - parameter image: Image that the user wants to upload to parse
     
     - returns: PFFile for the the data in the image
     */
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }

}

