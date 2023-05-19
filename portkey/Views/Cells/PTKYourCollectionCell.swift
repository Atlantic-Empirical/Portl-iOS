//
//  PTKCollectionCell.swift
//  portkey
//
//  Created by Kay Vink on 09/10/15.
//  Copyright © 2015 Airtime Media. All rights reserved.
//

import Foundation

import UIKit

class PTKYourCollectionCell: UICollectionViewCell {
    
    let imageView = PTKImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.image = UIImage(named: "CollectionPlaceholder")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        addSubview(imageView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        imageView.frame = bounds
    }
    
    override func prepareForReuse() {
        imageView.cancelLoading()
    }
}
