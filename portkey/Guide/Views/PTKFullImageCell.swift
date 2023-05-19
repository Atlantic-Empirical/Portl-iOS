//
//  PTKFullImageCell.swift
//  portkey
//
//  Created by Samuel Beek on 16/06/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

import UIKit

class PTKFullImageCell : UICollectionViewCell {
    let imageView = PTKImageView()

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        
        constrain(imageView) { image in
            image.size == image.superview!.size
            image.center == image.superview!.center
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

