//
//  ShowController.swift
//  empty
//
//  Created by macc on 16/10/19.
//  Copyright © 2016年 ZhengGuiJie. All rights reserved.
//

import UIKit
import YYWebImage

private let cellMargin: CGFloat = 20
private let reuseIdentifier = "Cell"
private let SCREEN_WIDTH = UIScreen.mainScreen().bounds.width
private let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.height

/// 显示大图VC
class ShowImagesController: UICollectionViewController {
    
    private var dataSource: [String]!
    private lazy var pageControl = UIPageControl()
    /// 当前第几页--默认0
    private var currentIndex: Int = 0 {
        didSet {
            pageControl.currentPage = currentIndex
        }
    }
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    convenience init(dataSource: [String], currentIndex: Int) {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.mainScreen().bounds.width + cellMargin, height: UIScreen.mainScreen().bounds.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .Horizontal
        self.init(collectionViewLayout: layout)
        self.dataSource = dataSource
        self.currentIndex = currentIndex
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        collectionView?.frame = UIScreen.mainScreen().bounds
        collectionView?.frame.size.width = UIScreen.mainScreen().bounds.size.width + cellMargin
        
        collectionView?.alwaysBounceHorizontal = true
        collectionView?.pagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        
        collectionView?.registerClass(PicuterCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.scrollToItemAtIndexPath(NSIndexPath(forItem: currentIndex, inSection: 0), atScrollPosition: .Left, animated: false)
        
        pageControl.frame = CGRect(x: 50, y: SCREEN_HEIGHT - 50, width: SCREEN_WIDTH - 100, height: 30)
        pageControl.numberOfPages = dataSource.count
        pageControl.currentPage = currentIndex
        pageControl.pageIndicatorTintColor = UIColor.grayColor()
        pageControl.currentPageIndicatorTintColor = UIColor.whiteColor()
        view.addSubview(pageControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ShowImagesController {
     override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
     override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as? PicuterCell
        let url = NSURL(string: dataSource[indexPath.item])
        
        cell?.picV.yy_setImageWithURL(url, options: [.ProgressiveBlur, .SetImageWithFadeAnimation])
        cell?.dismiss({
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        return cell!
    }
    
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        currentIndex = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
    }
    
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = cell as? PicuterCell else {
            return
        }
        cell.reset()
    }
}

/// 图片Collectioncell
class PicuterCell: UICollectionViewCell, UIScrollViewDelegate {
    
    typealias tapActionClosure = () -> Void
    private(set) lazy var picV = UIImageView()
    private lazy var scrollView = UIScrollView()
    private(set) var action: tapActionClosure?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reset() {
        scrollView.setZoomScale(1.0, animated: false)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setUpUI() {
        contentView.addSubview(scrollView)
        // 关闭autoresizing 不关闭否则程序崩溃
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: scrollView, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: scrollView, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: scrollView, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: scrollView, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1, constant: -cellMargin)
        contentView.addConstraints([topConstraint, leftConstraint, bottomConstraint, rightConstraint])

        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 3
        scrollView.delegate = self
        
        scrollView.addSubview(picV)
        picV.contentMode = .ScaleAspectFit
        
        picV.translatesAutoresizingMaskIntoConstraints = false
        let centerXCon = NSLayoutConstraint(item: picV, attribute: .CenterX, relatedBy: .Equal, toItem: scrollView, attribute: .CenterX, multiplier: 1, constant: 0)
        let centerYCon = NSLayoutConstraint(item: picV, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1, constant: 0)
        
        let leftCon = NSLayoutConstraint(item: picV, attribute: .Left, relatedBy: .Equal, toItem: scrollView, attribute: .Left, multiplier: 1, constant: 0)
        let rightCon = NSLayoutConstraint(item: picV, attribute: .Right, relatedBy: .Equal, toItem: scrollView, attribute: .Right, multiplier: 1, constant: 0)
        
        let heightCon = NSLayoutConstraint(item: picV, attribute: .Height, relatedBy: .Equal, toItem: scrollView, attribute: .Height, multiplier: 1, constant: 0)

        scrollView.addConstraints([heightCon, leftCon, rightCon, centerYCon, centerXCon])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        picV.userInteractionEnabled = true
        picV.addGestureRecognizer(tap)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return picV
    }
    
    func tapAction(tap: tapActionClosure) {
        guard let action = action else { return }
        action()
    }
    
    func dismiss(action: tapActionClosure) {
        self.action = action
    }
}


class ModalAnimationDelegate: NSObject, UIViewControllerTransitioningDelegate  {
    private var isPresentAnimationing: Bool = true
    private var originalView: UIImageView!
    private let animatTime: NSTimeInterval = 0.5
    init(originalView: UIImageView) {
        self.originalView = originalView
        super.init()
    }
    
    class func reset(delegate: ModalAnimationDelegate?, imageView: UIImageView) -> ModalAnimationDelegate {
        var delegate = delegate
        delegate = nil
        delegate = ModalAnimationDelegate(originalView: imageView)
        guard let resetDelegate = delegate else {
            fatalError("does have no delegate")
        }
        return resetDelegate
    }
}

extension ModalAnimationDelegate: UIViewControllerAnimatedTransitioning {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresentAnimationing = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresentAnimationing = false
        return self
    }
}

extension ModalAnimationDelegate {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return animatTime
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        isPresentAnimationing ? presentViewAnimation(transitionContext) : dismissViewAnimation(transitionContext)
    }
    
    /**
     modal动画
     */
    private func presentViewAnimation(transitionContext: UIViewControllerContextTransitioning) {
        guard let image = originalView.image else {
            fatalError("there is no image at selectedImageView")
        }
      // 过渡view
        guard let toView = transitionContext.viewForKey(UITransitionContextToViewKey) else {
            return
        }
        // 容器view
        guard let containerView = transitionContext.containerView() else {
            return
        }
        // 过渡view添加到容器view上
        containerView.addSubview(toView)
        //新建一个imageView添加到目标view之上，做为动画view
        let animateViwe = UIImageView()
        animateViwe.image = image
        animateViwe.contentMode = .ScaleAspectFill
        animateViwe.clipsToBounds = true
        //被选中的imageView到目标view上的坐标转换
        guard let window = UIApplication.sharedApplication().delegate?.window else {
            return
        }
        let originalFrame = originalView.convertRect(originalView.bounds, toView: window)
        animateViwe.frame = originalFrame
        containerView.addSubview(animateViwe)
        
        toView.alpha = 0
        //过度动画
        UIView.animateWithDuration(animatTime, animations: { 
            let width = UIScreen.mainScreen().bounds.size.width
            let height = image.size.height * width / image.size.width
            let y = (UIScreen.mainScreen().bounds.size.height - image.size.height * width / image.size.width) * 0.5
            animateViwe.frame = CGRectMake(0, y, width, height)
            }) { (_) in
                transitionContext.completeTransition(true)
                toView.alpha = 1
                animateViwe.removeFromSuperview()
        }
    }
    
    private func dismissViewAnimation(transitionContext: UIViewControllerContextTransitioning) {
        // 过渡view
        guard let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey) else {
            return
        }
        // 容器view
        guard let containerView = transitionContext.containerView() else {
            return
        }
       //取出modal出的来控制器
        guard let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as? ShowImagesController else { return }
        //取出当前显示的cell
        guard let cell = fromVC.collectionView?.visibleCells().first as? PicuterCell else { return }
        
        guard let image = cell.picV.image else { return }
        guard let window = UIApplication.sharedApplication().delegate?.window else {
            return
        }
        let originalFrame = cell.picV.convertRect(cell.picV.bounds, toView: window)
        //新建过渡动画imageView
        let animateImageView = UIImageView()
        animateImageView.frame = originalFrame
        animateImageView.image = image
        animateImageView.contentMode = .ScaleAspectFit
        containerView.addSubview(animateImageView)
        // 动画最后停止的frame
        let endFrame = originalView.convertRect(originalView.bounds, toView: window)
        
        UIView.animateWithDuration(animatTime, animations: {
            animateImageView.frame = endFrame
            fromView.alpha = 0
            }) { (_) in
            transitionContext.completeTransition(true)
            animateImageView.removeFromSuperview()
        }
    }
}


/**
 *  显示大图协议
 */
protocol ShowImageProtocol {}

extension ShowImageProtocol where Self: UIViewController {
    /**
     不带动画的显示大图
     
     - parameter dataSource:   数据源
     - parameter currentIndex: 第几个
     */
    func showImages(with dataSource: [String], currentIndex: Int) {
        
        guard dataSource.count - 1 >= currentIndex else {
            return
        }
        let vc = ShowImagesController(dataSource: dataSource, currentIndex: currentIndex)
        vc.modalTransitionStyle = .CrossDissolve
        presentViewController(vc, animated: true, completion: nil)
    }
}

extension ShowImageProtocol where Self: UIViewController, Self: UIViewControllerTransitioningDelegate {
    /**
     带动画的显示大图---必须遵循UIViewControllerTransitioningDelegate
     
     - parameter dataSource:   数据源
     - parameter currentIndex: 第几个
     - parameter imageView:    要显示的imageView，主要是为了获取frame
     */
    func showImages(with dataSource: [String], currentIndex: Int, delegate: ModalAnimationDelegate?) {
        guard let delegate = delegate else {
            fatalError("does not have delegate")
        }
        guard dataSource.count - 1 >= currentIndex else {
            return
        }
        let vc = ShowImagesController(dataSource: dataSource, currentIndex: currentIndex)
        vc.transitioningDelegate = delegate
        vc.modalPresentationStyle = .Custom
        presentViewController(vc, animated: true, completion: nil)
    }
}
