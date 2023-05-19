 //
//  PTKGuideController.swift
//  portkey
//
//  Created by Kay Vink on 23/09/15.
//  Copyright © 2015 Airtime Media. All rights reserved.
//

import UIKit

@objc class PTKGuideController: PTKBaseViewController {
    
    // FIXME: crash on updateFeaturedMedia() if no internet connection
    
    enum GuideSection: Int {
        case Featured, Channels, YourCollection
    }
    
    private let horizontalFeaturedIdentifier = "horizontalFeaturedCells"
    private let horizontalCollectionIdentifier = "horizontalCollectionCells"
    private let mediaChannelsIdentifier  = "mediaChannelsIdentifier"
    private let searchResultIdentifier = "searchResult"
    private let searchHeaderIdentifier = "searchHeader"
    private let headerIdentifier       = "headerView"
    
    private var collectionView: UICollectionView!
    private var resultSearchController: UISearchController!
    private let viewModel = PTKGuideViewModel()
    
    private let margin: CGFloat = 20
    
    private let searchBar = UISearchBar()
    private let magnifyingGlassView = UIImageView()
    private let noResultsLabel = UILabel()
    
    internal var presentedChannel: Channel
    
    weak var delegate: PTKGuideControllerDelegate?
    
    private var featuredSoundCloudTracks = [PTKFeaturedMedia]()
    private var featuredYouTubeVideos = [PTKFeaturedMedia]()
    private var featuredSpotifyAlbums = [PTKFeaturedMedia]()
    private var featuredGifs = [PTKFeaturedMedia]()
    private var featuredMediaItems = [PTKFeaturedMedia]()
    
    private let featuredMediaLimit = 4
    
    private var isFetchingSoundCloud = true
    private var isFetchingYouTube = true
    private var isFetchingSpotify = true
    private var isFetchingGiphy = true
    
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
    
    let roomId: String
    
    init(roomId: String){
        self.presentedChannel = Channel.None
        self.roomId = roomId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clearColor()
        view.addSubview(blurView)
        
        constructCollectionView()
        // constructSearchBar()
        setupNavigationController()
        constructNoResultsView()
        
        fetchFeaturedData()
    }
    
    override func viewWillLayoutSubviews() {
        blurView.frame = view.bounds
        collectionView.frame = CGRectMake(0, searchBar.frame.size.height, view.bounds.width, view.bounds.height - searchBar.frame.size.height)
    }
    
    override func viewWillAppear(animated: Bool) {
        PTKEventTracker.track(PTKEventType.MediaGuideOpened)
        navigationController?.navigationBar.tintColor = .whiteColor()
    }
    
    // MARK:  Layout
    func constructCollectionView() {
        
        // MARK: Layout
        let layout = UICollectionViewFlowLayout()
        
        // MARK: Collection View
        collectionView = UICollectionView(frame: CGRectMake(0, 0, view.bounds.width, view.bounds.height - searchBar.frame.size.height), collectionViewLayout: layout)
        collectionView.contentSize = CGSizeMake(collectionView.bounds.width, collectionView.bounds.height - searchBar.frame.size.height)
        collectionView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        collectionView.alwaysBounceVertical = true;
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clearColor()
        collectionView.registerClass(PTKFeaturedScrollCell.self, forCellWithReuseIdentifier: horizontalFeaturedIdentifier)
        collectionView.registerClass(PTKCollectionScrollCell.self, forCellWithReuseIdentifier: horizontalCollectionIdentifier)
        collectionView.registerClass(PTKGuideChannelsCell.self, forCellWithReuseIdentifier: mediaChannelsIdentifier)
        collectionView.registerClass(PTKGuideSearchResultCell.self, forCellWithReuseIdentifier: searchResultIdentifier)
        
        collectionView.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: searchHeaderIdentifier)
        collectionView.registerClass(PTKGuideHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        automaticallyAdjustsScrollViewInsets = false
        collectionView.userInteractionEnabled = true
        collectionView.scrollEnabled = true
        view.addSubview(collectionView)
        
    }
    
    func setupNavigationController() {
        
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.barTintColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName: PTKFont.mediumFontOfSize(18)]
        
        navigationController?.navigationBar.translucent = false
        navigationController?.delegate = self
        
        let cancel = UIBarButtonItem(image: PTKGraphics.xImageWithColor(.whiteColor(), backgroundColor: .clearColor(), size: CGSizeMake(16, 16), lineWidth: 2), style: .Done, target: self, action: "close")
        navigationItem.setLeftBarButtonItem(cancel, animated: true)
    }
    
    func constructSearchBar() {
        
        searchBar.frame = CGRectMake(0, 0, view.bounds.width, 45)
        searchBar.searchBarStyle = .Minimal
        searchBar.placeholder = NSLocalizedString("Search", comment: "0")
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.backgroundColor = .clearColor()
        searchBar.tintColor = .whiteColor()
        searchBar.showsCancelButton = false
        let textFieldInsideSearchBar = searchBar.valueForKey("searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .whiteColor()
        
        view.addSubview(searchBar)
    }
    
    
    func constructNoResultsView() {
        let magnifyingGlass = UIImage(named: "magnifyingGlassBig")
        magnifyingGlassView.image = magnifyingGlass
        magnifyingGlassView.contentMode = .Center
        magnifyingGlassView.hidden = false
        magnifyingGlassView.frame = CGRectMake(view.bounds.size.width - magnifyingGlassView.bounds.width / 2, view.bounds.height - magnifyingGlassView.bounds.height / 2, magnifyingGlass!.size.width, magnifyingGlass!.size.height)
        view.addSubview(magnifyingGlassView)
        
        noResultsLabel.font = PTKFont.regularFontOfSize(17)
        noResultsLabel.textColor = .whiteColor()
        noResultsLabel.hidden = false
        noResultsLabel.text = "No Results Found"
        noResultsLabel.textAlignment = .Center
        noResultsLabel.frame = CGRectMake(0, magnifyingGlassView.frame.origin.y + magnifyingGlassView.frame.height + 10, view.frame.size.width, 25)
        view.addSubview(noResultsLabel)
    }
    
    func updateView() {
        dispatch_async(dispatch_get_main_queue()) {
            self.collectionView.reloadData()
        }
    }
    
    // MARK: Search View
    
    func searchBarTapped() {
        searchBar.hidden = false
        searchBar.becomeFirstResponder()
        
        dispatch_async(dispatch_get_main_queue()) {
            self.updateView()
        }
        
    }
    
    func hideNoResults() {
        magnifyingGlassView.hidden = true
        noResultsLabel.hidden = true
    }
    
    // MARK: Actions
    
    func close() {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func fetchFeaturedData() {
        
        // Fetch SoundCloud
        switch PTKSoundCloudAPI.auth.session {
        case .Some:
            let callback = PTKAPICallback(target: self, selector: "onDidFetchSoundCloudPersonalizedActivity:", userInfo: nil)
            PTKSoundCloudAPI.fetchPersonalizedActivity(0, limit: featuredMediaLimit, callback: callback)
        case .None:
            let callback = PTKAPICallback(target: self, selector: "onDidFetchSoundCloudPublicFeaturedTracks:", userInfo: nil)
            PTKSoundCloudAPI.fetchPublicFeaturedTracks(0, limit: featuredMediaLimit, callback: callback)
        }
        
        // Fetch YouTube
        let youtubecallback = PTKAPICallback(target: self, selector: "onDidFetchYouTubeFeaturedVideos:", userInfo: nil)
        PTKYouTubeAPI.fetchTopVideos(featuredMediaLimit, callback: youtubecallback)
        
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
        
        let giphyCallback = PTKAPICallback(target: self, selector: "onDidFetchGiphyFeaturedGifs:", userInfo: nil)
        PTKGiphyAPI.fetchTopMediaWithOffset(0, limit:Int32(featuredMediaLimit), andCallback: giphyCallback)
    }
    
    func updateFeaturedMedia() {
        let totalCount = featuredSoundCloudTracks.count + featuredSpotifyAlbums.count + featuredYouTubeVideos.count + featuredGifs.count
        
        if !isFetchingSoundCloud && !isFetchingYouTube && !isFetchingSpotify && !isFetchingGiphy && totalCount > 0 {
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
        }
    }
    
    func openPreviewForItem(item: PTKFeaturedMedia) {
        switch item {
        case .SoundCloud(let track):
            let message = PTKSoundCloudMessage(roomId: roomId, body: "", url: track.url, streamURL: track.streamURL, title: track.title, imageUrl: track.imageURL500, username: track.user.username, playCount: track.plays)
            let preview = PTKMessagePreviewViewController(message: message)
            preview.delegate = self
            presentViewController(preview, animated: true, completion: nil)
            
        case .Spotify(let album):
            let message = PTKSpotifyMessage(roomId: roomId, body: "", spotifyObject: album)
            let preview = PTKMessagePreviewViewController(message: message)
            preview.delegate = self
            presentViewController(preview, animated: true, completion: nil)
            
        case .YouTube(let video):
            let message = PTKYoutubeMessage(roomId: roomId, body: "", url: "http://www.youtube.com/watch?v=" + video.videoId, title: video.title, imageUrl: video.fullThumbURL.absoluteString, description: nil)
            let preview = PTKMessagePreviewViewController(message: message)
            preview.delegate = self
            presentViewController(preview, animated: true, completion: nil)
            
        case .Giphy(let giphy):
            let imageInfo = PTKImageInfo()
            imageInfo.imageSize = giphy.imageSize
            imageInfo.imageUrl = giphy.originalURL.absoluteString
            imageInfo.videoUrl = giphy.videoURL.absoluteString
            
            let message = PTKPhotosMessage(roomId: roomId, body: nil, imageInfos: [imageInfo])
            let preview = PTKMessagePreviewViewController(message: message)
            
            preview.delegate = self
            presentViewController(preview, animated: true, completion: nil)
            
        case .InfoMessage(let infoMessage):
            infoMessage.openAction?()
        }
    }
    
    // MARK: - Featured Media callbacks
    
    func onDidFetchSoundCloudPersonalizedActivity(response: PTKAPIResponse){
        if let error = response.error{
            print(error.localizedDescription)
        }
        
        if let json = response.JSON {
            var featuredMedia = [PTKFeaturedMedia]()
            
            let json = JSON(json)
            for item in json["collection"].arrayValue {
                
                switch item["origin"]["kind"].stringValue {
                case "track":
                    if let track = item["origin"] >>> SCTrack.decode {
                        let mediaItem = PTKFeaturedMedia.SoundCloud(track)
                        featuredMedia.append(mediaItem)
                    }
                case "playlist":
                    if let _ = item["origin"] >>> SCPlaylist.decode {
                        
                    }
                case "user":
                    if let _ = item["origin"] >>> SCUser.decode {
                        
                    }
                default:
                    break
                }
            }
            featuredSoundCloudTracks = featuredMedia
        }
        
        isFetchingSoundCloud = false
        updateFeaturedMedia()
    }
    
    func onDidFetchSoundCloudPublicFeaturedTracks(response: PTKAPIResponse){
        
        if let error = response.error{
            print(error.localizedDescription)
        }
        
        if let json = response.JSON {
            var featuredMedia = [PTKFeaturedMedia]()
            
            let json = JSON(json)
            for item in json["tracks"].arrayValue {
                if let track = SCTrack.decode(item){
                    let mediaItem = PTKFeaturedMedia.SoundCloud(track)
                    featuredMedia.append(mediaItem)
                }
            }
            
            featuredSoundCloudTracks = featuredMedia
        }
        
        isFetchingSoundCloud = false
        updateFeaturedMedia()
    }
    
    func onDidFetchYouTubeFeaturedVideos(response: PTKAPIResponse){
        
        if let error = response.error{
            print(error.localizedDescription)
        }
        
        if let json = response.JSON {
            var featuredMedia = [PTKFeaturedMedia]()
            
            let json = JSON(json)
            for item in json["items"].arrayValue {
                let youtubeObject = PTKYoutubeObject(entry: item.dictionaryObject)
                let mediaItem = PTKFeaturedMedia.YouTube(youtubeObject)
                featuredMedia.append(mediaItem)
            }
            
            featuredYouTubeVideos = featuredMedia
        }
        
        isFetchingYouTube = false
        updateFeaturedMedia()
    }
    
    func onDidFetchSpotifyFeaturedAlbums(response: PTKAPIResponse){
        
        if let error = response.error{
            print(error.localizedDescription)
        }
        
        if let json = response.JSON {
            var featuredMedia = [PTKFeaturedMedia]()
            
            let json = JSON(json)
            for item in json["albums"]["items"].arrayValue {
                let album = PTKSpotifyAlbum(JSON: item.dictionaryObject)
                let mediaItem = PTKFeaturedMedia.Spotify(album)
                featuredMedia.append(mediaItem)
            }
            
            featuredSpotifyAlbums = featuredMedia
        }
        
        isFetchingSpotify = false
        updateFeaturedMedia()
    }
    
    func onDidFetchGiphyFeaturedGifs(response: PTKAPIResponse) {
        if let error = response.error{
            print(error.localizedDescription)
        }
        
        if let json = response.JSON {
            var featuredMedia = [PTKFeaturedMedia]()
            
            let gifs = PTKGiphyAPI.mediaObjectsFromResponse(json as! [NSObject : AnyObject])
            
            for item in gifs {
                featuredMedia.append(PTKFeaturedMedia.Giphy(item as! PTKGiphyObject))
            }
            
            featuredGifs = featuredMedia
        }
        
        isFetchingGiphy = false
        updateFeaturedMedia()
    }
    
    // MARK: - Event tracking
    func mediaTypeStringFromPresentedChannel() -> String {
        switch presentedChannel {
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
        switch viewModel.state {
        case .Home:
            return 2
        case .Searching:
            return viewModel.searchData.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch viewModel.state {
        case .Home:
            return 1
        case .Searching:
            return viewModel.searchData[section].1.count
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        switch viewModel.state{
        case .Home:
            switch GuideSection(rawValue: indexPath.section)! {
            case .Featured:
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier(horizontalFeaturedIdentifier, forIndexPath: indexPath) as! PTKFeaturedScrollCell
                cell.configureWithMedia(featuredMediaItems)
                cell.delegate = self
                return cell
            case .YourCollection:
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier(horizontalCollectionIdentifier, forIndexPath: indexPath) as! PTKCollectionScrollCell
                return cell
            case .Channels:
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier(mediaChannelsIdentifier, forIndexPath: indexPath) as! PTKGuideChannelsCell
                cell.roomColor = PTKWeakSharingManager.roomsDataSource().objectWithId(roomId).roomColor
                cell.delegate = self
                return cell
            }
        case .Searching:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(searchResultIdentifier, forIndexPath: indexPath) as! PTKGuideSearchResultCell
            cell.configure(viewModel.searchData[indexPath.section].1[indexPath.row])
            return cell
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        switch viewModel.state{
        case .Home:
            return CGSizeMake(collectionView.bounds.width , 35)
        case .Searching:
            return CGSizeMake(collectionView.bounds.width, 25)
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let reusableView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier, forIndexPath: indexPath) as! PTKGuideHeaderView
        
        if kind == UICollectionElementKindSectionHeader {
            reusableView.hidden = true
            
            switch viewModel.state{
            case .Home:
                switch GuideSection(rawValue: indexPath.section)! {
                case .Featured:
                    reusableView.titleLabel.text = "FEATURED"
                    reusableView.showMoreButton.hidden = true
                    reusableView.hidden = false
                    reusableView.openAction = {
                        print("Open all featured")
                    }
                    
                case .YourCollection:
                    reusableView.titleLabel.text = "RECENTS"
                    reusableView.showMoreButton.hidden = true
                    reusableView.hidden = false
                    reusableView.openAction = {
                        print("Open my collection")
                    }
                    
                case .Channels:
                    reusableView.titleLabel.text = "CHANNELS"
                    reusableView.showMoreButton.hidden = true
                    reusableView.hidden = false
                }
                
            case .Searching:
                reusableView.titleLabel.text = viewModel.searchData[indexPath.section].0
            }
        }else if kind == UICollectionElementKindSectionFooter {
            reusableView.hidden = true
        }
        
        return reusableView
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PTKGuideController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        switch viewModel.state {
        case .Home:
            switch GuideSection(rawValue: indexPath.section)! {
            case .Featured :
                return CGSizeMake(collectionView.bounds.width , collectionView.bounds.height * 0.24)
            case .YourCollection :
                return CGSizeMake(collectionView.bounds.width, collectionView.bounds.height * 0.20)
            case .Channels:
                return CGSizeMake(collectionView.bounds.width, collectionView.bounds.height *  0.5)
            }
        case .Searching:
            return CGSizeMake(collectionView.bounds.width, 90)
            
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSizeMake(collectionView.bounds.width, collectionView.bounds.height * 0.02)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
}


// MARK: - UICollectionViewDelegate
extension PTKGuideController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
        switch viewModel.state {
        case .Home:
            let item = featuredMediaItems[indexPath.row]
            openPreviewForItem(item)
            
        case .Searching:
            print(indexPath.row)
        }
        
        
    }
}

extension PTKGuideController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        //        searchBar.hidden = true
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
}

// MARK: - UIScrollViewDelegate
extension PTKGuideController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
    }
    
}
