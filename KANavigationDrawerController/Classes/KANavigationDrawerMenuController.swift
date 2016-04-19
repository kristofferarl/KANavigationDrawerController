//
//  KANavigationDrawerMenu.swift
//  KANavigationDrawerController
//
//  Created by Kristoffer Arlefur on 04/19/2016.
//  Copyright (c) 2016 Kristoffer Arlefur. All rights reserved.
//

public protocol KANavigationDrawerMenuActionDelegate {
    func openSegue(segueName: String, sender: AnyObject?)
}

public class KANavigationDrawerMenuController: UIViewController {

    public var interactor: KANavigationDrawerInteractor? = nil

    public var menuActionDelegate: KANavigationDrawerMenuActionDelegate? = nil

    @IBAction func handleGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)

        let progress = KANavigationDrawerHelper.calculateProgress(translation, viewBounds: view.bounds,
                                                                  direction: .Left)

        KANavigationDrawerHelper.mapGestureStateToInteractor(
            sender.state,
            progress: progress,
            interactor: interactor) {
                self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    @IBAction func closeMenu(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
