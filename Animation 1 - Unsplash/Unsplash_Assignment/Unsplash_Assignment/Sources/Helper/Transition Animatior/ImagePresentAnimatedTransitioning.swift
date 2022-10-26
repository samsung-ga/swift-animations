//
//  ImagePresentAnimatedTransitioning.swift
//  Unsplash_Assignment
//
//  Created by Woody on 2022/02/11.
//

import UIKit

class ImagePresentAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    var imageView: UIImageView!
    
    var contentViewTopAnchor: NSLayoutConstraint!
    var contentViewWidthAnchor: NSLayoutConstraint!
    var contentViewHeightAnchor: NSLayoutConstraint!
    var contentViewCenterXAnchor: NSLayoutConstraint!
    
    var targetIndexPath: IndexPath
    var targetData: PhotoData
    
    init(targetIndexPath: IndexPath, targetData: PhotoData) {
        self.targetIndexPath = targetIndexPath
        self.targetData = targetData
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        guard let mainTabBarController = transitionContext.viewController(forKey: .from) as? MainTabBarController else {
                  transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                  return
              }
        
        if let fromViewController = judgeStartViewController(fromViewController: mainTabBarController),
           let detailViewController = transitionContext.viewController(forKey: .to) as? DetailViewController,
           let toView = detailViewController.view,
           let fromView = fromViewController.view,
           let targetCell = fromViewController.collectionView.cellForItem(at: targetIndexPath) as? PhotoCollectionViewCell {
            // 홈 -> 디테일
            
            // 애니메이션 준비
            let startFrame = fromViewController.collectionView.convert(targetCell.frame, to: fromView)
            setupImageView(withStartFrame: startFrame, containerView: containerView)
            containerView.addSubview(toView)
            toView.alpha = 0
            targetCell.alpha = 0
            imageView.alpha = 1
            
            
            // 애니메이션 시작
            let lastFrame = calculateDetailImageViewFrame()
            contentViewTopAnchor.constant = lastFrame.minY
            UIView.animate(withDuration: 0.6,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 1.0,
                           options: [.curveLinear],
                           animations: { [weak self] in
                self?.imageView.setNeedsUpdateConstraints()
            }, completion: { [weak self] _ in
                toView.alpha = 1
                targetCell.alpha = 1
                self?.imageView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
            
        } else {
            // 검색 -> 검색디테일
            guard let fromViewController = mainTabBarController.viewControllers![1] as? SearchViewController,
                  let fromView = fromViewController.view,
                  let detailViewController = transitionContext.viewController(forKey: .to) as? SearchDetailViewController,
                  let toView = detailViewController.view,
                  let targetCell = fromViewController.collectionView.cellForItem(at: targetIndexPath) as? SearchPhotoCollectionViewCell else {
                      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                      return
                  }
            // 애니메이션 준비
            let startFrame = fromViewController.collectionView.convert(targetCell.frame, to: fromView)
            setupImageView(withStartFrame: startFrame, containerView: containerView)
            contentViewTopAnchor.constant = startFrame.minY + Constant.searchBarHeight
            containerView.addSubview(toView)
            toView.alpha = 0
            targetCell.alpha = 0
            imageView.alpha = 1
            
            // 애니메이션 시작
            let lastFrame = calculateDetailImageViewFrame()
            contentViewTopAnchor.constant = lastFrame.minY
            contentViewWidthAnchor.constant = lastFrame.width
            contentViewHeightAnchor.constant = lastFrame.height
            UIView.animate(withDuration: 0.6,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 1.0,
                           options: [.curveLinear],
                           animations: { [weak self] in
                self?.imageView.setNeedsUpdateConstraints()
            }, completion: { [weak self] _ in
                toView.alpha = 1
                targetCell.alpha = 1
                self?.imageView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
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
    
    private func judgeStartViewController(fromViewController: MainTabBarController) -> PhotoListViewController? {
        if let photoListViewController = fromViewController.viewControllers![0] as? PhotoListViewController {
            return photoListViewController
        }
        return nil
    }
    
    private func makeConstraints(containerView: UIView, imageView: UIImageView, originframe: CGRect) -> [NSLayoutConstraint] {
        contentViewCenterXAnchor = imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        contentViewTopAnchor = imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: originframe.minY)
        contentViewHeightAnchor = imageView.heightAnchor.constraint(equalToConstant: originframe.height)
        contentViewWidthAnchor = imageView.widthAnchor.constraint(equalToConstant: originframe.width)

        return [contentViewCenterXAnchor, contentViewTopAnchor, contentViewHeightAnchor, contentViewWidthAnchor]
    }
}
