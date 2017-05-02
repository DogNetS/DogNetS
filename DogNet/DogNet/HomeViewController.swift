//
//  HomeViewController.swift
//  DogNet
//
//  Created by Sean Nam on 4/17/17.
//  Copyright © 2017 dognets. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBAction func onLogout(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "logout"), object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func profileButtonTapped(_ sender: Any) {
        let mainStoryboard = UIStoryboard( name: "Main", bundle: nil)
        let profileVC = mainStoryboard.instantiateViewController(withIdentifier: "profileVC") as! ProfileViewController
        self.navigationController?.pushViewController(profileVC, animated: true)
    }

    @IBAction func addDog(_ sender: Any) {
        let mainStoryboard = UIStoryboard( name: "Main", bundle: nil)
        let dogSignUpVC = mainStoryboard.instantiateViewController(withIdentifier: "dogSignUpVC") as! DogSignup1ViewController
        self.navigationController?.present(dogSignUpVC, animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        
        let dogprofile = segue.destination as! DogProfileViewController
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
