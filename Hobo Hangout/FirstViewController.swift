//
//  FirstViewController.swift
//  Hobo Hangout
//
//  Created by Connor Ivy on 8/8/18.
//  Copyright © 2018 Connor Ivy. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    @IBOutlet weak var plus: UIButton!
    @IBOutlet weak var outerCir: UIButton!
    @IBOutlet weak var whoAreWe: UIButton!
    @IBOutlet weak var whatWeDo: UIButton!
    @IBOutlet weak var howToHelp: UIButton!
    @IBOutlet weak var gospel: UIButton!

    var pushed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // if you want to change the back button image
        // navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "backArrow")
        // navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "backArrow")
        
        // Do any additional setup after loading the view, typically from a nib.
//        createBtns()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return UIStatusBarStyle.lightContent
//    }
    
    @IBOutlet weak var gos: UIButton!
    @IBOutlet weak var how: UIButton!
    @IBOutlet weak var why: UIButton!
    @IBOutlet weak var what: UIButton!
    
    @IBAction func plusPushed(_ sender: Any) {
        if !pushed {
            gos.isEnabled = true
            how.isEnabled = true
            why.isEnabled = true
            what.isEnabled = true
            expand(scale: 20.0, time:0)
            rotate(direction: -1.0, time: 0.5, clock: true)
            followCircularPath(time: 0.5, start: 0.8, end: 1.55, clock: true)
//            addConstraints(bool: true)
        } else {
            gos.isEnabled = false
            how.isEnabled = false
            why.isEnabled = false
            what.isEnabled = false
            expand(scale: 0.05, time:0.8)
            rotateBack(direction: -1.0, time: 0.0, clock: false)
            followCircularPath(time: 0.0, start: 1.55, end: 0.8, clock: false)
        }
        pushed = !pushed
    }
    
    func followCircularPath (time: Double, start: CGFloat, end: CGFloat, clock: Bool) {
        let offset = CGFloat(0.191)
        
        let circlePath = UIBezierPath(arcCenter: self.plus.center, radius: 205, startAngle: start * .pi, endAngle: end * .pi, clockwise: clock)
        let circlePath2 = UIBezierPath(arcCenter: self.plus.center, radius: 205, startAngle: (start - offset) * .pi, endAngle: (end-offset) * .pi, clockwise: clock)
        let circlePath3 = UIBezierPath(arcCenter: self.plus.center, radius: 205, startAngle: (start - offset*2) * .pi, endAngle: (end-offset*2) * .pi, clockwise: clock)
        let circlePath4 = UIBezierPath(arcCenter: self.plus.center, radius: 205, startAngle: (start - offset*3) * .pi, endAngle: (end-offset*3) * .pi, clockwise: clock)
        
        let duration = 0.75
        
        let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        animation.duration = duration
        animation.repeatCount = 1
        animation.path = circlePath.cgPath
        animation.beginTime = CACurrentMediaTime() + time
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        let animation2 = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        animation2.duration = duration
        animation2.repeatCount = 1
        animation2.path = circlePath2.cgPath
        animation2.beginTime = CACurrentMediaTime() + time
        animation2.isRemovedOnCompletion = false
        animation2.fillMode = kCAFillModeForwards
        
        let animation3 = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        animation3.duration = duration
        animation3.repeatCount = 1
        animation3.path = circlePath3.cgPath
        animation3.beginTime = CACurrentMediaTime() + time
        animation3.isRemovedOnCompletion = false
        animation3.fillMode = kCAFillModeForwards
        
        let animation4 = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        animation4.duration = duration
        animation4.repeatCount = 1
        animation4.path = circlePath4.cgPath
        animation4.beginTime = CACurrentMediaTime() + time
        animation4.isRemovedOnCompletion = false
        animation4.fillMode = kCAFillModeForwards
        
        self.whoAreWe.layer.add(animation, forKey: nil)
        self.whatWeDo.layer.add(animation2, forKey: nil)
        self.howToHelp.layer.add(animation3, forKey: nil)
        self.gospel.layer.add(animation4, forKey: nil)
        
        // circleLayer is only used to locate the circle animation path
        let circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        let circleLayer2 = CAShapeLayer()
        circleLayer2.path = circlePath.cgPath
        circleLayer2.fillColor = UIColor.clear.cgColor
        let circleLayer3 = CAShapeLayer()
        circleLayer3.path = circlePath.cgPath
        circleLayer3.fillColor = UIColor.clear.cgColor
        let circleLayer4 = CAShapeLayer()
        circleLayer4.path = circlePath.cgPath
        circleLayer4.fillColor = UIColor.clear.cgColor
        
        view.layer.addSublayer(circleLayer)
        view.layer.addSublayer(circleLayer2)
        view.layer.addSublayer(circleLayer3)
        view.layer.addSublayer(circleLayer4)
    }
    
    func expand (scale: CGFloat, time: Float) {
        UIView.animate(withDuration: 0.4, delay: TimeInterval(time), options:[], animations: {
            self.outerCir.transform = CGAffineTransform(scaleX: scale, y: scale)
        }, completion: nil)
    }
    
    func rotate(direction: CGFloat, time: Float, clock: Bool) {
        if plus.transform == .identity {
            UIView.animate(withDuration: 0.5, delay: TimeInterval(time), options: UIViewAnimationOptions.curveEaseIn, animations: {
//                self.followCircularPath(start: start, end: end, clock: clock)
                self.plus.transform = CGAffineTransform(rotationAngle: ((CGFloat.pi) + 1) * direction)
                self.whoAreWe.isHidden = false
                self.whatWeDo.isHidden = false
                self.howToHelp.isHidden = false
                self.gospel.layer.isHidden = false
            }, completion: nil)
            
            UIView.animate(withDuration: 0.5, delay: TimeInterval(time + 0.25), options:UIViewAnimationOptions.curveEaseOut, animations: {
                self.plus.transform = CGAffineTransform(rotationAngle: ((3 * CGFloat.pi / 4) * direction))
            }, completion: nil)
            
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.plus.transform = .identity
            })
        }
    }
    
    func rotateBack(direction: CGFloat, time: Float, clock: Bool) {

        UIView.animate(withDuration: 0.5, delay: TimeInterval(time), options:[], animations: {
            self.plus.transform = CGAffineTransform(rotationAngle: (CGFloat.pi) - 1)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: TimeInterval(time + 0.25), options:UIViewAnimationOptions.curveEaseOut, animations: {
            self.plus.transform = .identity
        }, completion: nil)
    }
    
//    func createBtns() {
//        whoAreWe.setImage(#imageLiteral(resourceName: "whoweare"), for: .normal)
////        whoAreWe.setTitle("", for: .normal)
//        whoAreWe.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
//
//        whatWeDo.setImage(#imageLiteral(resourceName: "clipboard"), for: .normal)
//        //        whoAreWe.setTitle("", for: .normal)
//        whatWeDo.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
//
//        howToHelp.setImage(#imageLiteral(resourceName: "hygiene"), for: .normal)
//        //        whoAreWe.setTitle("", for: .normal)
//        howToHelp.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
//
//        gospel.setImage(#imageLiteral(resourceName: "prayer"), for: .normal)
//        //        whoAreWe.setTitle("", for: .normal)
//        gospel.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
//
//        self.view.addSubview(whoAreWe)
//        self.view.addSubview(whatWeDo)
//        self.view.addSubview(howToHelp)
//        self.view.addSubview(gospel)
//    }
//
//    @objc func buttonAction(sender: UIButton!) {
//        print("Button tapped")
//    }
    
    func addConstraints(bool: Bool) {
//        whoAreWe.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 15).isActive = bool
//        whoAreWe.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 238).isActive = bool
//        
//        whatWeDo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 128).isActive = bool
//        whatWeDo.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 206).isActive = bool
//        
//        howToHelp.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 217)
//        howToHelp.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 122).isActive = bool
//        
//        gospel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 234).isActive = bool
//        gospel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 8).isActive = bool
    }
    
    @IBAction func whoAreWe(_ sender: Any) {
        print(whoAreWe.center)
    }
    
    @IBAction func whatWeDo(_ sender: Any) {
        print(whatWeDo.center)
    }
    
    @IBAction func howToHelp(_ sender: Any) {
        print(howToHelp.center)
    }
    
    @IBAction func gospel(_ sender: Any) {
        print(gospel.center)
    }
    
    @IBAction func check(_ sender: Any) {
        print(whoAreWe.center)
        print(whatWeDo.center)
        print(howToHelp.center)
        print(gospel.center)
    }
    
}

