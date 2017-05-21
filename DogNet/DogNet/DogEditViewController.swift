//
//  DogEditViewController.swift
//  DogNet
//
//  Created by Cong Tam Quang Hoang on 20/05/17.
//  Copyright © 2017 dognets. All rights reserved.
//

import UIKit

class DogEditViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var breedField: UITextField!
    @IBOutlet weak var birthdayField: UITextField!
    @IBOutlet weak var healthField: UITextField!
    @IBOutlet weak var tempField: UITextField!
    @IBOutlet weak var toysField: UITextField!
    @IBOutlet weak var photoField: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
