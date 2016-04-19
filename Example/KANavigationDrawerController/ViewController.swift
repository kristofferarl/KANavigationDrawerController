//
//  ViewController.swift
//  KANavigationDrawerController
//
//  Created by Kristoffer Arlefur on 04/19/2016.
//  Copyright (c) 2016 Kristoffer Arlefur. All rights reserved.
//

import UIKit
import KANavigationDrawerController

class ViewController: UIViewController {

    let interactor = KANavigationDrawerInteractor()

    @IBAction func openMenu(sender: AnyObject) {
        performSegueWithIdentifier("openMenu", sender: nil)
    }

    @IBAction func edgePanGesture(sender: UIScreenEdgePanGestureRecognizer) {

        let translation = sender.translationInView(view)

        let progress = KANavigationDrawerHelper.calculateProgress(translation, viewBounds: view.bounds,
                                                                  direction: .Right)

        KANavigationDrawerHelper.mapGestureStateToInteractor(
            sender.state,
            progress: progress,
            interactor: interactor) {
                self.performSegueWithIdentifier("openMenu", sender: nil)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let drawerMenu = segue.destinationViewController as? KANavigationDrawerMenuController {
            drawerMenu.transitioningDelegate = self
            drawerMenu.interactor = interactor
            drawerMenu.menuActionDelegate = self
        }
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController,
                                                   presentingController presenting: UIViewController,
                                                                        sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return KANavigationDrawerPresentMenuAnimator()
    }

    func animationControllerForDismissedController(dismissed: UIViewController) ->
        UIViewControllerAnimatedTransitioning? {
        return KANavigationDrawerDismissMenuAnimator()
    }

    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }

    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}

extension ViewController : KANavigationDrawerMenuActionDelegate {
    func openSegue(segueName: String, sender: AnyObject?) {
        dismissViewControllerAnimated(true) {
            self.performSegueWithIdentifier(segueName, sender: sender)
        }
    }
}
