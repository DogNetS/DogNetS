//
//  StatusViewController.swift
//  DogNet
//
//  Created by Naveen Kashyap on 5/25/17.
//  Copyright © 2017 dognets. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class StatusViewController: UIViewController, UITextViewDelegate {
    
    var dog: Dog!
    @IBOutlet weak var statusText: UITextView!
    @IBOutlet weak var postButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        statusText.delegate = self
        statusText.text = "Tell your palls what you're doing!"
        statusText.textColor = UIColor.lightGray
        
        statusText.becomeFirstResponder()
        
        statusText.selectedTextRange = statusText.textRange(from: statusText.beginningOfDocument, to: statusText.beginningOfDocument)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText = textView.text
        let updatedText = currentText?.replacingCharacters(in: range, with: text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGray
            
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            
            return false
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, clear
            // the text view and set its color to black to prepare for
            // the user's entry
        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        
        return true
    }
 */
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Tell your palls what you're doing!"
            textView.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func onPost(_ sender: Any) {
        let status_text = statusText.text
        let time = Date().timeIntervalSince1970
        
        var dict = [String: Any]()
        dict["text"] = status_text
        dict["time"] = time
        
        /* get dog PFObject
           update statuses dictionary
           save in background */
        
        MBProgressHUD.showAdded(to: self.view , animated: true)
        let query = PFQuery(className: "dog_data")
        query.whereKey("objectId", equalTo: dog.id ?? "no id")
        query.findObjectsInBackground { (PFdogs: [PFObject]?, error: Error?) in
            if let PFdogs = PFdogs {
                for PFdog in PFdogs {
                    var statuses = (PFdog["statuses"] as? [NSDictionary]) ?? ([])
                    statuses.insert(dict as NSDictionary, at: 0)
                    PFdog["statuses"] = statuses
                    
                    PFdog.saveInBackground(block: { (wasSuccessful: Bool, error: Error?) in
                        if (wasSuccessful) {
                            print("success")
                            MBProgressHUD.hide(for: self.view , animated: true)
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            MBProgressHUD.hide(for: self.view , animated: true)
                            let alertController = UIAlertController(title: "Could not update status", message: "Please try again", preferredStyle: .alert)
                            // create a cancel action
                            let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                                // handle cancel response here. Doing nothing will dismiss the view.
                            }
                            // add the cancel action to the alertController
                            alertController.addAction(cancelAction)
                            
                            self.present(alertController, animated: true) {
                                // optional code for what happens after the alert controller has finished presenting
                            }

                        }
                    })
                }
            } else {
                MBProgressHUD.hide(for: self.view , animated: true)
                let alertController = UIAlertController(title: "Could not update status", message: "Please try again", preferredStyle: .alert)
                // create a cancel action
                let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                    // handle cancel response here. Doing nothing will dismiss the view.
                }
                // add the cancel action to the alertController
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true) {
                    // optional code for what happens after the alert controller has finished presenting
                }

            }
        }
        
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
