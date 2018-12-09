//
//  ThirdViewController.swift
//  Hobo Hangout
//
//  Created by Connor Ivy on 8/8/18.
//  Copyright © 2018 Connor Ivy. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
    
    @IBAction func venmo(_ sender: Any) {
        if let appURL = URL(string: "venmo://paycharge?txn=pay&recipients=connor_ivy&amount=10&note=Note") {
            let canOpen = UIApplication.shared.canOpenURL(appURL)
            print("\(canOpen)")
            
            let appName = "Venmo"
            let appScheme = "\(appName)://"
            let appSchemeURL = URL(string: appScheme)
            
            if UIApplication.shared.canOpenURL(appSchemeURL! as URL) {
                UIApplication.shared.open(appSchemeURL!, options: [:], completionHandler: nil)
            } else {
                let alert = UIAlertController(title: "App not installed", message: "you nignog", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}
