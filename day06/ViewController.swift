//
//  ViewController.swift
//  day06
//
//  Created by Cristian Cosneanu on 4/27/17.
//  Copyright © 2017 Cristian Cosneanu. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    var objects: [UIView] = []
    var animator: UIDynamicAnimator?
    var selectedView:UIView?
    
    var motionManager = CMMotionManager()
    
    public var gravity = UIGravityBehavior()
    public var boundries = UICollisionBehavior()
    public var bounce = UIDynamicItemBehavior()
    
    override func viewDidAppear(_ animated: Bool) {
        
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) {
            (data, error) in
            if let a = data
            {
                let accx = CGFloat(a.acceleration.x) * 10
                let accy = CGFloat(a.acceleration.y * -1) * 10
                self.gravity.gravityDirection = CGVector(dx: accx, dy: accy)
            }
            else
            {
                print("\nError")
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.animator = UIDynamicAnimator(referenceView: self.view)
        self.gravity = UIGravityBehavior(items: self.objects)
        self.gravity.gravityDirection = CGVector(dx: 0.0, dy: 0.5)
        
        self.boundries = UICollisionBehavior(items: self.objects)
        self.boundries.translatesReferenceBoundsIntoBoundary = true
        
        self.bounce = UIDynamicItemBehavior(items: self.objects)
        self.bounce.elasticity = 0.5
        
        self.animator?.addBehavior(self.bounce)
        self.animator?.addBehavior(self.boundries)
        self.animator?.addBehavior(self.gravity)
        
    }
    
    @IBAction func AddObject(_ sender: UITapGestureRecognizer) {
        var point = sender.location(in: self.view)
        point.x -= 50
        point.y -= 50
        let shape = MyView(frame: CGRect(origin: point, size: CGSize(width: 30, height: 30)))
        shape.putShape(view: self.view)
        shape.addGestureRecognizer(UIPanGestureRecognizer(target: shape, action: #selector(shape.panMe(_:))))
        shape.addGestureRecognizer(UIPinchGestureRecognizer(target: shape, action: #selector(shape.pinchMe(_:))))
        shape.addGestureRecognizer(UIRotationGestureRecognizer(target: shape, action: #selector(shape.rotateMe(_:))))
        shape.myViewController = self
        self.gravity.addItem(shape)
        self.boundries.addItem(shape)
        self.bounce.addItem(shape)
    }
    
    
}

