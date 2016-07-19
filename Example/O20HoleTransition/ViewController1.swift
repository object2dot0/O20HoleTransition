//
//  ViewController.swift
//  O20HoleTransition
//
//  Created by Tanveer on 07/19/2016.
//  Copyright (c) 2016 Tanveer. All rights reserved.
//

import UIKit
import O20HoleTransition

class ViewController1: UIViewController,UIViewControllerTransitioningDelegate {

    let transition = HoleTransition()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Calling class method to push the second controller
        self.push(self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //Can selectivley apply changes by checking destinationviewcontroller
        let controller = segue.destinationViewController
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .Custom
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Present
        return transition
    }
    
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Dismiss
        return transition
    }
    
    
    @IBAction func push(sender: AnyObject) {
        if self.presentedViewController == nil {
            self.performSegueWithIdentifier("ViewController", sender: self)
        }
        
    }

    
    
}

