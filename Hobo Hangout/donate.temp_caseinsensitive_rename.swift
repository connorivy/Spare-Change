//
//  Profile.swift
//  Hobo Hangout
//
//  Created by Connor Ivy on 8/13/18.
//  Copyright © 2018 Connor Ivy. All rights reserved.
//

import UIKit

class donate: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var donateBtn: UIButton!
    
    let space = "                       "
    var name = ""
    var currentString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if name != "" {
            donateBtn.setTitle("Donate to \(name)", for: .normal)
        } else {
            donateBtn.setTitle("Donate", for: .normal)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func textView(_ message: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        let currentText:String = message.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        if updatedText == "                       " {
            message.text = "\(message.text) + Hopscotch Tournament"
            message.textColor = UIColor.lightGray
            
            message.selectedTextRange = message.textRange(from: message.beginningOfDocument, to: message.beginningOfDocument)
        }
        else if message.textColor == UIColor.lightGray && !text.isEmpty {
            message.textColor = UIColor.black
            message.text = space + text
        } else {
            return true
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Construct the text that will be in the field if this change is accepted
        
        switch string {
        case "0","1","2","3","4","5","6","7","8","9":
            currentString += string
            formatCurrency(currentString)
        default:
            if string.characters.count == 0 && currentString.characters.count != 0 {
                currentString = String(currentString.characters.dropLast())
                formatCurrency(currentString)
            }
        }
        return false    }
    
    func textViewDidChangeSelection(_ message: UITextView) {
        if self.view.window != nil {
            if message.textColor == UIColor.lightGray {
                message.selectedTextRange = message.textRange(from: message.beginningOfDocument, to: message.beginningOfDocument)
            }
        }
    }
    
    func formatCurrency(_ string: String) {
        print("format \(string)")
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = findLocaleByCurrencyCode("NGN")
        let numberFromField = (NSString(string: currentString).doubleValue)/100
        let temp = formatter.string(from: NSNumber(value: numberFromField))
        self.amount.text = String(describing: temp!.characters.dropFirst())
    }
    
    func findLocaleByCurrencyCode(_ currencyCode: String) -> Locale? {
        
        let locales = Locale.availableIdentifiers
        var locale: Locale?
        for   localeId in locales {
            locale = Locale(identifier: localeId)
            if let code = (locale! as NSLocale).object(forKey: NSLocale.Key.currencyCode) as? String {
                if code == currencyCode {
                    return locale
                }
            }
        }
        return locale }
    
    @IBAction func venmo(_ sender: Any) {
        if let appURL = URL(string: "venmo://paycharge?txn=pay&recipients=connor_ivy&amount=10&note=Note") {
            let canOpen = UIApplication.shared.canOpenURL(appURL)
            print("\(canOpen)")
            
            let appName = "venmo"
            let appScheme = "\(appName)://paycharge?txn=pay&recipients=connor_ivy&amount=10&note=Note"
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
