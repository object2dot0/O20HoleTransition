//
//  ICAHoleTransition.swift
//  OpenTransition
//
//  Created by Tanveer on 19/07/2016.
//  Copyright © 2016 Tanveer. All rights reserved.
//

import UIKit
import QuartzCore

public class HoleTransition: NSObject {
    
    //Defines the duration of the animation
    public var duration = 0.5
    //private var usingAnimation:
    //Defines the transition mode i.e presenting ot dismissing
    public var transitionMode: ICATransitionMode = .Present
    @objc public enum ICATransitionMode: Int {
        case Present, Dismiss
    }
    
    //Defines the starting or ending mode for path of the hole animation
    @objc public enum ICAShapeLayerAnimationPathMode: Int {
        case Start, End
    }
    
}

extension HoleTransition: UIViewControllerAnimatedTransitioning {
    
    
    // MARK: - UIViewControllerAnimatedTransitioning
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            let containerView = transitionContext.containerView(),
            let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else {
                return
        }
        
        var snapshotToAnimate:UIView
        let finalFrame = transitionContext.finalFrameForViewController(fromVC)
        let viewToHideWhileTransition:UIView
        if transitionMode == .Present {
            snapshotToAnimate = toVC.view.snapshotViewAfterScreenUpdates(true)
            containerView.addSubview(toVC.view)
            viewToHideWhileTransition = toVC.view
        }
        else{
            snapshotToAnimate = fromVC.view.snapshotViewAfterScreenUpdates(true)
            viewToHideWhileTransition = fromVC.view
        }
        viewToHideWhileTransition.hidden = true
        snapshotToAnimate.frame = finalFrame
        snapshotToAnimate.layer.masksToBounds = true
        containerView.addSubview(snapshotToAnimate)
        containerView.bringSubviewToFront(snapshotToAnimate)
        
        let holeAnimationTuple = holeAnimation(forAction: transitionMode, forViewFrame: finalFrame)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = finalFrame
        maskLayer.path = holeAnimationTuple.startPath
        maskLayer.fillRule = kCAFillRuleEvenOdd;
        
        containerView.layer.mask = maskLayer;
        
        maskLayer.addAnimation(holeAnimationTuple.animation, forKey: "holeAnimation", completionClosure: { (animation, isCompleted) in
            
            viewToHideWhileTransition.hidden = false
            snapshotToAnimate.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
        maskLayer.path=holeAnimationTuple.endPath
        
    }
    
    
    
}

// MARK: - Internal methods for animation

private extension HoleTransition {
    
    private func holeAnimation(forAction action: ICATransitionMode, forViewFrame:CGRect) -> (animation: CABasicAnimation, startPath: CGPath, endPath: CGPath){
        
        let startPath = animationPath(forAction: action, shapeLayerPathMode: .Start, forViewFrame: forViewFrame)
        let endPath = animationPath(forAction: action, shapeLayerPathMode: .End, forViewFrame: forViewFrame)
        let animation = CABasicAnimation(keyPath: "path")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        animation.fromValue = startPath
        animation.toValue = endPath
        animation.duration =  CFTimeInterval(duration)
        return (animation, startPath, endPath)
        
    }
    
    
    private func animationPath(forAction action: ICATransitionMode, shapeLayerPathMode :ICAShapeLayerAnimationPathMode, forViewFrame:CGRect) -> CGPath{
        
        var rad: CGFloat
        if (action == .Present && shapeLayerPathMode == .Start) || (action == .Dismiss && shapeLayerPathMode == .End){
            rad = max(forViewFrame.size.height, forViewFrame.size.width) + 100
        }else{
            rad = 0
        }
        let path = UIBezierPath(roundedRect: CGRectMake(0, 0, forViewFrame.size.width, forViewFrame.size.height), cornerRadius: 0.0)
        let circlePath = UIBezierPath(roundedRect: CGRectMake(forViewFrame.size.width / 2.0 - rad / 2.0, forViewFrame.size.height / 2.0 - rad / 2.0, rad, rad), cornerRadius: rad)
        path.appendPath(circlePath)
        path.usesEvenOddFillRule = true
        
        return path.CGPath
    }
    
    
}


// MARK: - Closure based CAAnimation methods


// Thanks to LucasTizma for closure based CAAnimation methods
// https://gist.github.com/LucasTizma/688aaa9bb44a2178ec44cf030c74e426

internal typealias LayerAnimationBeginClosure = (CAAnimation) -> Void
internal typealias LayerAnimationCompletionClosure = (CAAnimation, Bool) -> Void

// MARK: LayerAnimationDelegate Class -

private class LayerAnimationDelegate: NSObject {
    
    var beginClosure: LayerAnimationBeginClosure?
    var completionClosure: LayerAnimationCompletionClosure?
    
    // MARK: - Protocol Implementations
    
    // MARK: CAAnimation (Informal)
    
    override func animationDidStart(animation: CAAnimation) {
        guard let beginClosure = beginClosure else { return }
        beginClosure(animation)
    }
    
    override func animationDidStop(animation: CAAnimation, finished: Bool) {
        guard let completionClosure = completionClosure else { return }
        completionClosure(animation, finished)
    }
    
}

// MARK: - CALayer Extension -

extension CALayer {
    
    // MARK: - Conveniences for Adding Animations
    
    func addAnimation(animation: CAAnimation) {
        addAnimation(animation, forKey: nil)
    }
    
    func addAnimation(animation: CAAnimation, forKey key: String?, completionClosure: LayerAnimationCompletionClosure?) {
        addAnimation(animation, forKey: key, beginClosure: nil, completionClosure: completionClosure)
    }
    
    func addAnimation(animation: CAAnimation, forKey key: String?, beginClosure: LayerAnimationBeginClosure?, completionClosure: LayerAnimationCompletionClosure?) {
        let animationDelegate = LayerAnimationDelegate()
        animationDelegate.beginClosure = beginClosure
        animationDelegate.completionClosure = completionClosure
        
        animation.delegate = animationDelegate
        
        addAnimation(animation, forKey: key)
    }
    
    func replaceAnimation(animation: CAAnimation, forKey key: String) {
        replaceAnimation(animation, forKey: key, beginClosure: nil, completionClosure: nil)
    }
    
    func replaceAnimation(animation: CAAnimation, forKey key: String, completionClosure: LayerAnimationCompletionClosure?) {
        replaceAnimation(animation, forKey: key, beginClosure: nil, completionClosure: completionClosure)
    }
    
    func replaceAnimation(animation: CAAnimation, forKey key: String, beginClosure: LayerAnimationBeginClosure?, completionClosure: LayerAnimationCompletionClosure?) {
        removeAnimationForKey(key)
        addAnimation(animation, forKey: key, beginClosure: beginClosure, completionClosure: completionClosure)
    }
    
}