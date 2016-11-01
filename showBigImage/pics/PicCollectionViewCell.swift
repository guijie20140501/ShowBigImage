//
//  PicCollectionViewCell.swift
//  pics
//
//  Created by macc on 16/10/31.
//  Copyright © 2016年 ZhengGuiJie. All rights reserved.
//

import UIKit

class PicCollectionViewCell: UICollectionViewCell {
    private(set) lazy var picV = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        picV.frame = contentView.bounds
        picV.contentMode = .ScaleAspectFit
        contentView.addSubview(picV)
    }
}


