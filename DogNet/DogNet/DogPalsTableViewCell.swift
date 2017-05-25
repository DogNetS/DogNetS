//
//  DogPalsTableViewCell.swift
//  DogNet
//
//  Created by Cong Tam Quang Hoang on 24/05/17.
//  Copyright © 2017 dognets. All rights reserved.
//

import UIKit
import Parse

class DogPalsTableViewCell: UITableViewCell {
    @IBOutlet weak var dogImage: UIImageView!
    @IBOutlet weak var dogName: UILabel!
    @IBOutlet weak var dogBreed: UILabel!
    @IBOutlet weak var dogAge: UILabel!
    @IBOutlet weak var owner: UILabel!
    @IBOutlet weak var dogPalsCount: UILabel!
    
    var dog: Dog!{
        didSet{
            self.dogName.text = dog.name
            if dog.pals.count == 1 {
                self.dogPalsCount.text = "1 Pal"
            } else {
                self.dogPalsCount.text = "\(dog.pals.count) Pals"
            }
            self.dogBreed.text = dog.breed
            self.dogAge.text = dog.birthday //change to age instead of birthday
            self.dogImage.image = dog.dogImage
            self.dog.owner?.fetchIfNeededInBackground { (dogOwner: PFObject?, error: Error?) in
                if dogOwner != nil {
                    print(dogOwner ?? "cannot print dogOwner")
                    self.owner.text = self.dog.owner?.username
                } else {
                    print(error?.localizedDescription ?? "Cannot find owner")
                }
            }
            
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
