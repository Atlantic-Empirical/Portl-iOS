 //
//  PTKGuideController.swift
//  portkey
//
//  Created by Kay Vink on 23/09/15.
//  Copyright © 2015 Airtime Media. All rights reserved.
//

import UIKit

@objc class PTKGuideController: PTKBaseViewController {
    
    enum Channel: Int {
        case Google, YouTube, Spotify, iHeart, SoundCloud, Vimeo, Giphy, TED, Vevo, None
    }
    
    enum Source: Int {
        case Media, Photos, Camera, Location
    }

    
    private let reuseIdentifier  = String(PTKGuideChannelCell)
    private var collectionView: UICollectionView!
    private let margin: CGFloat = 15
    private let spacing: CGFloat = 7
    
    private var trayView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
    private var actionBar : ButtonBar!
    private let roomId: String
    
    private var searchBar : UISearchBar!
    private var trayHeight = CGFloat(380)
    
    init(roomId: String){
        self.roomId = roomId
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: "close")
        let closeLayer = UIView(frame: view.bounds)
        closeLayer.addGestureRecognizer(tap)
        view.addSubview(closeLayer)
        
        view.backgroundColor = .clearColor()
        view.addSubview(trayView)
        
        searchBar = UISearchBar()
        searchBar.searchBarStyle = .Minimal
        searchBar.backgroundColor = .clearColor()
        searchBar.addBorder(edges: [UIRectEdge.Bottom], color: UIColor.whiteColor().colorWithAlphaComponent(0.25))
        trayView.addSubview(searchBar)
        
        actionBar = ButtonBar()
        actionBar.locationButton.addTarget(.TouchUpInside, action: {
            self.switchTab(.Location)
        })
        actionBar.photoButton.addTarget(.TouchUpInside, action: {
            self.switchTab(.Photos)
        })
        actionBar.cameraButton.addTarget(.TouchUpInside, action: {
            self.switchTab(.Camera)
        })
        actionBar.mediaButton.addTarget(.TouchUpInside, action: {
            self.switchTab(.Media)
        })
        actionBar.closeButton.addTarget(.TouchUpInside, action: {
            self.close()
        })
        view.addSubview(actionBar)

        configureCollectionView()
        
        setupNavigationController(false)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        PTKEventTracker.track(PTKEventType.MediaGuideOpened)
        navigationController?.navigationBar.tintColor = .whiteColor()
    }
    
    // MARK:  Layout
    func configureCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
    
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.alwaysBounceVertical = true;
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clearColor()
        collectionView.registerClass(PTKGuideChannelCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        automaticallyAdjustsScrollViewInsets = false
        collectionView.userInteractionEnabled = true
        collectionView.scrollEnabled = false
        trayView.addSubview(collectionView)
        
    }
    
    
    func setupNavigationController(show: Bool) {
        
        if show == true {
            
            navigationController?.navigationBar.tintColor = UIColor.whiteColor()
            navigationController?.navigationBar.barTintColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
            navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName: PTKFont.mediumFontOfSize(18)]
            navigationController?.navigationBar.translucent = false
            navigationController?.delegate = self
            
            let cancel = UIBarButtonItem(image: PTKGraphics.xImageWithColor(.whiteColor(), backgroundColor: .clearColor(), size: CGSizeMake(16, 16), lineWidth: 2), style: .Done, target: self, action: "close")
            navigationItem.setLeftBarButtonItem(cancel, animated: true)

        } else {
            navigationController?.navigationBar.translucent = true
            navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
            navigationController?.navigationBar.shadowImage = UIImage()
        }
        
    }
    
    func updateView() {
        dispatch_async(dispatch_get_main_queue()) {
            self.collectionView.reloadData()
        }
    }
    
    // MARK: Actions
    func close() {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func push(controller: UIViewController) {
        
        let navigationcontroller = PTKGuideNavigationController(rootViewController: controller)
        
<<<<<<< HEAD
        navigationcontroller.modalTransitionStyle = .CoverVertical
        navigationcontroller.modalPresentationStyle = .OverFullScreen
        navigationController?.presentViewController(navigationcontroller, animated: true, completion: nil)
=======
        // Fetch Spotify
        PTKSpotifyAPI.validateAndUpdateAccessTokenIfNeededWithCompletion{ hasValidSession, _ in
            if hasValidSession {
                let spotifycallback = PTKAPICallback(target: self, selector: "onDidFetchSpotifyFeaturedAlbums:", userInfo: nil)
                PTKSpotifyAPI.fetchNewReleasesWithCallback(spotifycallback)
            }else {
                self.isFetchingSpotify = false
                self.updateFeaturedMedia()
            }
        }
        
//        let giphyCallback = PTKAPICallback(target: self, selector: "onDidFetchGiphyFeaturedGifs:", userInfo: nil)
//        PTKGiphyAPI.fetchTopMediaWithOffset(0, limit:Int32(featuredMediaLimit), andCallback: giphyCallback)
>>>>>>> develop
    }


    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
<<<<<<< HEAD
        self.trayView.frame.size.width = self.view.frame.size.width
        self.trayView.frame.size.height = trayHeight
        self.trayView.frame.origin = CGPoint(x: 0,y: self.view.frame.size.height-trayHeight)

        constrain(trayView) { tray in
            tray.width == tray.superview!.width
            tray.height == trayHeight
            tray.bottom == tray.superview!.bottom
=======
        if !isFetchingSoundCloud && !isFetchingYouTube && !isFetchingSpotify && totalCount > 0 {
            var featuredMedia = [PTKFeaturedMedia]()
            
            for index in 0..<featuredMediaLimit {
                if index < featuredSoundCloudTracks.count {
                    featuredMedia.append(featuredSoundCloudTracks[index])
                }
                
                if index < featuredSpotifyAlbums.count {
                    featuredMedia.append(featuredSpotifyAlbums[index])
                }
                
                if index < featuredYouTubeVideos.count {
                    featuredMedia.append(featuredYouTubeVideos[index])
                }
                
                if (index < featuredGifs.count) {
                    featuredMedia.append(featuredGifs[index])
                }
            }
            
            if !PTKSpotifyAPI.hasValidSession() {
                var infoMessage = PTKGuideFeaturedInfoMessage(message: "Sign in to Spotify to see featured music", backgroundColor: PTKColorFromHexString("23CF5F"))
                infoMessage.openAction = {
                    let loginVC = PTKSpotifyLoginViewController()
                    loginVC.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
                    loginVC.showCloseButton()
                    loginVC.delegate = self
                    self.navigationController?.presentViewController(loginVC, animated: true, completion: nil)
                }
                let item = PTKFeaturedMedia.InfoMessage(infoMessage)
                featuredMedia.insert(item, atIndex: 2)
            }
            
            self.featuredMediaItems = featuredMedia
            updateView()
>>>>>>> develop
        }
        
        // Keep things aligned to the top
        constrain(collectionView, actionBar, searchBar) { collection, action, search in
            
            search.top == search.superview!.top
            search.width == search.superview!.width
            search.height == 56
            search.left == search.superview!.left
            
            action.height == 70
            action.bottom == action.superview!.bottom - 10
            action.width == action.superview!.width
            action.centerX == action.superview!.centerX

            collection.top == collection.superview!.top + 66
            collection.height == 220
            collection.width == collection.superview!.width
            collection.centerX == collection.superview!.centerX
            
        }
        
        
    }
    
    func switchTab(source: Source) {
        // TODO(SAM): open the camera thing, but communicate with roomstage delegate to make
        // sure that there's permissions and it doesn't conflict with presentation and stuff
        // function you should communicate with is: takePhotoAction iin RoomViewController.mm

        switch source {
        case .Camera:
            showAlert("test", message: "message")
        case .Photos:
            showAlert("photos", message: "photos is selected")
        case .Location:
            showAlert("location", message: "location is selected")
        case .Media:
            break
        }
    }
    
    func openChannel(channel: Channel) {
        
<<<<<<< HEAD
        switch channel {
        case .YouTube:
            let controller = PTKYouTubeTabBarController(roomId: roomId)
            push(controller)
        case .Spotify:
            let controller = PTKSpotifyTabBarController(roomId: roomId)
            push(controller)
        case .SoundCloud:
            let controller = PTKSoundCloudTabBarController(roomId: roomId)
            push(controller)
        case .Google:
            let controller = PTKGoogleTabBarController(roomId: roomId)
            push(controller)
        case .Giphy:
            let controller = PTKGiphyPickerViewController(roomId: roomId)
            push(controller)
        case .iHeart:
            let controller = PTKiHeartPickerViewController(roomID: roomId)
            push(controller)
        case .TED:
            let controller = PTKTEDTabBarController(roomId: roomId)
            push(controller)
        case .Vevo:
            let controller = PTKVevoPickerController(roomId: roomId)
            push(controller)
        case .Vimeo:
            let controller = PTKVimeoTabBarController(roomId: roomId)
            push(controller)

        default:
            UIAlertView(title: "Coming soon", message: "Why don't you have a look at all the other good stuff!", delegate: nil, cancelButtonTitle: "Ok").show()
=======
        if let json = response.JSON {
            var featuredMedia = [PTKFeaturedMedia]()
            
            let json = JSON(json)
            for item in json["results"].arrayValue {
                let youtubeObject = PTKYoutubeObject(entry: item.dictionaryObject)
                let mediaItem = PTKFeaturedMedia.YouTube(youtubeObject)
                featuredMedia.append(mediaItem)
            }
            
            featuredYouTubeVideos = featuredMedia
>>>>>>> develop
        }

    
    }
    
<<<<<<< HEAD

=======
//    func onDidFetchGiphyFeaturedGifs(response: PTKAPIResponse) {
//        if let error = response.error{
//            print(error.localizedDescription)
//        }
//        
//        if let json = response.JSON {
//            var featuredMedia = [PTKFeaturedMedia]()
//            
//            let gifs = PTKGiphyAPI.mediaObjectsFromResponse(json as! [NSObject : AnyObject])
//            
//            for item in gifs {
//                featuredMedia.append(PTKFeaturedMedia.Giphy(item as! PTKGiphyObject))
//            }
//            
//            featuredGifs = featuredMedia
//        }
//        
//        isFetchingGiphy = false
//        updateFeaturedMedia()
//    }
>>>>>>> develop
    
    // MARK: - Event tracking
    func mediaTypeStringForChannel(channel: Channel) -> String {
        switch channel {
        case .Giphy:
            return "Giphy"
        case .Google:
            return "web_search"
        case .iHeart:
            return "iHeart"
        case .SoundCloud:
            return "SoundCloud"
        case .Spotify:
            return "Spotify"
        case .TED:
            return "TED"
        case .Vevo:
            return "Vevo"
        case .Vimeo:
            return "Vimeo"
        case .YouTube:
            return "YouTube"
        default:
            return ""
        }
    }
}

// MARK: - UICollectionViewDatasource
extension PTKGuideController: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // TO DO: it is totally unclear were this is comming from
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PTKGuideChannelCell
        switch Channel(rawValue: indexPath.row)! {
        case .YouTube:
            cell.imageView.image = UIImage(named: "channel-youtube")
            cell.backgroundColor = PTKColorFromHexString("e52d27")
        case .Spotify:
            cell.imageView.image = UIImage(named: "channel-spotify")
            cell.backgroundColor = PTKColorFromHexString("23CF5F")
        case .SoundCloud:
            cell.imageView.image = UIImage(named: "channel-soundcloud")
            cell.backgroundColor = PTKColorFromHexString("FF6600")
        case .Google:
            cell.imageView.image = UIImage(named: "magnifyingGlassBigWhite")
            cell.backgroundColor = PTKColor.blueColor()
        case .Giphy:
            cell.imageView.image = UIImage(named: "channel-giphy")
            cell.backgroundColor = PTKColorFromHexString("474747")
        case .iHeart:
            cell.imageView.image = UIImage(named: "channel-iheart")
            cell.backgroundColor = .whiteColor()
        case .TED:
            cell.imageView.image = UIImage(named: "channel-ted")
            cell.backgroundColor = .whiteColor()
        case .Vevo:
            cell.imageView.image = UIImage(named: "channel-vevo")
            cell.backgroundColor = PTKColorFromHexString("F31793")
        case .Vimeo:
            cell.imageView.image = UIImage(named: "channel-vimeo")
            cell.backgroundColor = PTKColorFromHexString("4BBCFC")
        default:
            cell.imageView.image = nil;
            cell.backgroundColor = UIColor.blackColor()
        }
        return cell
    }
    
 
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeZero
    }
    
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        return UICollectionReusableView()
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PTKGuideController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        // the compiler can't handle it if these equations are in one line.
        let unflooredwidth = (collectionView.bounds.width - (2 * margin) - (2 * spacing)) / 3
        let width = floor(unflooredwidth)
        
        return CGSizeMake(width, 63)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSizeZero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, margin, 0, margin)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return spacing
    }
    
}
 


// MARK: - UICollectionViewDelegate
extension PTKGuideController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let channel = Channel(rawValue: indexPath.row) {
            openChannel(channel)
        }
        
    }
}

// MARK: - UIScrollViewDelegate
extension PTKGuideController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
    }
    
}
 
 
