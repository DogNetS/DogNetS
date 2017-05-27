//
//  DogStatusTableViewCell.swift
//  DogNet
//
//  Created by Naveen Kashyap on 5/25/17.
//  Copyright © 2017 dognets. All rights reserved.
//

import UIKit

class DogStatusTableViewCell: UITableViewCell {
    @IBOutlet weak var dogImage: UIImageView!
    @IBOutlet weak var dogNameLabel: UILabel!
    @IBOutlet weak var dogStatusText: UILabel!
    @IBOutlet weak var dogPostTime: UILabel!
    
    var status: Status! {
        didSet {
            self.dogStatusText.text = status.status_text
            self.dogPostTime.text = "\(status.post_time ?? 0)"
            self.dogNameLabel.text = status.dog?.name
            self.dogImage.image = status.dog?.dogImage
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
