//
//  DismissMenuAnimator.swift
//  KANavigationDrawerController
//
//  Created by Kristoffer Arlefur on 04/19/2016.
//  Copyright (c) 2016 Kristoffer Arlefur. All rights reserved.
//

public class KANavigationDrawerDismissMenuAnimator: NSObject {
}

extension KANavigationDrawerDismissMenuAnimator : UIViewControllerAnimatedTransitioning {
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return KANavigationDrawerHelper.animationDuration
    }

    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
            let containerView = transitionContext.containerView()
            else {
                return
        }

        let snapshot = containerView.viewWithTag(KANavigationDrawerHelper.snapshotTagNumber)
        let shadowView = containerView.viewWithTag(KANavigationDrawerHelper.shadowTagNumber)

        UIView.animateWithDuration(
            transitionDuration(transitionContext),
            animations: {
                shadowView?.alpha = 0.0
                fromVC.view.center.x -= KANavigationDrawerHelper.menuWidth
            },
            completion: { _ in
                let didTransitionComplete = !transitionContext.transitionWasCancelled()
                if didTransitionComplete {
                    containerView.insertSubview(toVC.view, aboveSubview: fromVC.view)
                    snapshot?.removeFromSuperview()
                }
                transitionContext.completeTransition(didTransitionComplete)
            })
    }
}
