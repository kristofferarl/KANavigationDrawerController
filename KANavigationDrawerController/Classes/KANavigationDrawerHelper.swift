//
//  KANavigationDrawerHelper.swift
//  KANavigationDrawerController
//
//  Created by Kristoffer Arlefur on 04/19/2016.
//  Copyright (c) 2016 Kristoffer Arlefur. All rights reserved.
//

public enum Direction {
    case Up
    case Down
    case Left
    case Right
}

public struct KANavigationDrawerHelper {

    static let menuWidth: CGFloat = 300
    static let animationDuration: NSTimeInterval = 0.4

    static let percentThreshold: CGFloat = 0.3
    static let snapshotTagNumber = 12345
    static let shadowTagNumber = 123456

    public static func calculateProgress(translationInView: CGPoint, viewBounds: CGRect,
                                         direction: Direction) -> CGFloat {
        let pointOnAxis: CGFloat
        let axisLength: CGFloat
        switch direction {
        case .Up, .Down:
            pointOnAxis = translationInView.y
            axisLength = viewBounds.height
        case .Left, .Right:
            pointOnAxis = translationInView.x
            axisLength = viewBounds.width
        }
        let movementOnAxis = pointOnAxis / axisLength
        let positiveMovementOnAxis: Float
        let positiveMovementOnAxisPercent: Float
        switch direction {
        case .Right, .Down: // positive
            positiveMovementOnAxis = fmaxf(Float(movementOnAxis), 0.0)
            positiveMovementOnAxisPercent = fminf(positiveMovementOnAxis, 1.0)
            return CGFloat(positiveMovementOnAxisPercent)
        case .Up, .Left: // negative
            positiveMovementOnAxis = fminf(Float(movementOnAxis), 0.0)
            positiveMovementOnAxisPercent = fmaxf(positiveMovementOnAxis, -1.0)
            return CGFloat(-positiveMovementOnAxisPercent)
        }
    }

    public static func mapGestureStateToInteractor(gestureState: UIGestureRecognizerState, progress: CGFloat,
                                                   interactor: KANavigationDrawerInteractor?, triggerSegue: () -> ()) {
        guard let interactor = interactor else { return }
        switch gestureState {
        case .Began:
            interactor.hasStarted = true
            triggerSegue()
        case .Changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.updateInteractiveTransition(progress)
        case .Cancelled:
            interactor.hasStarted = false
            interactor.cancelInteractiveTransition()
        case .Ended:
            interactor.hasStarted = false
            interactor.shouldFinish
                ? interactor.finishInteractiveTransition()
                : interactor.cancelInteractiveTransition()
        default:
            break
        }
    }
}
