//
//  MyView.swift
//  day06
//
//  Created by Cristian Cosneanu on 4/27/17.
//  Copyright © 2017 Cristian Cosneanu. All rights reserved.
//

import UIKit

class MyView: UIView, UIGestureRecognizerDelegate {
    
    private var circle = false
    public var color:UIColor?
    
    var myViewController:ViewController!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if arc4random() % 2 == 0
        {
            circle = false
        }
        else
        {
            circle = true
        }
        setColor()
//        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setColor(){
        self.color = UIColor(red: CGFloat(arc4random()) / CGFloat(UInt32.max), green: CGFloat(arc4random()) / CGFloat(UInt32.max), blue: CGFloat(arc4random()) / CGFloat(UInt32.max), alpha: 1.0)
    }
    
    func putShape(view: UIView)
    {
        self.backgroundColor = self.color
        if circle
        {
            self.layer.cornerRadius = (self.frame.size.width) / 2
            self.clipsToBounds = true
        }
        view.addSubview(self)
    }
    
    func panMe(_ sender: UIPanGestureRecognizer)
    {
        if sender.state == .began {
            print("pan BEGAN")
            myViewController?.gravity.removeItem(self)
            myViewController?.bounce.removeItem(self)
            myViewController?.boundries.removeItem(self)
        }
        else if (sender.state == .ended || sender.state == .cancelled)
        {
            print("Pan END")
            myViewController?.gravity.addItem(self)
            myViewController?.bounce.addItem(self)
            myViewController?.boundries.addItem(self)
        }
        else
        {
            print("Pan DRAG")
            let tr = sender.translation(in: self.superview)
            if let v = sender.view
            {
                v.center = CGPoint(x: v.center.x + tr.x, y: v.center.y + tr.y)
            }
            sender.setTranslation(CGPoint.zero, in: self.superview)
        }

    }
    
    func pinchMe(_ sender: UIPinchGestureRecognizer)
    {
        if sender.state == .began {
            myViewController?.gravity.removeItem(self)
            myViewController?.bounce.removeItem(self)
            myViewController?.boundries.removeItem(self)
        }
        else if (sender.state == .ended || sender.state == .cancelled)
        {
            self.frame.size.width *= self.transform.a
            self.frame.size.height *= self.transform.d
            self.transform.a = 1
            self.transform.d = 1
            if self.circle
            {
                self.layer.cornerRadius = (self.frame.size.width) / 2
                self.clipsToBounds = true
            }
            myViewController?.gravity.addItem(self)
            myViewController?.bounce.addItem(self)
            myViewController?.boundries.addItem(self)
            sender.scale = 1
        }
        else
        {
            self.transform = CGAffineTransform(scaleX: sender.scale, y: sender.scale)
        }
    }
    
    func rotateMe(_ sender: UIRotationGestureRecognizer)
    {
        if sender.state == .began {
            myViewController?.gravity.removeItem(self)
            myViewController?.bounce.removeItem(self)
            myViewController?.boundries.removeItem(self)
        }
        else if (sender.state == .ended || sender.state == .cancelled)
        {
            myViewController?.gravity.addItem(self)
            myViewController?.bounce.addItem(self)
            myViewController?.boundries.addItem(self)
            sender.rotation = 0
        }
        else
        {
            self.transform = CGAffineTransform(rotationAngle: sender.rotation)
        }
        
    }
    
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        if circle
        {
            return .ellipse
        }
        return .rectangle
    }
    
}
