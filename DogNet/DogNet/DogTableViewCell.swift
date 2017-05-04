//
//  DogTableViewCell.swift
//  DogNet
//
//  Created by Cong Tam Quang Hoang on 01/05/17.
//  Copyright © 2017 dognets. All rights reserved.
//

import UIKit

class DogTableViewCell: UITableViewCell {

    @IBOutlet weak var dogName: UILabel!
    @IBOutlet weak var numberOfPals: UILabel!
    @IBOutlet weak var breed: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var dogPhoto: UIImageView!
    var dog: Dog!{
        didSet{
            self.dogName.text = dog.name
            self.numberOfPals.text = "\(dog.pals.count)"
            self.breed.text = dog.breed
            self.age.text = dog.birthday //change to age instead of birthday
            //self.dogPhoto.image = dog.dogImageUrl
            
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
