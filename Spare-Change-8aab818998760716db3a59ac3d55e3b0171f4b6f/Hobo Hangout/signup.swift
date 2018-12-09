//
//  signup.swift
//  Hobo Hangout
//
//  Created by Connor Ivy on 8/13/18.
//  Copyright © 2018 Connor Ivy. All rights reserved.
//

import UIKit
import Firebase

class signup: UIViewController {
    @IBOutlet weak var name: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submit(_ sender: Any) {
        let db = Firestore.firestore()
        
        if name.text != "" {
            db.collection("users").document(name.text!).setData([
                "name": name.text as Any,
                "pass": "password"
            ]) { (error:Error?) in
                if let error = error {
                    print("\(error.localizedDescription)")
                } else {
                    print("you've done it")
                }
            }
            name.text = ""
        }
    }
}
