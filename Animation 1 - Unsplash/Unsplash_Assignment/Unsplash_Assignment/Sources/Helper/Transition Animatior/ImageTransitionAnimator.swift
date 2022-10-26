//
//  ImageTransitionController.swift
//  Unsplash_Assignment
//
//  Created by Woody on 2022/02/11.
//

import UIKit

final class ImageTransitioAnimator: NSObject, UIViewControllerTransitioningDelegate {
    
    var superViewcontroller: UIViewController?
    var indexPath: IndexPath?
    var targetData: PhotoData?

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return ImageTransitionPresentationController(presentedViewController: presented, presenting: presenting)
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ImagePresentAnimatedTransitioning(targetIndexPath: indexPath!, targetData: targetData!)
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ImageDismissAnimatedTransitioning(targetIndexPath: indexPath!, targetData: targetData!)
    }
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
}



