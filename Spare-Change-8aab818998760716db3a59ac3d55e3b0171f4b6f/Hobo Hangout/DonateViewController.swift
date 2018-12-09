//
//  Profile.swift
//  Hobo Hangout
//
//  Created by Connor Ivy on 8/13/18.
//  Copyright © 2018 Connor Ivy. All rights reserved.
//

import UIKit
import Firebase

class DonateViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var yourName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var donateBtn: UIButton!
    
    var name = ""
    var item = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if name != "" {
            donateBtn.setTitle("Donate to \(name)", for: .normal)
        } else {
            donateBtn.setTitle("Donate", for: .normal)
        }
        
        yourName.becomeFirstResponder()
        message.delegate = self
        message.text = "Enter the venmo payment description. It can be anything you want it to be."
        message.textColor = UIColor.lightGray
        message.selectedTextRange = message.textRange(from: message.beginningOfDocument, to: message.beginningOfDocument)
        
        message.layer.cornerRadius = 5
        message.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        message.layer.borderWidth = 0.7
        message.clipsToBounds = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
    func textView(_ message: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText:String = message.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        if updatedText.isEmpty {
            message.text = "Enter the venmo payment description. It can be anything you want it to be."
            message.textColor = UIColor.lightGray
            
            message.selectedTextRange = message.textRange(from: message.beginningOfDocument, to: message.beginningOfDocument)
        }
        else if message.textColor == UIColor.lightGray && !text.isEmpty {
            message.textColor = UIColor.black
            message.text = text
        } else {
            return true
        }
        return false
    }
    
    func textViewDidChangeSelection(_ message: UITextView) {
        if self.view.window != nil {
            if message.textColor == UIColor.lightGray {
                message.selectedTextRange = message.textRange(from: message.beginningOfDocument, to: message.beginningOfDocument)
            }
        }
    }
    
    func textFieldDidChangeSelection(_ message: UITextView) {
        if self.view.window != nil {
            if message.textColor == UIColor.lightGray {
                message.selectedTextRange = message.textRange(from: message.beginningOfDocument, to: message.beginningOfDocument)
            }
        }
    }
    
    @IBAction func venmo(_ sender: Any) {
        if yourName.text == "" {
            showError(erMessage: "Please enter a name")
        } else if amount.text == "" {
            showError(erMessage: "Please enter an amount")
        } else if message.text == "" {
            showError(erMessage: "Please enter a payment description")
        } else {
            let db = Firestore.firestore()
        db.collection("donations").document(yourName.text!).setData([
                "name": yourName.text,
                "email": email.text,
                "amount": amount.text,
                "verified": "No"
            ]) { (error:Error?) in
                if let error = error {
                    print("\(error.localizedDescription)")
                } else {
                    print("you've done it")
                }
            }
        
            let appName = "venmo"
            let appScheme = "venmo://paycharge?txn=pay&recipients=connor_ivy&amount=\(amount.text!)&note=\(message.text!)"
            let appSchemeURL = URL(string: appScheme)
            
            if UIApplication.shared.canOpenURL(appSchemeURL! as URL) {
                print("lets go2")
                UIApplication.shared.open(appSchemeURL!, options: [:], completionHandler: nil)
            } else {
                let alert = UIAlertController(title: "Venmo Not Installed", message: "you're a nog", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func showError(erMessage:String) {
        let sendMailErrorAlert = UIAlertController(title: "Could Not Make Payment", message: erMessage, preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "OK", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
}
