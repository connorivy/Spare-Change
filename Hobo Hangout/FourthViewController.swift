//
//  FourthViewController.swift
//  Hobo Hangout
//
//  Created by Connor Ivy on 8/8/18.
//  Copyright © 2018 Connor Ivy. All rights reserved.
//

import UIKit
import Firebase

class FourthViewController: UIViewController, iCarouselDataSource, iCarouselDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var carouselView: iCarousel!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var box: UITextView!
    @IBOutlet weak var story: UIButton!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var item: UIButton!
    @IBOutlet weak var itemView: UIView!
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var list: UIButton!
    
    var left = true
    var oldIndex = -1

    static var peopleInfo: [[String:String]] = []
    static var itemInfo: [[String:String]] = []
    static var docIDs: [String] = []
    
//    override func loadView() {
//        populatePeopleDict() { (unused) in
//            self.carouselView.reloadData()
//            self.carouselView.type = .rotary
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        
        // Do any additional setup after loading the view.
        populatePeopleDict() { (unused) in
            self.carouselView.reloadData()
            self.carouselView.type = .rotary
            self.tableView.reloadData()
        }
        paymentView.layer.cornerRadius = 8
        paymentView.clipsToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FourthViewController.peopleInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FourthViewControllerTableViewCell
        
        if FourthViewController.peopleInfo != [] {
            cell.myImage.sd_setImage(with: URL(string: FourthViewController.peopleInfo[indexPath.row]["imageURL"]!))
            
            cell.name.text = FourthViewController.peopleInfo[indexPath.row]["name"]
            cell.story.text = FourthViewController.peopleInfo[indexPath.row]["story"]
            cell.index = indexPath.row
            
            cell.goToProfile.tag = indexPath.row
            
            // Add a target to your button making sure that you return the sender like so:
            
            cell.goToProfile.addTarget(self, action: #selector(handleButtonTapped(sender:)), for: .touchUpInside)

        }
        
        return cell
    }
    
    @objc func handleButtonTapped(sender: UIButton) {
        
        // Now you can easily access the sender's tag, (which is equal to the indexPath.row of the tapped button).
        
        // Access the selected cell's index path using the sender's tag like so
        
        let selectedIndex = IndexPath(row: sender.tag, section: 0)[1]
        self.carouselView.scrollToItem(at: selectedIndex, duration: 0.0)
        slideToStory((Any).self)
        carouselDidEndScrollingAnimation(carouselView)
        listToggle((Any).self)
    }
    
    @IBAction func listToggle(_ sender: Any) {
        if list.currentTitle == "list           " {
            list.setTitle("carousel       ", for: .normal)
        } else {
            list.setTitle("list           ", for: .normal)
        }
        tableView.isHidden = !tableView.isHidden
        navBar.title = "neighbors"
    }
    
    func populatePeopleDict(completion: @escaping ([[String:String]]) -> Void) {
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        let order = db.collection("people").order(by: "name")
        order.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    FourthViewController.docIDs.append(document.documentID)
                    FourthViewController.peopleInfo.append(document.data() as! [String : String])
                }
                completion(FourthViewController.peopleInfo)
            }
        }
    }
    
    func populateItemDict(docID: String, completion: @escaping ([[String:String]]) -> Void) {
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        var item: [[String:String]] = []
        
        let itemReference = db.collection("people/\(docID)/items")
        
        itemReference.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
//                    print(document.data())
                    item.append(document.data() as! [String : String])
                    //                    print("\(document.documentID) => \(document.data().values)")
                }
                completion(item)
            }
        }
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return FourthViewController.peopleInfo.count
    }

    @IBOutlet weak var itemViewHeight: NSLayoutConstraint!
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        itemViewHeight.constant = CGFloat(80 + 0.2 * screenHeight)
        let width = screenWidth - 50
        let height = screenHeight - (49 + itemViewHeight.constant + 10 + 33 + 15 + 24 + self.navigationController!.navigationBar.frame.height + 0.03448 * screenHeight )
        print(width, height)
        print(carouselView.frame.width, carouselView.frame.height)
        var dim = height
        
        if width < height {
            print("width controls")
            dim = width
        }
        
        // Create a UIview
        let tempView = UIView(frame: CGRect(x: 0, y: 0, width: dim, height: dim))
//        tempView.backgroundColor = UIColor.green
        
        //Create a UIImageView
        let frame = CGRect(x: 0, y: 0, width: dim, height: dim)
        let imageView = UIImageView()
        imageView.frame = frame
//        imageView.backgroundColor = UIColor.red
        imageView.contentMode = .scaleAspectFit
        
//        print("\n\n")
//        print(FourthViewController.peopleInfo, "is it updated")
//        print(variable.peopleInfo[index]["imageURL"]!)
//        print("\n\n")
        
        if FourthViewController.peopleInfo != [] {
            imageView.sd_setImage(with: URL(string: FourthViewController.peopleInfo[index]["imageURL"]!))
        }
        tempView.addSubview(imageView)
        
        return tempView
    }
    
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        switch (option)
        {
        case iCarouselOption.fadeMin:
            return -0.2;
        case iCarouselOption.fadeMax:
            return 0.2;
        case iCarouselOption.fadeRange:
            return 2.0;
        case iCarouselOption.arc:
            return 1.5;
        case iCarouselOption.spacing:
            return 1.19
        default:
            return value;
        }
    }
    @IBOutlet weak var item1: UILabel!
    @IBOutlet weak var item2: UILabel!
    @IBOutlet weak var item3: UILabel!
    @IBOutlet weak var amount1: UILabel!
    @IBOutlet weak var amount2: UILabel!
    @IBOutlet weak var amount3: UILabel!
    @IBOutlet weak var pic1: UIImageView!
    @IBOutlet weak var pic2: UIImageView!
    @IBOutlet weak var pic3: UIImageView!
    
    func carouselDidEndScrollingAnimation(_ carousel: iCarousel) {
        let index = carousel.currentItemIndex
        navBar.title = FourthViewController.peopleInfo[index]["name"]
        
        if index != oldIndex {
            oldIndex = index
            reset()
            var cost = 15
            var aF = 0

            box.text = FourthViewController.peopleInfo[index]["story"]
            populateItemDict(docID: FourthViewController.docIDs[index]) { (info) in

                for item in 0..<info.count {
                    switch item {
                    case 0:
                        if info[0].keys.contains("name") {
                            self.item1.text = info[0]["name"]
                        }
                        self.item1.isHidden = false
                        
                        if info[0].keys.contains("cost") {
                            cost = Int(info[0]["cost"]!)!
                        }
                        if info[0].keys.contains("amountFunded") {
                            aF = Int(info[0]["amountFunded"]!)!
                        }
                        self.amount1.isHidden = false
                        self.amount1.text = "$\(String(cost-aF)) / $\(String(cost)) remaining"
                        
                        self.pic1.isHidden = false
                        if info[0].keys.contains("type") {
                            self.pic1.image = self.getPicture(type: info[0]["type"]!)
                        } else { self.pic1.image = self.getPicture(type: "default")}
                        
                    case 1:
                        if info[1].keys.contains("name") {
                            self.item2.text = info[1]["name"]
                        }
                        self.item2.isHidden = false
                        
                        if info[1].keys.contains("cost") {
                            cost = Int(info[1]["cost"]!)!
                        }
                        if info[1].keys.contains("amountFunded") {
                            aF = Int(info[1]["amountFunded"]!)!
                        }
                        self.amount2.text = "$\(String(cost-aF)) / $\(String(cost)) remaining"
                        self.amount2.isHidden = false
                        
                        self.pic2.isHidden = false
                        if info[1].keys.contains("type") {
                            self.pic2.image = self.getPicture(type: info[1]["type"]!)
                        } else { self.pic2.image = self.getPicture(type: "default")}
                    case 2:
                        if info[2].keys.contains("name") {
                            self.item3.text = info[2]["name"]
                        }
                        self.item3.isHidden = false
                        
                        if info[2].keys.contains("cost") {
                            cost = Int(info[2]["cost"]!)!
                        }
                        if info[2].keys.contains("amountFunded") {
                            aF = Int(info[2]["amountFunded"]!)!
                        }
                        self.amount3.text = "$\(String(cost-aF)) / $\(String(cost)) remaining"
                        self.amount3.isHidden = false
                        
                        self.pic3.isHidden = false
                        if info[2].keys.contains("type") {
                            self.pic3.image = self.getPicture(type: info[2]["type"]!)
                        } else { self.pic3.image = self.getPicture(type: "default")}

                    default:
                        print("this actually ran")
                    }
                }
            }
            self.carouselView.reloadData()
        }
    }
    
    func reset() {
        self.item1.isHidden = true
        self.item2.isHidden = true
        self.item3.isHidden = true
        self.amount1.isHidden = true
        self.amount2.isHidden = true
        self.amount3.isHidden = true
        self.pic1.isHidden = true
        self.pic2.isHidden = true
        self.pic3.isHidden = true
        self.coloredLabel1.alpha = 0
        self.coloredLabel2.alpha = 0
        self.coloredLabel3.alpha = 0
        self.item1tintbutton.isSelected = false
        self.item2tintbutton.isSelected = false
        self.item3tintbutton.isSelected = false
        self.donateButton.isEnabled = false
        self.selectLabel.isHidden = false
    }
    
    func getPicture(type: String) -> UIImage {
        switch type {
        case "book", "entertainment", "education", "fun":
            return #imageLiteral(resourceName: "book")
        case "food":
            return #imageLiteral(resourceName: "food")
        case "prayer", "faith":
            return #imageLiteral(resourceName: "prayer")
        case "hygiene":
            return #imageLiteral(resourceName: "hygiene")
        case "clothing":
            return #imageLiteral(resourceName: "clothing")
        default:
            return #imageLiteral(resourceName: "clothing")
        }
    }
    
    @IBOutlet weak var slideLeading: NSLayoutConstraint!
    @IBOutlet weak var donateBtnInFront: UIButton!
    
    @IBAction func slideToItems(_ sender: Any) {
        if self.left {
            let blue = UIColor(displayP3Red: 14/255.0, green: 67/255.0, blue: 117/255.0, alpha: 1)
            
//            UIView.animate(withDuration: 0.5, animations: {
//                self.slide.frame.origin.x += 169
////                self.slideCenterX.constant += 171
////                self.slideLeading.constant += 171
//            }, completion: nil)
            
//            self.slide.centerXAnchor.constraint(equalTo: self.item.centerXAnchor)
            
            slideLeading.constant -= 165
            UIView.animate(withDuration: 0.35) {
                self.view.layoutIfNeeded()
            }

            UIView.transition(with: story, duration: 0.5, options: .transitionCrossDissolve, animations: {() -> Void in
                self.story.setTitleColor(blue, for: .normal) }, completion: {(finished: Bool) -> Void in })
            
            UIView.transition(with: item, duration: 0.5, options: .transitionCrossDissolve, animations: {() -> Void in
                self.item.setTitleColor(UIColor.white, for: .normal)}, completion: {(finished: Bool) -> Void in })
            self.box.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                self.itemView.isHidden = false
                self.donateBtnInFront.isHidden = true
            })
            self.left = false
        }
    }
    @IBAction func slideToStory(_ sender: Any) {
        if !self.left {
            let blue = UIColor(displayP3Red: 14/255.0, green: 67/255.0, blue: 117/255.0, alpha: 1)
            
//            UIView.animate(withDuration: 0.5, animations: {
//                self.slide.frame.origin.x -= 169
////                self.slideCenterX.constant -= 171
////                self.slideLeading.constant -= 171
//            }, completion: nil)
            
            slideLeading.constant += 165
            
            UIView.animate(withDuration: 0.35) {
                self.view.layoutIfNeeded()
            }
            
            UIView.transition(with: story, duration: 0.5, options: .transitionCrossDissolve, animations: {() -> Void in
                self.story.setTitleColor(UIColor.white, for: .normal) }, completion: {(finished: Bool) -> Void in })
            
            UIView.transition(with: item, duration: 0.5, options: .transitionCrossDissolve, animations: {() -> Void in
                self.item.setTitleColor(blue, for: .normal)}, completion: {(finished: Bool) -> Void in })
            self.itemView.isHidden = true
            self.donateBtnInFront.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                self.box.isHidden = false
            })
            self.left = true
        }
    }
    
    @IBOutlet weak var donateButton: UIButton!
    @IBOutlet weak var item1tintbutton: UIButton!
    @IBOutlet weak var item2tintbutton: UIButton!
    @IBOutlet weak var item3tintbutton: UIButton!
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var coloredLabel1: UIButton!
    @IBOutlet weak var coloredLabel2: UIButton!
    @IBOutlet weak var coloredLabel3: UIButton!
    
    @IBAction func item1(_ sender: Any) {
        if self.item1.isHidden == false {
            buttonSelected(button: coloredLabel1, button2: coloredLabel2, button3: coloredLabel3)
        }
    }
    
    @IBAction func item2(_ sender: Any) {
        if self.item2.isHidden == false {
            buttonSelected(button: coloredLabel2, button2: coloredLabel1, button3: coloredLabel3)
        }
    }
    
    @IBAction func item3(_ sender: Any) {
        if self.item3.isHidden == false {
            buttonSelected(button: coloredLabel3, button2: coloredLabel1, button3: coloredLabel2)
        }
    }
    
    func buttonSelected(button: UIButton, button2: UIButton, button3: UIButton) {
        
        button.isSelected = !button.isSelected
        button2.isSelected = false
        button3.isSelected = false
        if button2.alpha != 0 {
            UIView.animate(withDuration: 0.3, animations: {
                button2.alpha = 0 })
        }
        if button3.alpha != 0 {
            UIView.animate(withDuration: 0.3, animations: {
                button3.alpha = 0 })
        }
        if button.isSelected {
            UIView.animate(withDuration: 0.3, animations: {
                button.alpha = 0.25 })
            selectLabel.isHidden = true
            donateButton.isEnabled = true
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                button.alpha = 0 })
            selectLabel.isHidden = false
            donateButton.isEnabled = false
        }
        self.carouselView.reloadData()
    }
    
    @IBAction func aSearch(_ sender: Any) { search(letter: "A") }
    @IBAction func bSearch(_ sender: Any) { search(letter: "B") }
    @IBAction func cSearch(_ sender: Any) { search(letter: "C") }
    @IBAction func dSearch(_ sender: Any) { search(letter: "D") }
    @IBAction func eSearch(_ sender: Any) { search(letter: "E") }
    @IBAction func fSearch(_ sender: Any) { search(letter: "F") }
    @IBAction func gSearch(_ sender: Any) { search(letter: "G") }
    @IBAction func hSearch(_ sender: Any) { search(letter: "H") }
    @IBAction func iSearch(_ sender: Any) { search(letter: "I") }
    @IBAction func jSearch(_ sender: Any) { search(letter: "J") }
    @IBAction func kSearch(_ sender: Any) { search(letter: "K") }
    @IBAction func lSearch(_ sender: Any) { search(letter: "L") }
    @IBAction func mSearch(_ sender: Any) { search(letter: "M") }
    @IBAction func nSearch(_ sender: Any) { search(letter: "N") }
    @IBAction func oSearch(_ sender: Any) { search(letter: "O") }
    @IBAction func pSearch(_ sender: Any) { search(letter: "P") }
    @IBAction func qSearch(_ sender: Any) { search(letter: "Q") }
    @IBAction func rSearch(_ sender: Any) { search(letter: "R") }
    @IBAction func sSearch(_ sender: Any) { search(letter: "S") }
    @IBAction func tSearch(_ sender: Any) { search(letter: "T") }
    @IBAction func uSearch(_ sender: Any) { search(letter: "U") }
    @IBAction func vSearch(_ sender: Any) { search(letter: "V") }
    @IBAction func wSearch(_ sender: Any) { search(letter: "W") }
    @IBAction func xSearch(_ sender: Any) { search(letter: "X") }
    @IBAction func ySearch(_ sender: Any) { search(letter: "Y") }
    @IBAction func zSearch(_ sender: Any) { search(letter: "Z") }
    
    func search(letter: String) {
        let currentIndex = self.carouselView.currentItemIndex
        var newIndex = FourthViewController.peopleInfo.count - 1
        for info in 0 ..< FourthViewController.peopleInfo.count {
            let name = String((FourthViewController.peopleInfo[info]["name"]?.prefix(1))!)
            print(name, letter)
            if letter == "A" {
                newIndex = 0
                break
            }
            else if name < letter {
                print("cont")
                continue
            } else if name >= letter {
                print("accepted")
                newIndex = info
                break
            }
        }
        self.carouselView.scroll(byNumberOfItems: newIndex - currentIndex, duration: 0.5)
    }
    
    
    @IBOutlet weak var cancelPayment: UIButton!
    @IBOutlet weak var paymentViewBottom: NSLayoutConstraint!
    
    @IBAction func passInfo(_ sender: Any) {
        print("pass info")
        cancelPayment.isHidden = false
        paymentViewBottom.constant -= 208
        UIView.animate(withDuration: 0.35) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func cancelPayment(_ sender: Any) {
        print("cancel payment")
        cancelPayment.isHidden = true
        paymentViewBottom.constant += 208
        UIView.animate(withDuration: 0.35) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func venmo(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "donate") as? DonateViewController {
            vc.name = navBar.title!
            if coloredLabel1.isSelected {
                vc.item = item1.text!
            } else if coloredLabel2.isSelected {
                vc.item = item2.text!
            } else {
                vc.item = item3.text!
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
