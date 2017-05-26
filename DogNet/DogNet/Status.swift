//
//  Status.swift
//  DogNet
//
//  Created by Naveen Kashyap on 5/25/17.
//  Copyright © 2017 dognets. All rights reserved.
//

import UIKit
import Parse

class Status: NSObject {
    
    var post_time: Int?
    var status_text: String?
    var dog: Dog?
    
    init(status: NSDictionary) {
        super.init()
        self.post_time = status["time"] as? Int ?? 0
        self.status_text = status["text"] as? String ?? "cannot find status text"
        let PFdog = status["dog"] as! PFObject
        self.dog = Dog.init(dog: PFdog)
    }

}
