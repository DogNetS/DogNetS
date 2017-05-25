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
    
    var id: String?               //id to compare dogs
    var name: String?             //name of the dog
    var breed: String?            //breed of the dog
    var birthday: String?         //birthday of the dog, maybe not String?
    var health: String?           //health parameters
    var dogImage: UIImage?        //image of the dog
    var temperament: String?      //temperament
    var toys: String?             //favorite toys
    var owner: PFUser?            //owner parameter
    var pals: [String] = []              //dictionary of pals
    
    
    
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
        self.id = dog.objectId as! String?
        if let pals = dog["pals"]{
            self.pals = pals as! [String]
        }
        
        
        
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
    
    //function to compare dogs
    func equals(dog: Dog?) -> (Bool){

        if((self.name == dog?.name) && (self.id == dog?.id)){
            return true
        }else{
            return false
        }
        
    }
    
    func checkPal(dog: Dog?) -> Bool{
        for pal in pals{
            if dog?.id == pal{
                print("got the pal")
                return true
            }
        }
        return false
    }
    
    //function to edit dogs
    func updateDog(name: String?, breed: String?, birthday: String?, image: UIImage?, health: String?, temp: String?, toys: String?, palId: String?, withCompletion completion: PFBooleanResultBlock?) {
            
        let query = PFQuery(className: "dog_data")
        query.order(byDescending: "createdAt")
        query.includeKey("owner")
        query.whereKey("owner", equalTo: owner!)
        query.findObjectsInBackground { (dogs: [PFObject]?,error: Error?) in
            if error == nil {
                if let dogs = dogs {
                    for doggy in dogs{
                        //finding the dog we are editing from Parse
                        
                        
                        if self.equals(dog: Dog.init(dog: doggy)){
                            if(name != nil){
                                doggy["name"] = name
                                self.name = name
                            }
                            if(breed != nil){
                                doggy["breed"] = breed
                                self.breed = breed
                            }
                            if(birthday != nil){
                                doggy["birthday"] = birthday
                                self.birthday = birthday
                            }
                            if(image != nil){
                                doggy["image"] = Dog.getPFFileFromImage(image: image)
                                self.dogImage = image
                            }
                            if(health != nil){
                                doggy["health"] = health
                                self.health = health
                            }
                            if(temp != nil){
                                doggy["temper"] = temp
                                self.temperament = temp
                            }
                            if(toys != nil){
                                doggy["fav_toy"] = toys
                                self.toys = toys
                            }
                            if(palId != nil){
                            
                                self.pals.append(palId!)
                                doggy["pals"] = self.pals
                            }
                            
                            //save the data 
                            doggy.saveInBackground(block: completion)
                        }
                    }

                }
            } else {
                // Log details of the failure
                print("error while saving dog's data")
            }
        }
    }
    
    func deleteDog(palId: String?, withCompletion completion: PFBooleanResultBlock?){
        let query = PFQuery(className: "dog_data")
        query.order(byDescending: "createdAt")
        query.includeKey("owner")
        query.whereKey("owner", equalTo: owner!)
        query.findObjectsInBackground { (dogs: [PFObject]?,error: Error?) in
            if error == nil {
                if let dogs = dogs {
                    for doggy in dogs{
                        //finding the dog we are editing from Parse
                        
                        
                        if self.equals(dog: Dog.init(dog: doggy)){
                            if(palId != nil){
                                
                                for (index, pal) in self.pals.enumerated() {
                                    if (palId == pal){
                                        self.pals.remove(at: index)
                                    }
                                }
                                doggy["pals"] = self.pals
                            }
                            
                            //save the data
                            doggy.saveInBackground(block: completion)
                        }
                    }
                    
                }
            } else {
                // Log details of the failure
                print("error while saving dog's data")
            }
        }
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

