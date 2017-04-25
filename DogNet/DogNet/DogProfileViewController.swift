//
//  DogProfileViewController.swift
//  DogNet
//
//  Created by Sean Nam on 4/17/17.
//  Copyright © 2017 dognets. All rights reserved.
//

import UIKit

class DogProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "My Pals", style: .plain, target: self, action: "MyPalsTapped")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func MyPalsTapped(){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let palsVC = mainStoryboard.instantiateViewController(withIdentifier: "palsVC") as! DogPalListViewController
        self.navigationController?.pushViewController(palsVC, animated: true)

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
