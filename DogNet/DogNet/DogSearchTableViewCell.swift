//
//  DogSearchTableViewCell.swift
//  DogNet
//
//  Created by Naveen Kashyap on 5/7/17.
//  Copyright © 2017 dognets. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class DogSearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dogNameLabel: UILabel!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var dogImageView: UIImageView!
    var owner: PFUser!
    
    var dog: Dog! {
        didSet{
            self.dogNameLabel.text = dog.name
            self.dogImageView.image = dog.dogImage
            self.ownerNameLabel.text = self.dog.owner?.username
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
