//
//  who we are.swift
//  Hobo Hangout
//
//  Created by Connor Ivy on 8/10/18.
//  Copyright © 2018 Connor Ivy. All rights reserved.
//

import UIKit

class who_we_are: UIViewController {
    @IBOutlet weak var aboutUs: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // getVideo(videoCode: "ZdPdiQNWDeY")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func getVideo(videoCode:String)
    {
        let url = URL(string: "https://www.youtube.com/embed/\(videoCode)")
        aboutUs.loadRequest(URLRequest(url: url!))
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
