//
//  OverlayView.swift
//  narcissus
//
//  Created by Samuel Beek on 3/22/16.
//  Copyright © 2016 Airtime. All rights reserved.
//

import UIKit

protocol OverlayViewDelegate {
    func overlayViewShouldUpdate(_ overlayView: OverlayView)
}

class OverlayView : UIView {
    
    internal var joinMeLabel, linkLabel : UILabel!
    fileprivate var roomColor : UIColor! = .orange
    fileprivate var messageLabel : MessageLabel!
    var delegate : OverlayViewDelegate?
    var imageCount = 0 {
        didSet {
            if imageCount == 0 {
                didUpdate()
            }
        }
    }
    
    override init(frame: CGRect) {

        super.init(frame: frame)
        
        // because the overlay view has to be the full resolution of the final image, we multiply it.
        let recordIndicator = UIView(frame: CGRect(x: 12,y: 18,width: 10,height: 10))
        recordIndicator.backgroundColor = UIColor(red:1.0, green:0.333, blue:0.333, alpha:1.0)
        recordIndicator.layer.cornerRadius = 5
        recordIndicator.clipsToBounds = true
        addSubview(recordIndicator)
        
        // add label
        let topLabel = UILabel(frame: CGRect(x: 29,y: 0,width: 84,height: 44))
        topLabel.text = "I'm live on"
        topLabel.textColor = .white
        if #available(iOS 8.2, *) {
            topLabel.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightMedium)
        } else {
            topLabel.font = UIFont.systemFont(ofSize: 17)
        }
        topLabel.backgroundColor = .clear
        topLabel.textAlignment = .left
        addSubview(topLabel)
        
        let airtimeImage = UIImage(named: "airtime-watermark")
        let airtimeLogoView = PTKImageView(image: airtimeImage)
        airtimeLogoView.frame = CGRect(x: 110, y: 15, width: 59, height: 14)
        addSubview(airtimeLogoView)
        
        // add label
        joinMeLabel = UILabel(frame: CGRect(x: 0,y: bounds.height-50,width: bounds.width,height: 30))
        joinMeLabel.attributedText = joinMeString(roomName: "")
        joinMeLabel.backgroundColor = .clear
        joinMeLabel.adjustsFontSizeToFitWidth = true
        joinMeLabel.lineBreakMode = .byTruncatingTail

        addSubview(joinMeLabel)
        
        linkLabel = UILabel(frame: CGRect(x: 0,y: bounds.height-32,width: bounds.width,height: 30))
        linkLabel.attributedText = linkString()
        linkLabel.backgroundColor = .clear
        linkLabel.adjustsFontSizeToFitWidth = true
        linkLabel.lineBreakMode = .byTruncatingTail

        addSubview(linkLabel)
        
        messageLabel = MessageLabel(message: nil, frame: CGRect(x: 12,y: 22, width: bounds.width, height: 30))
        addSubview(messageLabel!)

        
    }

    internal func configure(_ name: String, color: UIColor, message : PTKMessage? = nil, slug: URL? = nil) {
        roomColor = color
        // When typing a new name, generate something fake based on the room name untill the new room name is saved (when the done button is hit)
        let placeHolderUrl = URL(string: "https://air.me/\(name.replacingOccurrences(of: " ", with: ""))")
        linkLabel.attributedText = linkString(slug: slug ?? placeHolderUrl)
        joinMeLabel.attributedText = joinMeString(roomName: name)
        if let message = message {
            messageLabel.configure(message: message)
        }
        
        didUpdate()
    }
    
    func didUpdate() {
        if let delegate = delegate {
            delegate.overlayViewShouldUpdate(self)
        }
    }
    
    internal func addUsers(_ users: [PTKRoomPresence]) {
        
        var users = users.filter({ user in
            if let member = user.member {
                return member.isActive()
            }
            return false
        })
        
        while users.count > 18 {
            users.removeLast()
        }
        
        imageCount = users.count
        
        let width : CGFloat = 40
        let avatarSize = CGSize(width: width, height: width)
        let yPos = bounds.height - (65) - (width/2)
        
        if users.count == 1 {
            let imageView = PTKImageView(frame: CGRect(x: (bounds.width/2) - (width/2), y: yPos , width: width, height: width))
            imageView.delegate = self
            imageView.setImageWithAvatarForUserId(users[0].userId(), size: avatarSize, grayscale: false, rounded: true)
            addSubview(imageView)
        } else if users.count <= 5 {
        
            let padding = CGFloat(60)
            let leftOffset = ((bounds.width - padding*CGFloat(users.count-1))/2) - (width/2)
            
            for (index, user) in users.enumerated() {
                let xValue = leftOffset + padding*CGFloat(index)
                let imageView = PTKImageView(frame: CGRect(x: xValue, y: yPos , width: width, height: width))
                imageView.delegate = self
                imageView.setImageWithAvatarForUserId(user.userId(), size: avatarSize, grayscale: false, rounded: true)
                addSubview(imageView)
            }
        
        } else  {
            let divide =  CGFloat(users.count-1)
            let padding = CGFloat((bounds.width-width)/divide)
            
            
            for (index, user) in users.enumerated() {
                
                let xValue = padding*CGFloat(index)
                
                let imageView = PTKImageView(frame: CGRect(x: xValue, y: yPos , width: width, height: width))
                imageView.delegate = self
                imageView.setImageWithAvatarForUserId(user.userId(), size: avatarSize, grayscale: false, rounded: true)
                addSubview(imageView)
            }
        }
        
    }
    
    func linkString(slug: URL? = nil) -> NSAttributedString {
        guard let slug = slug, let host = slug.host else {
            return NSAttributedString()
        }
        
        let path = slug.path
        let linkStringParagraphStyle = NSMutableParagraphStyle()
        linkStringParagraphStyle.alignment = NSTextAlignment.center
        
        let fullString = "\(host)\(path)"
        let linkString = NSMutableAttributedString(string: fullString)
        let length = linkString.length
        
        let whiteRange = host.characters.count
        
        if #available(iOS 8.2, *) {
            linkString.addAttribute(NSFontAttributeName, value:UIFont.systemFont(ofSize: 17, weight: UIFontWeightHeavy), range:NSMakeRange(0,length))
        } else {
            linkString.addAttribute(NSFontAttributeName, value:UIFont.systemFont(ofSize: 17), range:NSMakeRange(0,length))
        }
        linkString.addAttribute(NSParagraphStyleAttributeName, value:linkStringParagraphStyle, range:NSMakeRange(0,length))
        linkString.addAttribute(NSForegroundColorAttributeName, value:UIColor.white, range:NSMakeRange(0,whiteRange))
        linkString.addAttribute(NSForegroundColorAttributeName, value:roomColor, range:NSMakeRange(whiteRange,length-whiteRange))
        return linkString

    }
    
    func joinMeString(roomName: String) -> NSAttributedString {
        let attributedStringParagraphStyle = NSMutableParagraphStyle()
        attributedStringParagraphStyle.alignment = NSTextAlignment.center
        
        let fullString = "Join me in \(roomName)"
        let attributedString = NSMutableAttributedString(string: fullString)
        let length = attributedString.length

        
        attributedString.addAttribute(NSFontAttributeName, value:UIFont.systemFont(ofSize: 17), range:NSMakeRange(0,11))
        if #available(iOS 8.2, *) {
            attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 17, weight: UIFontWeightBold), range:NSMakeRange(11,length-11))
        } else {
            attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 17), range:NSMakeRange(11,length-11))
        }
        attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyle, range:NSMakeRange(0,length))
        attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor.white, range:NSMakeRange(0,11))
        attributedString.addAttribute(NSForegroundColorAttributeName, value:roomColor, range:NSMakeRange(11,length-11))
        return attributedString
    }
    
    func toggleHideLink() {
        if !linkLabel.isHidden {
            linkLabel.isHidden = true
            joinMeLabel.frame.origin.y = linkLabel.frame.origin.y - 12
        } else {
            linkLabel.isHidden = false
            joinMeLabel.frame.origin.y = bounds.height-50
        }
        didUpdate()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // don't use this method, GPUImage doesn't call it.
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension OverlayView : PTKImageViewDelegate {
    func imageViewDidFinishLoadingImage(_ imageView: PTKImageView!) {
        imageCount = imageCount - 1
    }
    
    func imageView(_ imageView: PTKImageView!, didFailToLoadImageWithError error: Error!) {
        imageCount = imageCount - 1
    }
}
