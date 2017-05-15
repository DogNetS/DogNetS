//
//  DogSearchTableViewCell.swift
//  DogNet
//
//  Created by Naveen Kashyap on 5/7/17.
//  Copyright © 2017 dognets. All rights reserved.
//

import UIKit
import Parse

class DogSearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dogNameLabel: UILabel!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var dogImageView: UIImageView!
    
    var dog: Dog! {
        didSet{
            print(dog ?? "cannot print dog")
            dogNameLabel.text = dog.name
            dog.owner?.fetchIfNeededInBackground().continue({ (task: BFTask<PFObject>) -> Any? in
                if task.error != nil {
                    print(task.error?.localizedDescription ?? "Cannot find owner")
                    return false
                } else {
                    print("owner found: ")
                    print(self.dog.owner?.username! ?? "cannot print dog owner name")
                    self.ownerNameLabel.text = self.dog.owner?.username!
                    return true
                }
            })
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        

        // Configure the view for the selected state
    }

}
