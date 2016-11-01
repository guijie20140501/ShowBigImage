//
//  ListPicsController.swift
//  pics
//
//  Created by macc on 16/10/31.
//  Copyright © 2016年 ZhengGuiJie. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ListPicsController: UICollectionViewController {

    private lazy var viewModel = PicsViewModel()
    private var delegate: ModalAnimationDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        self.collectionView!.registerClass(PicCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ListPicsController: ShowImageProtocol, UIViewControllerTransitioningDelegate {
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as? PicCollectionViewCell
        
        cell?.contentView.backgroundColor = UIColor.cyanColor()
        cell?.picV.contentMode = .ScaleAspectFill
        cell?.picV.clipsToBounds = true
        cell?.picV.yy_setImageWithURL(NSURL(string: viewModel.dataSource[indexPath.item]), options: [.ProgressiveBlur, .SetImageWithFadeAnimation])
        return cell!
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? PicCollectionViewCell else { return }
//        showImages(with: viewModel.dataSource, currentIndex: indexPath.item)
        delegate = ModalAnimationDelegate.reset(delegate, imageView: cell.picV)
            showImages(with: viewModel.dataSource, currentIndex: indexPath.item, delegate: delegate)
    }
}

extension ListPicsController {
    
    private func setUpUI() {
        title = "pics"
        collectionView?.backgroundColor = UIColor.whiteColor()
    }
    
    class func loadPicVC() -> UIViewController {
        let vc = ListPicsController(collectionViewLayout: PicsViewModel.layout())
        return UINavigationController(rootViewController: vc)
    }
}