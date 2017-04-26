//
//  ViewController.swift
//  Dynamics_Demo
//
//  Created by apple on 17/4/22.
//  Copyright © 2017年 DWade. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate {

    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var collision: UICollisionBehavior!
//    var firstContact = false
    
    var square: UIView!
    var snap: UISnapBehavior!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sleep(8);
        //创建一个物体
        square = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        square.backgroundColor = UIColor.gray
        view.addSubview(square)
        
        //加重力
        
        animator = UIDynamicAnimator(referenceView: view)
        gravity = UIGravityBehavior(items: [square])
        animator.addBehavior(gravity)

        
        //处理碰撞
        let barrier = UIView(frame: CGRect(x: 0, y: 300, width: 130, height: 20))
        barrier.backgroundColor = UIColor.red
        view.addSubview(barrier)
        
        
        //碰撞行为（不给掉出边界）
        collision = UICollisionBehavior(items: [square])
        // add a boundary that has the same frame as the barrier
        collision.addBoundary(withIdentifier: "barrier" as NSCopying, for: UIBezierPath(rect: barrier.frame))
//        collision = UICollisionBehavior(items: [square, barrier]) //碰撞对象需要知道它应该与之相互作用的每个视图; 因此，将项目列表中的障碍添加到允许碰撞对象也可以作用在屏障上。
        collision.translatesReferenceBoundsIntoBoundary = true
        collision.collisionDelegate = self
        animator.addBehavior(collision)
        
        let itemBehaviour = UIDynamicItemBehavior(items: [square])
        itemBehaviour.elasticity = 0.6
        animator.addBehavior(itemBehaviour)
        
//        var updateCount = 0
//        collision.action = {
//            if (updateCount % 3 == 0) {
//                let outline = UIView(frame: square.bounds)
//                outline.transform = square.transform
//                outline.center = square.center
//                
//                outline.alpha = 0.5
//                outline.backgroundColor = UIColor.clear
//                outline.layer.borderColor = square.layer.presentation()?.backgroundColor
//                outline.layer.borderWidth = 1.0
//                self.view.addSubview(outline)
//            }
//            
//            updateCount += 1
//        }
       
    }
    
func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
let collidingView = item as! UIView
collidingView.backgroundColor = UIColor.yellow
UIView.animate(withDuration: 0.3) {
    collidingView.backgroundColor = UIColor.gray
}
    print("Boundary contact occurred - \(identifier)")
    
//if (!firstContact) {
//    firstContact = true
//    
//    let square = UIView(frame: CGRect(x: 30, y: 0, width: 100, height: 100))
//    square.backgroundColor = UIColor.gray
//    view.addSubview(square)
//    
//    collision.addItem(square)
//    gravity.addItem(square)
//    
//    let attach = UIAttachmentBehavior(item: collidingView, attachedTo:square)
//    animator.addBehavior(attach)
//}
    
}
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if snap != nil {
            animator.removeBehavior(snap)
        }
        for touch: AnyObject in touches {
            let touch:UITouch = touch as! UITouch
            snap = UISnapBehavior(item: square, snapTo: touch.location(in: view))
            animator .addBehavior(snap) //add snap
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

