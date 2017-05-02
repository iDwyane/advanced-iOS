//
//  ViewController.swift
//  DynamicToss_Demo
//
//  Created by apple on 17/4/29.
//  Copyright © 2017年 DWade. All rights reserved.
//

import UIKit

let ThrowingThreshold: CGFloat = 1000
let ThrowingVelocityPadding: CGFloat = 35

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var redSquare: UIView!
    private var originalBounds = CGRect.zero
    private var orignalCenter = CGPoint.zero
    private var animator: UIDynamicAnimator!
    private var attachmentBehavior: UIAttachmentBehavior!
    private var pushBehavior: UIPushBehavior!
    private var itemBehavior: UIDynamicItemBehavior!
    
    @IBOutlet weak var blueSquare: UIView!
    
    @IBAction func handleAttachmentGesture(_ sender: UIPanGestureRecognizer) {
        let location = sender.location(in: view)
        let boxLocation = sender.location(in: imageView)
        
        switch sender.state {
        case .began:
            print("Your touch start position is \(location)")
            print("Start location in image is \(boxLocation)")
            
    animator.removeAllBehaviors()
    
    let centerOffset = UIOffset(horizontal: boxLocation.x - imageView.bounds.midX, vertical: boxLocation.y - imageView.bounds.midY)
    attachmentBehavior = UIAttachmentBehavior(item: imageView, offsetFromCenter: centerOffset, attachedToAnchor: location)
    
    redSquare.center = attachmentBehavior.anchorPoint
    blueSquare.center = location
    
    animator.addBehavior(attachmentBehavior)
            
            
        case .ended:
            print("Your touch end position is \(location)")
            print("End location in image is \(boxLocation)")
            
            // 1
            let velocity = sender.velocity(in: view)
            let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
            
            if magnitude > ThrowingThreshold {
                // 2
                let pushBehavior = UIPushBehavior (items: [imageView], mode: .instantaneous)
                pushBehavior.pushDirection = CGVector(dx: velocity.x / 10, dy: velocity.y / 10)
                pushBehavior.magnitude = magnitude / ThrowingVelocityPadding
                
                self.pushBehavior = pushBehavior
                animator.addBehavior(pushBehavior)
                
                // 3
                let angle = Int(arc4random_uniform(20)) - 10
                
                itemBehavior = UIDynamicItemBehavior(items: [imageView])
                itemBehavior.friction = 0.2
                itemBehavior.allowsRotation = true
                itemBehavior.addAngularVelocity(CGFloat(angle), for: imageView)
                animator.addBehavior(itemBehavior)
                
                // 4
                let timeOffset = Int64(0.4 * Double(NSEC_PER_SEC))
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(timeOffset) / Double(NSEC_PER_SEC)) {
                    self.resetPosition()
                }
            } else {
              resetPosition()
            }
        default:
            attachmentBehavior.anchorPoint = sender.location(in: view)
            redSquare.center = attachmentBehavior.anchorPoint
        }

    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animator = UIDynamicAnimator(referenceView: view)
        originalBounds = imageView.bounds
        orignalCenter = imageView.center
    }
    
    func resetPosition() {
        animator.removeAllBehaviors()
        
        UIView.animate(withDuration: 0.45) { 
            self.imageView.bounds = self.originalBounds
            self.imageView.center = self.orignalCenter
            self.imageView.transform = CGAffineTransform.identity
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

