//
//  SecondViewController.swift
//  Hobo Hangout
//
//  Created by Connor Ivy on 8/8/18.
//  Copyright © 2018 Connor Ivy. All rights reserved.
//

import UIKit
import MapKit
//import GoogleMaps
import GooglePlaces
import CoreLocation
import Firebase
import Contacts
import SafariServices

class SecondViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var botMenuView: UIView!
    @IBOutlet weak var exitButton: UIBarButtonItem!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var webBtn: UIButton!
    
    let manager = CLLocationManager()
    var menu = false
    var stopIt = false
    var callBool = true
    var webBool = true
    var loc1 = CLLocation(latitude: 0, longitude: 0)
    var mapCoordinates = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var placeName = ""
    var dist = 0.0
    var googResults = [AnyObject]()
    var googleResults = [String:String]()
    var website = ""
    var phone = ""
    let campus = CLLocationCoordinate2DMake(30.286421, -97.739131)
    let decoder = JSONDecoder()
    
//    struct Location {
//
//        var lat: Double
//        var long: Double
//        var id: String?
//        var name: String
//        var photos: [[String : Any]]?
//        var placeID: String?
//
//        init?(lat: Double, long: Double, id: String?, name: String, photos: [[String : Any]]?, placeID: String?) {
//            self.lat = lat
//            self.long = long
//            self.id = id
//            self.name = name
//            self.photos = photos
//            self.placeID = placeID
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        map.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                manager.requestWhenInUseAuthorization()
                createMap()
            case .restricted, .denied:
                alert()
                createMap()
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            }
        } else {
            print("Location services are not enabled")
        }
        
        map.delegate = self
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        exitButton.isEnabled = false
        exitButton.image = nil
        
        botMenuView.layer.cornerRadius = 8
        botMenuView.clipsToBounds = true
        // I probably dont need this but I wrote it so I want it
        // createNavBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    override var preferredStatusBarStyle: UIStatusBarStyle {
    //        return .lightContent
    //    }
    func alert() {
        let alert = UIAlertController(title: "Location Services Disabled", message: "Hobo Hangout would like you to enable your location. Although I'm not exactly sure why. If you don't live in Austin, TX then this app is basically useless.", preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "Settings", style: .default, handler: { (action) -> Void in
            // Go to settings
            UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!)
        })
        // Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        alert.addAction(submitAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let loc = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let span = MKCoordinateSpanMake(0.04, 0.04)
        let region = MKCoordinateRegion(center: loc, span: span)
        
        if !stopIt {
            map.setRegion(region, animated: true)
            stopIt = true
        }
        self.map.showsUserLocation = true
        loc1 = location
    }
    
    func createMap() {
        let span = MKCoordinateSpanMake(0.04, 0.04)
        let region = MKCoordinateRegion(center: campus, span: span)
        loc1 = CLLocation(latitude: campus.latitude, longitude: campus.longitude)
        
        map.setRegion(region, animated: true)
        
    }
    
//    func populateMap(query: String, title: String) {
//        clearSearches((Any).self)
//        var region = MKCoordinateRegion()
//        print(map.userLocation.coordinate.latitude, "user location")
//
//        let span = MKCoordinateSpanMake(0.04, 0.04)
//
//        if map.userLocation.coordinate.latitude != 0.0 {
//            region.center = CLLocationCoordinate2D(latitude: map.userLocation.coordinate.latitude, longitude: map.userLocation.coordinate.longitude)
//        } else {
//            region.center = CLLocationCoordinate2D(latitude: 30.286421, longitude: -97.739131)
//        }
//        region.span = span
//        let request = MKLocalSearchRequest()
//        request.naturalLanguageQuery = query
//        request.region = region
//
//        let search = MKLocalSearch(request: request)
//        search.start { (response, error) in
//            guard let response = response else { return }
//
//            self.exitButton.isEnabled = true
//            self.exitButton.image = #imageLiteral(resourceName: "first")
//            self.navigationItem.title = title
//            self.hideMenu((Any).self)
//
//            for item in response.mapItems {
//                let annotation = MKPointAnnotation()
//                self.nums[item.name!] = item.phoneNumber
//                annotation.coordinate = item.placemark.coordinate
//                annotation.title = item.name
//
//                DispatchQueue.main.async {
//                    self.map.addAnnotation(annotation)
//                }
//            }
//        }
//    }
    
    func populateMap(type: String, keyword: String, title: String, x: Double, y: Double) {
        self.exitButton.isEnabled = true
        self.exitButton.image = #imageLiteral(resourceName: "rsz_x")
        self.navigationItem.title = title
        self.hideMenu((Any).self)
        self.map.removeAnnotations(self.map.annotations)
        
        var strGoogleApi = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(x),\(y)&radius=2500&&fields=lat,lng,name,place_id&type=\(type)&keyword=\(keyword)&key=AIzaSyCxIsC1BptAJGCsQtit7eDteZDJjbum3OU"
        
        strGoogleApi = strGoogleApi.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        var urlRequest = URLRequest(url: URL(string: strGoogleApi)!)
        urlRequest.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                print(error)
            } else {
                let jsonDict = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                if let dict = jsonDict as? Dictionary<String, AnyObject> {
                    if let results = dict["results"] as? [Dictionary<String, AnyObject>] {
                        for element in results {
                            if let locationDictionary = element as? [String : Any] {
                                let geometry = locationDictionary["geometry"]! as! [String : Any]
                                let location = geometry["location"]! as! [String : Any]
                                let lat = location["lat"]
                                let long = location["lng"]
                                self.googleResults[locationDictionary["name"] as! String] = locationDictionary["place_id"] as? String
                                self.addAnnotation(name: locationDictionary["name"] as! String, lat: lat as! Double, long: long as! Double)
                            }
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
//        func search(item: String, title: String) {
//            let db = Firestore.firestore()
//            let settings = db.settings
//            settings.areTimestampsInSnapshotsEnabled = true
//            db.settings = settings
//
//            let query = db.collection("people")
//
//            query.getDocuments() { (querySnapshot, err) in
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                } else {
//                    for document in querySnapshot!.documents {
//                        let data = document.data()
//                        if data.keys.contains("name") && data.keys.contains("lat") &&
//                            data.keys.contains("long") && data.keys.contains("imageURL"){
//
//                            self.addAnnotation(name: data["name"] as! String, lat: data["lat"] as! Double, long: data["long"] as! Double)
//                        }
//                    }
//                }
//            }
//            exitButton.isEnabled = true
//            exitButton.image = #imageLiteral(resourceName: "rsz_x")
//            self.navigationItem.title = title
//            hideMenu((Any).self)
//        }
    
        func addAnnotation(name: String, lat: Double, long: Double) {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(lat, long)
    
            annotation.title = name
            DispatchQueue.main.async {
                self.map.addAnnotation(annotation)
            }
        }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if annotation is MKUserLocation {return nil}
        let loc2 = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)

        dist = loc2.distance(from: loc1)/1609.344

        let yell = UIColor(displayP3Red: 242/255.0, green: 200/255.0, blue: 80/255.0, alpha: 1)
        let navy = UIColor(displayP3Red: 14/255.0, green: 67/255.0, blue: 117/255.0, alpha: 1)
        let green = UIColor(displayP3Red: 91/255.0, green: 188/255.0, blue: 147/255.0, alpha: 1)
        let orange = UIColor(displayP3Red: 239/255.0, green: 130/255.0, blue: 63/255.0, alpha: 1)
        let reuseId = "pin"

        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            //            pinView = CustomAnnotationView.init(annotation: annotation, reuseIdentifier: reuseId)
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            pinView!.pinTintColor = green
            let calloutButton = UIButton(type: .detailDisclosure)
            let label = UILabel()
            label.backgroundColor = green
            label.numberOfLines = 0;
            //            label.font = UIFont(name: "Futura", size: 13)
            label.font = label.font.withSize(13)
            label.textAlignment = .center
            label.text = String(format: "%.1f\nmi", dist)
            label.textColor = UIColor.white
            label.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            pinView!.rightCalloutAccessoryView = calloutButton
            pinView!.leftCalloutAccessoryView = label
            pinView!.sizeToFit()
        }
        else {
            pinView!.annotation = annotation
        }

        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            mapCoordinates = (view.annotation?.coordinate)!
            placeName = ((view.annotation?.title)!)!
            getWebAndPhone()
            setBottomView()
            showBottomMenu()
        }
    }
    
    func getWebAndPhone() {
        var strGoogleApi = " "
        if let placeID = googleResults[placeName] {
            print(placeID)
            strGoogleApi = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(placeID)&fields=website,formatted_phone_number&key=AIzaSyCxIsC1BptAJGCsQtit7eDteZDJjbum3OU"
        } else {
            return
        }
        
        strGoogleApi = strGoogleApi.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        var urlRequest = URLRequest(url: URL(string: strGoogleApi)!)
        urlRequest.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                print(error)
            } else {
                let jsonDict = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                if let dict = jsonDict as? Dictionary<String, AnyObject> {
                    if let localDictionary = dict["result"] as? [String:String] {
                        print(localDictionary)
                        if localDictionary.keys.contains("website") {
                            self.webBool = true
                            self.website =
                                localDictionary["website"]!
                        } else {
                            self.webBool = false
                        }
                        if localDictionary.keys.contains("formatted_phone_number") {
                            self.callBool = true
                            self.phone = localDictionary["formatted_phone_number"]!
                        } else {
                            self.callBool = false
                        }
                        self.phone = self.removeSpecialCharsFromString(text: self.phone)
                    }
                }
            }
        }
        task.resume()
    }
    
    func removeSpecialCharsFromString(text: String) -> String {
        let okayChars : Set<Character> =
            Set("1234567890".characters)
        return String(text.characters.filter {okayChars.contains($0) })
    }
    
    @IBAction func openMaps(_ sender: Any) {
        let regionDistance:CLLocationDistance = 10000
        let regionSpan = MKCoordinateRegionMakeWithDistance(mapCoordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: mapCoordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = placeName
        mapItem.openInMaps(launchOptions: options)
    }
    
    @IBAction func callMeOnMyCellPhone(_ sender: Any) {
        if let phoneCallURL:NSURL = NSURL(string:"tel://\(phone)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL as URL)) {
                print("should open")
                application.open(phoneCallURL as URL)
            }
        }
    }
    
    @IBAction func openWebpage(_ sender: Any) {
        guard let url:NSURL = NSURL(string: "\(website)") else {return}
        let svc = SFSafariViewController(url: url as URL)
        present(svc, animated: true, completion: nil)
    }
    
    @IBOutlet weak var botViewTitle: UILabel!
    @IBOutlet weak var botViewSub: UILabel!
    
    
    func setBottomView() {
        botViewTitle.text = placeName
        botViewSub.text = "\(self.navigationItem.title ?? "resource")  -  \(String(format: "%.1f", self.dist)) miles"
    }
    
    @IBOutlet weak var menuTrailing: NSLayoutConstraint!
    @IBOutlet weak var toMap: UIButton!
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    
    @IBAction func showMenu(_ sender: Any) {
        //        UIApplication.shared.keyWindow!.addSubview(self.menuView)
        //        UIApplication.shared.keyWindow!.bringSubview(toFront: self.menuView)
        //        self.view.bringSubview(toFront: menuView)
        if !menu {
            toMap.isHidden = false
            menuTrailing.constant += 240
        } else {
            toMap.isHidden = true
            menuTrailing.constant -= 240
        }
        menu = !menu
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBOutlet weak var bottomMenu: NSLayoutConstraint!
    
    func showBottomMenu() {
        if callBool {
            callBtn.isEnabled = true
        } else {
            callBtn.isEnabled = false
        }
        
        if webBool {
            webBtn.isEnabled = true
        } else {
            webBtn.isEnabled = false
        }
        exitButton.isEnabled = false
        menuBtn.isEnabled = false
        toMap.isHidden = false
        bottomMenu.constant += 172
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func hideMenu(_ sender: Any) {
        if menu {
            menuTrailing.constant -= 240
            menu = false
        } else {
            menuBtn.isEnabled = true
            exitButton.isEnabled = true
            bottomMenu.constant -= 172
        }
        toMap.isHidden = true
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func clearSearches(_ sender: Any) {
        exitButton.isEnabled = false
        exitButton.image = nil
        self.navigationItem.title = "resources"
        map.removeAnnotations(map.annotations)
    }
    
    @IBAction func addictionRecovery(_ sender: Any) {
        populateMap(type: "health", keyword: "Addiction", title: "addiction recovery", x: campus.latitude, y: campus.longitude)
        //        search (item: "add", title: "addiction recovery")
    }
    @IBAction func employment(_ sender: Any) {
//        populateMap(query: "Addiction", title: "employment opportunities")
        //        search (item: "emp", title: "employment opportunities")
    }
    @IBAction func food(_ sender: Any) {
        populateMap(type: "", keyword: "food,pantry", title: "food banks", x: campus.latitude, y: campus.longitude)
        //        search (item: "foo", title: "food resources")
    }
    @IBAction func church(_ sender: Any) {
        populateMap(type: "church", keyword: "", title: "ministries and churches", x: map.centerCoordinate.latitude, y: map.centerCoordinate.longitude)
//        search (item: "min", title: "ministries & churches")
    }
    @IBAction func shelter(_ sender: Any) {
        populateMap(type: "", keyword: "homeless,shelter", title: "ministries and churches", x: campus.latitude, y: campus.longitude)
        //        search (item: "she", title: "shelters")
    }
    @IBAction func newResource(_ sender: Any) {
        
    }
    
    
    
    /*
     func createNavBar() {
     let orange = UIColor(displayP3Red: 190/255.0, green: 86/255.0, blue: 0, alpha: 1)
     
     // let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 20.0))
     let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0.0, y: 20.0, width: screenWidth, height: 44.0))
     self.view.addSubview(navBar);
     self.navigationController?.navigationBar.tintColor = orange
     let pic = self.resizeImage(image: #imageLiteral(resourceName: "bars"), targetSize: CGSize(width:25, height:25))
     let hamburgerIcon = UIBarButtonItem(image: pic, style: .plain, target: nil, action: #selector(getter: UIAccessibilityCustomAction.selector))
     let navItem = UINavigationItem(title: "resources");
     // let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: nil, action: #selector(getter: UIAccessibilityCustomAction.selector));
     navItem.rightBarButtonItem = hamburgerIcon;
     navBar.setItems([navItem], animated: false);
     }
     */
    
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

//class CustomAnnotationView : MKPinAnnotationView
//{
//    let selectedLabel:UILabel = UILabel.init(frame: CGRect(x: 0,y: 0,width: 140, height: 38))
//
//    override func setSelected(_ selected: Bool, animated: Bool)
//    {
//        super.setSelected(false, animated: animated)
//
//        if(selected)
//        {
//
//            // Do customization, for example:
//            selectedLabel.text = "Hello World!!"
//            selectedLabel.textAlignment = .center
//            selectedLabel.font = UIFont.init(name: "Futura", size: 15)
//            selectedLabel.backgroundColor = UIColor.white
////            selectedLabel.layer.borderColor = UIColor.white
//            selectedLabel.layer.borderWidth = 0
//            selectedLabel.layer.cornerRadius = 5
//            selectedLabel.layer.masksToBounds = true
//
//            selectedLabel.center.x = 0.5 * self.frame.size.width;
//            selectedLabel.center.y = -0.5 * selectedLabel.frame.height;
//
//            let calloutButton = UIButton(type: .detailDisclosure)
//            let label = UILabel()
//            label.backgroundColor = UIColor.orange
//            label.numberOfLines = 0;
//            label.font = UIFont(name: "Futura", size: 13)
//            label.textAlignment = .center
//            label.text = String(format: "%.1f\nmi", dist)
//            label.textColor = UIColor.black
//            label.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
//            self.rightCalloutAccessoryView = calloutButton
//            self.leftCalloutAccessoryView = label
//            self.sizeToFit()
//
//
//            self.addSubview(selectedLabel)
//        }
//        else
//        {
//            selectedLabel.removeFromSuperview()
//        }
//    }
//}
