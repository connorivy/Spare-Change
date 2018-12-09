//
//  FifthViewController.swift
//  Hobo Hangout
//
//  Created by Connor Ivy on 8/8/18.
//  Copyright © 2018 Connor Ivy. All rights reserved.
//

import UIKit
import MessageUI

class FifthViewController: UIViewController, MFMailComposeViewControllerDelegate, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var subject: UITextField!
    @IBOutlet weak var message: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        message.delegate = self
        message.text = "Enter your message here and we'll be in contact as soon as possible."
        message.textColor = UIColor.lightGray
        message.selectedTextRange = message.textRange(from: message.beginningOfDocument, to: message.beginningOfDocument)
        
        message.layer.cornerRadius = 5
        message.layer.borderColor = UIColor.gray.withAlphaComponent(0.4).cgColor
        message.layer.borderWidth = 0.7
        message.clipsToBounds = true
        addDoneButtonOnKeyboard()
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textView(_ message: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText:String = message.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        if updatedText.isEmpty {
            message.text = "Enter your message here and we'll be in contact ASAP as possible."
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
    
    @IBAction func sendEmail(_ sender: Any) {
        let mailComposeViewController = configureMailController()
        
        if name.text! == "" {
            showMailError(erMessage:"Please enter a name")
        }
        else if email.text! == "" {
            showMailError(erMessage:"Please enter an email address")
        }
        else if subject.text! == "" {
            showMailError(erMessage:"Please enter a subject")
        }
        else if message.text! == "" {
            showMailError(erMessage:"Please enter a message")
        } else {
        
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
            } else {
                showMailError(erMessage:"Something went wrong. Please try again or email us at ___________@gmail.com")
            }
        }
    }
    
    func configureMailController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["connorivy15@gmail.com"])
        mailComposerVC.setSubject(subject.text!)
        mailComposerVC.setMessageBody("Name: \(name.text!) \n\nEmail: \(email.text!) \n\nMessage: \(message.text!)", isHTML: false)
        
        return mailComposerVC
    }
    
    func showMailError(erMessage:String) {
        let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email", message: erMessage, preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func addDoneButtonOnKeyboard() {
        let orange = UIColor(displayP3Red: 239/255.0, green: 130/255.0, blue: 63/255.0, alpha: 1)
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(FifthViewController.doneButtonAction))
        
        done.tintColor = orange
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.name.inputAccessoryView = doneToolbar
        self.subject.inputAccessoryView = doneToolbar
        self.email.inputAccessoryView = doneToolbar
        self.message.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.name.resignFirstResponder()
        self.subject.resignFirstResponder()
        self.email.resignFirstResponder()
        self.message.resignFirstResponder()
    }
    
}
