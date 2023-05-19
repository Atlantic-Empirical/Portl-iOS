//
//  PTKBradyBunch.swift
//  portkey
//
//  Created by Samuel Beek on 2/10/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

import UIKit

@objc class PTKBradyBunchController : UIViewController {
    
    internal var overlayView: PTKBradyBunchOverlayView?
    internal let roomId : String
    internal var settingsBar : RoomShareShowLinkBar!

    fileprivate var collectionView : UICollectionView!
    fileprivate var collectionViewHeight : CGFloat = 0
    fileprivate var dataSource : PTKRoomPresenceDataSource!
    fileprivate var layout : PTKSquareLayout?
    fileprivate var link : String = ""
    fileprivate var members = [PTKUser]()
    fileprivate var message : PTKMessage?
    fileprivate let reuseIdentifier = String(describing: ImageCell.self)
    fileprivate var room: PTKRoom!
    
    init(roomId: String, message: PTKMessage? = nil) {
        self.roomId = roomId
        super.init(nibName: nil, bundle: nil)
        self.message = message
        
        // Load data in async
        // Note: The overlay is created when the data source is loaded
        dataSource = PTKWeakSharingManager.presenceDataSource(forRoom: roomId)
        dataSource.register(self)
        if dataSource.didFetch || dataSource.didLoadFromCache {
            self.paginatedDataSourceDidLoad(dataSource)
        } else {
            reloadWithPresences([])
            dataSource.reload()
        }
        
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.view.addSubview(collectionView)
        
        self.room = PTKWeakSharingManager.roomsDataSource().object(withId: roomId) as? PTKRoom
        let callback = PTKAPICallback(target: self, selector: #selector(PTKBradyBunchController.onDidFetchLink(_:)), userInfo: nil)
        PTKAPI.link(forRoom: roomId, callback: callback)
        
        settingsBar = RoomShareShowLinkBar(frame: CGRect.zero, roomId: self.roomId)
        settingsBar.delegate = self
        view.addSubview(settingsBar)
    }
    
    internal func reload() {
        dataSource.reload()
    }
    
    internal func updateColor(_ color: UIColor) {
        if let overlayView = overlayView {
            overlayView.topBar.backgroundColor = color
            overlayView.bottomBar.backgroundColor = color
        }

    }
    
    internal func updateRoomName(_ name: String) {
        if let overlayView = overlayView {
            overlayView.titleLabel.text = name
        }
    }
    
    func makeOverlay() {
        
        let image = self.collectionView.fastSnapshot()
        
        overlayView = PTKBradyBunchOverlayView(frame: CGRect(x: 0,y: 0,width: view.bounds.width,height: view.bounds.width), height: collectionViewHeight, image: image, message: message)
        if let overlayView = overlayView {
            overlayView.mediaIconImageView.image = message?.imageForMessage()
            
            guard let room = PTKRoom.getRoomObjectForId(roomId) else {
                return
            }
            self.updateColor(room.roomColor())
            overlayView.titleLabel.text = room.getRoomName()
            overlayView.urlLabel.text = link
            view.insertSubview(overlayView, belowSubview: collectionView)
        }
        
    }
    
    func refreshRoomData(){
        let callback = PTKAPICallback(target: self, selector: #selector(PTKBradyBunchController.onDidFetchLink(_:)), userInfo: nil)
        PTKAPI.link(forRoom: roomId, callback: callback)
    }
    
    func onDidFetchLink(_ response: PTKAPIResponse) {
        
        if response.error == nil {
            if let json = response.json as? NSDictionary, let link = json["link"] as? String {
                self.setRoomLink(link)
            }
        }
    }
    
    func setRoomLink(_ link :String) {
        overlayView?.urlLabel.text = link
        self.link = link
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func imageForSharing() -> UIImage {
        return UIImage.cropToSquare(image: self.view.snapshot())
    }
    
    func urlForSharing() -> URL {
        return URL(string: link)!
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.clipsToBounds = true
        collectionView.frame.size.width = self.view.frame.width
        
        collectionView.contentOffset = CGPoint.zero
        collectionView.frame.size.height = collectionViewHeight
        collectionView.frame.origin.y = (view.frame.width-collectionViewHeight)/2
        if collectionView.bounds.height > 240 && message != nil && collectionView.frame.origin.y <= 50 {
            collectionView.frame.origin.y = 50
        }
        

        view.clipsToBounds = true
        
        constrain(settingsBar) {settings in
            settings.width == settings.superview!.width
            settings.height == 24
            settings.centerX == settings.superview!.centerX
            settings.bottom == settings.superview!.bottom - 4
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateView() {
        DispatchQueue.main.async { [weak self] in
            
            if let controller = self {
                let bradyWidth : CGFloat = (Devices.small) ? 280 : 325
                controller.layout = PTKSquareLayout(items: controller.members.count, width: bradyWidth)

                controller.collectionView.reloadData()
                var height = controller.layout?.heightForCollectionView() ?? 0
                
                // if square is too large (45+ room members, shrink it a little bit)
                let totalBarSize = (controller.message != nil) ? CGFloat(80) : CGFloat(60)
                if height > controller.view.frame.size.width-totalBarSize {
                    height = height - totalBarSize
                }
                if Devices.small { height = height * 0.85 }
                controller.collectionViewHeight = height
                controller.viewDidLayoutSubviews()
                if controller.members.count > 0 {
                    if let overlay = controller.overlayView {
                        overlay.removeFromSuperview()
                    }
                    controller.makeOverlay()
                }

            }
            
        }
    }
    
    func reloadWithPresences(_ presences: [PTKRoomPresence]) {
        // Only show active users
        let newMembers = presences.filter({ user in
            if let member = user.member {
                return member.isActive()
            }
            return false
        }).map( {presence in
            return presence.member.user()
        } )
        
        if let members = newMembers as? [PTKUser] {
            var members = members
            members.append(PTKUser.current())
            self.members =  members
            self.updateView()
        }
        

    }
    
}

extension PTKBradyBunchController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return layout?.sectionsForCollectionView() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return layout?.rowsPerSection(section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageCell
        
        if let index = layout?.itemNumberForIndexPath((indexPath as NSIndexPath).section, row: (indexPath as NSIndexPath).row) {
            if let user = members[safe: index], let userId : String = user.userId() {
                    cell.imageView.setImageWithAvatarForUserId(userId, size: CGSize.zero, grayscale: false, rounded: false)
            }
        }
        return cell
    }
    
    
    @objc(collectionView:layout:insetForSectionAtIndex:) func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    @objc(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:) func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    @objc(collectionView:layout:minimumLineSpacingForSectionAtIndex:) func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
}

extension PTKBradyBunchController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = layout?.widthForItem((indexPath as NSIndexPath).section) ?? 0
        let height = layout?.heightForItem((indexPath as NSIndexPath).section) ?? 0
        return CGSize(width: width, height: height)
    }
}

extension PTKBradyBunchController : RoomShareShowLinkBarDelegate {

    func roomShareSettingsBar(_ roomShareSettingsBar: RoomShareShowLinkBar, shouldShowLink show: Bool) {
        overlayView?.urlLabel.isHidden = show
    }
}

extension PTKBradyBunchController : PTKPaginatedDataSourceDelegate {
    func paginatedDataSourceDidLoad(_ dataSource: PTKPaginatedDataSource) {
        self.dataSource = nil
        
        // Check if the data is valid
        guard let dataSource : PTKRoomPresenceDataSource = dataSource as? PTKRoomPresenceDataSource, let allObjects = dataSource.allObjects() as? [PTKRoomPresence] else {
            return print("ERROR: DataSource is nil or objects aren't of class PTKRoomPresence")
        }
        
        reloadWithPresences(allObjects)
        
    }
    
    func paginatedDataSourceDidFail(toLoad dataSource: PTKPaginatedDataSource!) {
        print("ERROR: Failed to load data")
        // dataSource.reload()
    }
}

class ImageCell : UICollectionViewCell {
    
    var imageView = PTKImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.frame = self.bounds
    }
}
