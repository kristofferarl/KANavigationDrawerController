//
//  PresentMenuAnimator.swift
//  KANavigationDrawerController
//
//  Created by Kristoffer Arlefur on 04/19/2016.
//  Copyright (c) 2016 Kristoffer Arlefur. All rights reserved.
//

public class KANavigationDrawerPresentMenuAnimator: NSObject {
}

extension KANavigationDrawerPresentMenuAnimator : UIViewControllerAnimatedTransitioning {
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

        containerView.insertSubview(toVC.view, aboveSubview: fromVC.view)

        let snapshot = fromVC.view.snapshotViewAfterScreenUpdates(false)
        snapshot.tag = KANavigationDrawerHelper.snapshotTagNumber
        containerView.insertSubview(snapshot, belowSubview: toVC.view)

        let shadowView = UIView(frame: snapshot.frame)
        shadowView.backgroundColor = UIColor.blackColor()
        shadowView.alpha = 0.0
        shadowView.tag = KANavigationDrawerHelper.shadowTagNumber

        let tapGesture = UITapGestureRecognizer(target: toVC,
                                                action: #selector(KANavigationDrawerMenuController.closeMenu))
        let panGesture = UIPanGestureRecognizer(target: toVC,
                                                action: #selector(KANavigationDrawerMenuController.handleGesture))
        shadowView.gestureRecognizers = [tapGesture, panGesture]

        snapshot.addSubview(shadowView)

        fromVC.view.hidden = true

        toVC.view.frame = CGRect(x: -KANavigationDrawerHelper.menuWidth,
                                 y: 0,
                                 width: KANavigationDrawerHelper.menuWidth,
                                 height: toVC.view.frame.size.height)

        UIView.animateWithDuration(
            transitionDuration(transitionContext),
            animations: {
                shadowView.alpha = 0.3
                toVC.view.frame = CGRect(x: 0,
                    y: 0,
                    width: KANavigationDrawerHelper.menuWidth,
                    height: toVC.view.frame.size.height)
            },
            completion: { _ in
                fromVC.view.hidden = false
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
    }
}
