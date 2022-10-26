//
//  ImageDismissAnimatedTransitioning.swift
//  Unsplash_Assignment
//
//  Created by Woody on 2022/02/12.
//

import UIKit

class ImageDismissAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    var imageView: UIImageView!
    
    var contentViewTopAnchor: NSLayoutConstraint!
    var contentViewWidthAnchor: NSLayoutConstraint!
    var contentViewHeightAnchor: NSLayoutConstraint!
    var contentViewLeadingAnchor: NSLayoutConstraint!
    
    var targetIndexPath: IndexPath
    var targetData: PhotoData
    
    init(targetIndexPath: IndexPath, targetData: PhotoData) {
        self.targetIndexPath = targetIndexPath
        self.targetData = targetData
        super.init()
        
    }
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let mainTabBarController = transitionContext.viewController(forKey: .to) as? MainTabBarController else {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            return
        }
        
        if let toViewController = mainTabBarController.viewControllers![0] as? PhotoListViewController,
           let detailViewController = transitionContext.viewController(forKey: .from) as? DetailViewController,
           let toView = toViewController.view,
           let fromView = detailViewController.view,
           let targetCell = toViewController.collectionView.cellForItem(at: targetIndexPath) as? PhotoCollectionViewCell {
            // 디테일 -> 홈
            // 애니메이션 준비
            let startFrame = calculateDetailImageViewFrame()
            setupImageView(withStartFrame: startFrame, containerView: containerView)
            
            // 애니메이션 시작
            imageView.alpha = 1
            targetCell.alpha = 0
            fromView.alpha = 0
            
            let finalFrame = toViewController.collectionView.convert(targetCell.frame, to: toView)
            contentViewTopAnchor.constant = finalFrame.minY
            
            UIView.animate(withDuration: 0.25,
                           delay: 0,
                           options: .curveEaseOut,
                           animations: { [weak self] in
                self?.imageView.setNeedsUpdateConstraints()
            }, completion: {[weak self] _ in
                targetCell.alpha = 1
                self?.imageView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        } else {
            // 검색디테일 -> 검색
            guard let toViewController = mainTabBarController.viewControllers![1] as? SearchViewController,
                  let detailViewController = transitionContext.viewController(forKey: .from) as? SearchDetailViewController,
                  let toView = toViewController.view,
                  let fromView = detailViewController.view,
                  let targetCell = toViewController.collectionView.cellForItem(at: targetIndexPath) as? SearchPhotoCollectionViewCell else {
                      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                      return
                  }
                      
            // 애니메이션 준비
            let startFrame = calculateDetailImageViewFrame()
            setupImageView(withStartFrame: startFrame, containerView: containerView)
            imageView.alpha = 1
            targetCell.alpha = 0
            fromView.alpha = 0
            
            // 애니메이션 시작
            let finalFrame = toViewController.collectionView.convert(targetCell.frame, to: toView)
            contentViewTopAnchor.constant = finalFrame.minY
            contentViewLeadingAnchor.constant = finalFrame.minX
            contentViewWidthAnchor.constant = finalFrame.width
            contentViewHeightAnchor.constant = finalFrame.height
            UIView.animate(withDuration: 0.25,
                           delay: 0,
                           options: .curveEaseOut,
                           animations: { [weak self] in
                self?.imageView.setNeedsUpdateConstraints()
            }, completion: {[weak self] _ in
                targetCell.alpha = 1
                self?.imageView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }
    
    private func calculateDetailImageViewFrame() -> CGRect {
        let collectionViewHeight = DeviceInfo.screenHeight - DeviceInfo.bottomSafeAreaInset - DeviceInfo.topSafeAreaInset
        let imageWidth  = CGFloat(targetData.width)
        let imageHeight = CGFloat(targetData.height)
        let cellHeight  = imageHeight * DeviceInfo.screenWidth / imageWidth
        let inset = (collectionViewHeight - cellHeight) / 2
        
        return CGRect(x: 0,
                      y: inset + DeviceInfo.topSafeAreaInset,
                      width: DeviceInfo.screenWidth,
                      height: cellHeight)
    }
    
    private func setupImageView(withStartFrame frame: CGRect, containerView: UIView) {
        let image: UIImage?
        if let regular = targetData.image {
            image = regular
        } else {
            image = targetData.thumbImage
        }
        imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.frame = frame
        containerView.addSubview(imageView)
        NSLayoutConstraint.activate(
            makeConstraints(containerView: containerView, imageView: imageView, originframe: frame)
        )
    }
    
    private func makeConstraints(containerView: UIView, imageView: UIImageView, originframe: CGRect) -> [NSLayoutConstraint] {
        contentViewLeadingAnchor = imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: originframe.minX)
        contentViewTopAnchor = imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: originframe.minY)
        contentViewHeightAnchor = imageView.heightAnchor.constraint(equalToConstant: originframe.height)
        contentViewWidthAnchor = imageView.widthAnchor.constraint(equalToConstant: originframe.width)
        
        return [contentViewLeadingAnchor, contentViewTopAnchor, contentViewHeightAnchor, contentViewWidthAnchor]
        
    }
}
