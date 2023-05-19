////
////  PTKGiphyPickerViewController.m
////  portkey
////
////  Created by Rodrigo Sieiro on 31/8/15.
////  Copyright (c) 2015 Airtime Media. All rights reserved.
////
//
//#import "PTKGiphyPickerViewController.h"
//#import "PTKMessageSender.h"
//#import "PTKPhotosMessage.h"
//#import "PTKGiphyCollectionViewCell.h"
//#import "PTKMessagePreviewViewController.h"
//#import "PTKMessagePreviewTransitionDelegate.h"
//#import "portkey-Swift.h"
//
//
//const int kGiphyPageLimit = 30;
//const CGFloat kGiphyCellMargin = 10.0f;
//const CGFloat kPoweredByGiphyImageViewWidth = 100.0f;
//
//@interface PTKGiphySearchBar : UISearchBar
//@end
//
//@implementation PTKGiphySearchBar
//@end
//
//@interface PTKGiphySearchingCollectionViewCell : UICollectionViewCell {
//    UIActivityIndicatorView *_spinner;
//}
//
//@end
//
//@implementation PTKGiphySearchingCollectionViewCell
//
//- (id)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
//        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//        self.backgroundColor = PTKColorFromHexString(@"0E0E0E");
//
//        [_spinner startAnimating];
//        [self.contentView addSubview:_spinner];
//    }
//    return self;
//}
//
//- (void)layoutSubviews {
//    [super layoutSubviews];
//    _spinner.frame = (CGRect) {
//        .origin.x = (self.frame.size.width - 44.0f) / 2.0f,
//        .origin.y = (self.frame.size.height - 44.0f) / 2.0f,
//        .size.width = 44.0f,
//        .size.height = 44.0f
//    };
//}
//
//- (void)prepareForReuse {
//    [super prepareForReuse];
//    self.alpha = 0.8f;
//    [_spinner startAnimating];
//}
//
//@end
//
//@interface PTKGiphyPickerViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PTKMessagePreviewViewControllerDelegate, UISearchBarDelegate>
//{
//    UICollectionView *_collectionView;
//    UICollectionView *_resultsCollectionView;
//    UIImageView *_poweredByGiphyImageView;
//    UIView *_noSearchResultsView;
//    PTKGiphySearchBar *_searchBar;
//
//    NSString *_roomId;
//    NSArray *_recentGifs;
//    NSMutableArray *_topMedia, *_searchResults;
//
//    NSURLConnection *_searchConnection;
//    NSURLConnection *_searchDurationConnection;
//    NSMutableData *_searchData;
//    NSURLConnection *_topMediaConnection;
//    NSMutableData *_topMediaData;
//
//    BOOL _shouldContinueFetching;
//    __block CGFloat _customDelay;
//    int _currentPageOffset;
//}
//
//@end
//
//@implementation PTKGiphyPickerViewController
//
//- (instancetype)initWithRoomId:(NSString *)roomId {
//    self = [super init];
//
//    if (self) {
//        _roomId = roomId;
//    }
//
//    return self;
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    self.view.backgroundColor = PTKColorFromHexString(@"0E0E0E");
//
//    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
//    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    _collectionView.backgroundColor = [UIColor clearColor];
//    _collectionView.alwaysBounceVertical = YES;
//    _collectionView.allowsMultipleSelection = NO;
//    _collectionView.bounces = YES;
//    _collectionView.dataSource = self;
//    _collectionView.delegate = self;
//    [_collectionView registerClass:[PTKGiphyCollectionViewCell class] forCellWithReuseIdentifier:@"Giphy"];
//    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
//    [_collectionView registerClass:[PTKGiphySearchingCollectionViewCell class] forCellWithReuseIdentifier:@"Searching"];
//    _collectionView.frame = (CGRect) {
//        .origin.x = 0.0f,
//        .origin.y = 45.0f,
//        .size.width = self.view.bounds.size.width,
//        .size.height = self.view.bounds.size.height - 45.0f
//    };
//    [self.view addSubview:_collectionView];
//
//    UICollectionViewFlowLayout *resultsFlowLayout = [[UICollectionViewFlowLayout alloc] init];
//    _resultsCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:resultsFlowLayout];
//    _resultsCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    _resultsCollectionView.backgroundColor = [UIColor clearColor];
//    _resultsCollectionView.alwaysBounceVertical = YES;
//    _resultsCollectionView.allowsMultipleSelection = NO;
//    _resultsCollectionView.bounces = YES;
//    _resultsCollectionView.dataSource = self;
//    _resultsCollectionView.delegate = self;
//    [_resultsCollectionView registerClass:[PTKGiphyCollectionViewCell class] forCellWithReuseIdentifier:@"Giphy"];
//    [_resultsCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
//    [_resultsCollectionView registerClass:[PTKGiphySearchingCollectionViewCell class] forCellWithReuseIdentifier:@"Searching"];
//    _resultsCollectionView.frame = (CGRect) {
//        .origin.x = 0.0f,
//        .origin.y = 45.0f,
//        .size.width = self.view.bounds.size.width,
//        .size.height = self.view.bounds.size.height - 45.0f
//    };
//    _resultsCollectionView.alpha = 0;
//    [self.view addSubview:_resultsCollectionView];
//
//    [[UITextField appearanceWhenContainedIn:[PTKGiphySearchBar class], nil] setTintColor:[PTKColor redColor]];
//    [[UITextField appearanceWhenContainedIn:[PTKGiphySearchBar class], nil] setDefaultTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
//                                                                                                       NSFontAttributeName:[PTKFont regularFontOfSize:17.0f]}];
//    [[UIBarButtonItem appearanceWhenContainedIn:[PTKGiphySearchBar class], nil] setTitleTextAttributes:@{NSForegroundColorAttributeName:[PTKColor redColor],
//                                                                                                         NSFontAttributeName:[PTKFont regularFontOfSize:17.0f]} forState:UIControlStateNormal];
//
//    _searchBar = [[PTKGiphySearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44.0f)];
//    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
//    _searchBar.backgroundColor = [UIColor clearColor];
//    _searchBar.placeholder = NSLocalizedString(@"Search Giphy", 0);
//    _searchBar.delegate = self;
//    [self.view addSubview:_searchBar];
//
//    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(25.0f, 44.0f, self.view.bounds.size.width - 50.0f, 1.0f)];
//    separator.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.2f];
//    [self.view addSubview:separator];
//
//    _poweredByGiphyImageView = [[UIImageView alloc] initWithImage:[PTKGraphics imageWithImage:[UIImage imageNamed:@"powered_by_giphy"] andClearPadding:UIEdgeInsetsMake(20.0f, 0.0f, 20.0f, 0.0f)]];
//    _poweredByGiphyImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
//    _poweredByGiphyImageView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
//    _poweredByGiphyImageView.layer.cornerRadius = 2.0f;
//    _poweredByGiphyImageView.layer.masksToBounds = YES;
//    _poweredByGiphyImageView.contentMode = UIViewContentModeScaleAspectFit;
//    CGFloat poweredByGiphyImageViewHeight = _poweredByGiphyImageView.image.size.height * kPoweredByGiphyImageViewWidth / _poweredByGiphyImageView.image.size.width;
//    _poweredByGiphyImageView.frame = (CGRect) {
//        .origin.x = self.view.width - kPoweredByGiphyImageViewWidth - 10.0f,
//        .origin.y = self.view.height - poweredByGiphyImageViewHeight - 10.0f,
//        .size.width = kPoweredByGiphyImageViewWidth,
//        .size.height = poweredByGiphyImageViewHeight
//    };
//    [self.view addSubview:_poweredByGiphyImageView];
//
//    _noSearchResultsView = [[UIView alloc] init];
//    _noSearchResultsView.frame = _collectionView.frame;
//    [self.view addSubview:_noSearchResultsView];
//    
//    
//    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 18)];
//    logoView.contentMode = UIViewContentModeScaleAspectFit;
//    [logoView setImage:[UIImage imageNamed:@"GiphyHorizontal"]];
//    [self.navigationItem setTitleView:logoView];
//
//    UIImage *magnifyingGlass = [UIImage imageNamed:@"magnifyingGlassBig"];
//    UIImageView *noResultsImageView = [[UIImageView alloc] initWithImage:magnifyingGlass];
//    noResultsImageView.contentMode = UIViewContentModeCenter;
//    noResultsImageView.frame = (CGRect) {
//        .origin.x = (_noSearchResultsView.bounds.size.width - magnifyingGlass.size.width) / 2.0f,
//        .origin.y = 20.0f,
//        .size = magnifyingGlass.size
//    };
//    [_noSearchResultsView addSubview:noResultsImageView];
//
//    UILabel *noResultsLabel = [[UILabel alloc] init];
//    noResultsLabel.font = [PTKFont regularFontOfSize:17.0f];
//    noResultsLabel.textColor = [UIColor whiteColor];
//    noResultsLabel.text = NSLocalizedString(@"No Results Found", 0);
//    noResultsLabel.textAlignment = NSTextAlignmentCenter;
//    noResultsLabel.frame = (CGRect) {
//        .origin.x = 0.0f,
//        .origin.y = noResultsImageView.frame.origin.y + noResultsImageView.frame.size.height + 10.0f,
//        .size.width = _noSearchResultsView.frame.size.width,
//        .size.height = 25.0f
//    };
//    [_noSearchResultsView addSubview:noResultsLabel];
//
//    _noSearchResultsView.alpha = 0.0f;
//    _noSearchResultsView.hidden = true;
//
//    _topMedia = nil;
//    _searchResults = nil;
//    _shouldContinueFetching = true;
//
//    [self requestTopMedia];
//
//    [_collectionView reloadData];
//    [_resultsCollectionView reloadData];
//    _recentGifs = [self recentGifs];
//}
//
//#pragma mark - Action methods
//
//- (void)postGifWithGiphyObject:(PTKGiphyObject *)giphyObject {
//    if (giphyObject.originalURL == nil) return;
//
//    PTKImageInfo *imageInfo = [[PTKImageInfo alloc] init];
//    imageInfo.imageSize = giphyObject.imageSize;
//    imageInfo.imageUrl = giphyObject.originalURL.absoluteString;
//    imageInfo.videoUrl = giphyObject.videoURL.absoluteString;
//
//    PTKPhotosMessage *message = [PTKPhotosMessage messageWithRoomId:_roomId body:nil imageInfos:@[imageInfo]];
//    PTKMessagePreviewViewController *viewController = [[PTKMessagePreviewViewController alloc] initWithMessage:message andType:@"Giphy"];
//    viewController.delegate = self;
//
//    [PTKEventTracker track:PTKEventTypeMediaGuideMediaPreviewed withProperties:@{@"type":@"Giphy"}];
//    
//    [self presentViewController:viewController animated:YES completion:nil];
//}
//
//#pragma mark - Data conversion methods
//
//- (NSMutableArray *)mediaObjectsFromResponse:(NSDictionary *)responseDictionary {
//    NSMutableArray *mediaObjects = [[NSMutableArray alloc] initWithCapacity:kGiphyPageLimit];
//    NSArray *entries = nil;
//    entries = responseDictionary[@"data"];
//
//    for (NSDictionary *entryDictionary in entries) {
//        PTKGiphyObject *giphyObject = [[PTKGiphyObject alloc] initWithJson:entryDictionary];
//        if (giphyObject) {
//            [mediaObjects addObject:giphyObject];
//        }
//    }
//    return mediaObjects;
//}
//
//#pragma mark - Top Media methods
//
//- (void)requestTopMedia {
//    if (_topMediaConnection != nil) {
//        [_topMediaConnection cancel];
//        _topMediaConnection = nil;
//    }
//
//    _shouldContinueFetching = true;
//    _topMedia = [NSMutableArray array];
//
//    NSURLRequest *topMediaRequest = nil;
//    NSString *gifsUrlString = [NSString stringWithFormat:@"http://api.giphy.com/v1/gifs/trending?rating=pg&api_key=%@&limit=%d", kGiphyAPIKey, kGiphyPageLimit];
//    topMediaRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:gifsUrlString]
//                                       cachePolicy:NSURLRequestReturnCacheDataElseLoad
//                                   timeoutInterval:30.0f];
//
//    if (topMediaRequest != nil) {
//        _topMediaConnection = [[NSURLConnection alloc] initWithRequest:topMediaRequest delegate:self];
//    }
//}
//
//- (void)fetchMoreTopMedia {
//    _currentPageOffset += kGiphyPageLimit;
//
//    if (_topMediaConnection != nil) {
//        [_topMediaConnection cancel];
//        _topMediaConnection = nil;
//    }
//
//    NSURLRequest *topMediaRequest = nil;
//    NSString *gifsUrlString = [NSString stringWithFormat:@"http://api.giphy.com/v1/gifs/trending?rating=pg&api_key=%@&limit=%d&offset=%d", kGiphyAPIKey, kGiphyPageLimit, _currentPageOffset];
//    topMediaRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:gifsUrlString]
//                                       cachePolicy:NSURLRequestReturnCacheDataElseLoad
//                                   timeoutInterval:30.0f];
//
//    if (topMediaRequest != nil) {
//        _topMediaConnection = [[NSURLConnection alloc] initWithRequest:topMediaRequest delegate:self];
//    }
//}
//
//- (void)fetchMoreSearchResults {
//    _currentPageOffset += kGiphyPageLimit;
//
//    [_searchConnection cancel];
//    [_searchDurationConnection cancel];
//    _searchConnection = nil;
//    _searchDurationConnection = nil;
//    NSString *searchString = [_searchBar.text stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
//    NSString *searchUrlString = nil;
//    searchUrlString = [NSString stringWithFormat:@"http://api.giphy.com/v1/gifs/search?rating=pg&q=%@&api_key=%@&limit=%d&offset=%d", searchString, kGiphyAPIKey, kGiphyPageLimit, _currentPageOffset];
//
//    NSURLRequest *searchRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:searchUrlString]
//                                                   cachePolicy:NSURLRequestReturnCacheDataElseLoad
//                                               timeoutInterval:30.0f];
//    _searchConnection = [[NSURLConnection alloc] initWithRequest:searchRequest delegate:self];
//}
//
//#pragma mark - Recent videos methods
//
//- (NSArray *)recentGifs {
//    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
//    NSArray *entries = [standardUserDefaults arrayForKey:@"recentlyPostedGiphyGifs"];
//    NSMutableArray *giphyObjects = [[NSMutableArray alloc] initWithCapacity:kGiphyPageLimit];
//    for (NSDictionary *entryDictionary in entries) {
//        PTKGiphyObject *giphyObject = [[PTKGiphyObject alloc] initWithJson:entryDictionary];
//        if (giphyObject) {
//            [giphyObjects addObject:giphyObject];
//        }
//    }
//
//    NSArray *trimmedRecentGifs = [giphyObjects subarrayWithRange:NSMakeRange(0, MIN(giphyObjects.count, 4))];
//    return trimmedRecentGifs;
//}
//
//#pragma mark - UISearchResultsUpdating
//
//- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
//    [_searchConnection cancel];
//    [_searchDurationConnection cancel];
//    _searchConnection = nil;
//    _searchDurationConnection = nil;
//    _searchResults = nil;
//    NSString *searchString = [searchController.searchBar.text stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
//    NSString *searchUrlString = nil;
//    searchUrlString = [NSString stringWithFormat:@"http://api.giphy.com/v1/gifs/search?rating=pg&q=%@&api_key=%@", searchString, kGiphyAPIKey];
//
//    NSURLRequest *searchRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:searchUrlString]
//                                                   cachePolicy:NSURLRequestReturnCacheDataElseLoad
//                                               timeoutInterval:30.0f];
//    _searchConnection = [[NSURLConnection alloc] initWithRequest:searchRequest delegate:self];
//}
//
//#pragma mark - NSURLConnectionDelegate methods
//
//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
//    if (connection == _searchConnection || connection == _searchDurationConnection) {
//        _searchData = [[NSMutableData alloc] init];
//    }
//    else if (connection == _topMediaConnection) {
//        _topMediaData = [[NSMutableData alloc] init];
//    }
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
//    if (connection == _searchConnection || connection == _searchDurationConnection) {
//        [_searchData appendData:data];
//    }
//    else if (connection == _topMediaConnection) {
//        [_topMediaData appendData:data];
//    }
//}
//
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
//    if (connection == _searchConnection) {
//        NSDictionary *searchResults = [NSJSONSerialization JSONObjectWithData:_searchData
//                                                                      options:0
//                                                                        error:NULL];
//
//        NSMutableArray *newSearchResults = [self mediaObjectsFromResponse:searchResults];
//        if (newSearchResults.count < kGiphyPageLimit) {
//            _shouldContinueFetching = false;
//        }
//
//        for (PTKGiphyObject *giphyObject in _topMedia) {
//            int newSearchCount = newSearchResults.count > 0 ? (int)(newSearchResults.count-1) : -1;
//            for (int i=newSearchCount; i>=0; i--) {
//                PTKGiphyObject *newGiphyObject = [newSearchResults objectAtIndex:i];
//                if ([newGiphyObject.gifId isEqualToString:giphyObject.gifId]) {
//                    [newSearchResults removeObject:newGiphyObject];
//                }
//            }
//        }
//
//        [_searchResults addObjectsFromArray:newSearchResults];
//        [_resultsCollectionView reloadData];
//
//        [_searchConnection cancel];
//        _searchConnection = nil;
//
//        if ((!_searchResults || _searchResults.count == 0) && !EMPTY_STR(_searchBar.text)) {
//            _noSearchResultsView.hidden = false;
//            [UIView animateWithDuration:0.3 animations:^(){
//                _noSearchResultsView.alpha = 1.0f;
//            }];
//        }
//        else if (!_noSearchResultsView.hidden) {
//            [UIView animateWithDuration:0.3 animations:^(){
//                _noSearchResultsView.alpha = 0.0f;
//            }
//                             completion:^(BOOL finished){
//                                 _noSearchResultsView.hidden = true;
//                             }];
//        }
//    }
//    else if (connection == _searchDurationConnection) {
//        [_searchDurationConnection cancel];
//        _searchDurationConnection = nil;
//    }
//    else if (connection == _topMediaConnection) {
//        NSDictionary *topDictionary = [NSJSONSerialization JSONObjectWithData:_topMediaData options:0 error:NULL];
//
//        NSMutableArray *newTopMedia = [self mediaObjectsFromResponse:topDictionary];
//
//        if (newTopMedia.count < kGiphyPageLimit) {
//            _shouldContinueFetching = false;
//        }
//
//        for (PTKGiphyObject *giphyObject in _topMedia) {
//            int newTopCount = newTopMedia.count > 0 ? (int)(newTopMedia.count-1) : -1;
//            for (int i=newTopCount; i>=0; i--) {
//                PTKGiphyObject *newGiphyObject = [newTopMedia objectAtIndex:i];
//                if ([newGiphyObject.gifId isEqualToString:giphyObject.gifId]) {
//                    [newTopMedia removeObject:newGiphyObject];
//                }
//            }
//        }
//
//        [_topMedia addObjectsFromArray:newTopMedia];
//        [_collectionView reloadData];
//
//        [_topMediaConnection cancel];
//        _topMediaConnection = nil;
//    }
//}
//
//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
//    // Check the error
//}
//
//#pragma mark - UICollectionViewDataSource/UICollectionViewDelegate
//
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    if (collectionView == _collectionView) {
//        NSInteger sections = 0;
//        sections += (_recentGifs.count > 0);
//        sections +=1;
//        return sections;
//    }
//    else {
//        return 1;
//    }
//}
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    if (collectionView == _collectionView) {
//        if (section == 0 && _recentGifs.count) {
//            return _recentGifs.count;
//        }
//        else if (_topMedia) {
//            if (_shouldContinueFetching) {
//                return _topMedia.count % 2 == 0 ? _topMedia.count + 2 : _topMedia.count + 1;
//            }
//            else {
//                return _topMedia.count;
//            }
//        }
//        else {
//            return 1;
//        }
//    }
//    else if (_resultsCollectionView == collectionView && _searchResults.count > 0) {
//        return  _shouldContinueFetching ? _searchResults.count + 2 : _searchResults.count;
//    }
//    else {
//        return 0;
//    }
//}
//
//- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if ([cell isKindOfClass:[PTKGiphyCollectionViewCell class]]) {
//        PTKGiphyCollectionViewCell* cellP = (PTKGiphyCollectionViewCell*)cell;
//        if (!cellP.availableForAnimation) {
//            _customDelay = 0;
//        }
//    }
//    
//    cell.contentView.frame = CGRectMake(cell.contentView.frame.origin.x, cell.contentView.frame.origin.y-100, cell.contentView.width, cell.contentView.height);
//    
//    [UIView animateWithDuration:0.3 delay:_customDelay options:UIViewAnimationOptionAllowUserInteraction animations:^{
//        cell.contentView.frame = CGRectMake(cell.contentView.frame.origin.x, cell.contentView.frame.origin.y+100, cell.contentView.width, cell.contentView.height);
//        cell.contentView.alpha = 1;
//        _customDelay += 0.04;
//    } completion:nil];
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (_shouldContinueFetching) {
//        if ((collectionView == _collectionView && indexPath.item >= _topMedia.count) ||
//            (collectionView == _resultsCollectionView && indexPath.item >= _searchResults.count)) {
//            PTKGiphySearchingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Searching" forIndexPath:indexPath];
//            return cell;
//        }
//        if (collectionView == _collectionView && indexPath.row >= _topMedia.count - 12 && _topMediaConnection == nil) {
//            [self fetchMoreTopMedia];
//        }
//        else if (collectionView == _resultsCollectionView && indexPath.row >= _searchResults.count - 12 && _searchConnection == nil) {
//            [self fetchMoreSearchResults];
//        }
//    }
//
//    PTKGiphyCollectionViewCell *cell = (PTKGiphyCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Giphy" forIndexPath:indexPath];
//
//    if (cell == nil) {
//        cell = [[PTKGiphyCollectionViewCell alloc] init];
//    }
//
//    if (collectionView == _collectionView) {
//        if (indexPath.section == 0 && _recentGifs.count) {
//            cell.giphyObject = [_recentGifs objectAtIndex:indexPath.row];
//        }
//        else if (_topMedia && indexPath.row < _topMedia.count) {
//            cell.giphyObject = [_topMedia objectAtIndex:indexPath.row];
//        }
//        else {
//            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
//            return cell;
//        }
//    }
//    else if (_searchResults && indexPath.row < _searchResults.count) {
//        cell.giphyObject = [_searchResults objectAtIndex:indexPath.row];
//    }
//
//    cell.contentView.alpha = 0.5;
//    
//    return cell;
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
//  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    CGFloat width = floorcg((collectionView.width - (kGiphyCellMargin * 2.0f) - (kGiphyCellMargin*1.5 * 2.0f)) / 2.0f);
//    CGFloat height = floorcg(width * 9.0f / 16.0f);
//    return CGSizeMake(width,
//                      height);
//}
//
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
//        insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(kGiphyCellMargin, kGiphyCellMargin*1.5, kGiphyCellMargin, kGiphyCellMargin*1.5);
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return kGiphyCellMargin;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return kGiphyCellMargin;
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([_searchBar isFirstResponder] && EMPTY_STR(_searchBar.text)) {
//        [_searchBar resignFirstResponder];
//        return;
//    }
//
//    NSObject *selectedObject = nil;
//    if (collectionView == _collectionView) {
//        if (indexPath.section == 0 && _recentGifs.count) {
//            selectedObject = [_recentGifs objectAtIndex:indexPath.row];
//        }
//        else if (_topMedia && indexPath.row < _topMedia.count) {
//            selectedObject = [_topMedia objectAtIndex:indexPath.row];
//        } else {
//            return;
//        }
//    }
//    else if (_searchResults) {
//        selectedObject = [_searchResults objectAtIndex:indexPath.row];
//    }
//
//    if ([selectedObject isKindOfClass:[PTKGiphyObject class]]) {
//        PTKGiphyObject *giphyObject = (PTKGiphyObject *)selectedObject;
//        if (!giphyObject.gifId.length) {
//            return;
//        }
//
//        [self postGifWithGiphyObject:giphyObject];
//    }
//}
//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    
//    [_searchBar resignFirstResponder];
//}
//
//
//#pragma mark - UISearchBarDelegate methods
//
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
//    [searchBar setShowsCancelButton:YES animated:YES];
//}
//
//- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
//    [searchBar setShowsCancelButton:NO animated:YES];
//    return YES;
//}
//
//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
//    searchBar.text = nil;
//    [searchBar resignFirstResponder];
//    [self searchBar:searchBar textDidChange:@""];
//}
//
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//    if (EMPTY_STR(searchText)) {
//        _collectionView.alpha = 1.0f;
//        _resultsCollectionView.alpha = 0;
//        _noSearchResultsView.alpha = 0;
//        _noSearchResultsView.hidden = YES;
//        _currentPageOffset = (int)_topMedia.count;
//        _shouldContinueFetching = true;
//    } else {
//        _collectionView.alpha = 0;
//        _resultsCollectionView.alpha = 1.0f;
//        _currentPageOffset = (int)_searchResults.count;
//        _shouldContinueFetching = true;
//
//        _shouldContinueFetching = true;
//        _currentPageOffset = 0;
//        [_searchConnection cancel];
//        [_searchDurationConnection cancel];
//        _searchConnection = nil;
//        _searchDurationConnection = nil;
//        _searchResults = [NSMutableArray array];
//        [_resultsCollectionView setContentOffset:CGPointZero animated:NO];
//        NSString *searchString = [searchText stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
//        NSString *searchUrlString = nil;
//        searchUrlString = [NSString stringWithFormat:@"http://api.giphy.com/v1/gifs/search?rating=pg&q=%@&api_key=%@&limit=%d", searchString, kGiphyAPIKey, kGiphyPageLimit];
//
//        NSURLRequest *searchRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:searchUrlString]
//                                                       cachePolicy:NSURLRequestReturnCacheDataElseLoad
//                                                   timeoutInterval:30.0f];
//        _searchConnection = [[NSURLConnection alloc] initWithRequest:searchRequest delegate:self];
//    }
//}
//
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
//    
//    [searchBar resignFirstResponder];
//}
//
//#pragma mark - PTKMessagePreviewViewControllerDelegate
//
//- (void)messagePreview:(PTKMessagePreviewViewController *)messagePreview dismissWithSuccess:(BOOL)success {
//    if (success) {
//        if ([self.navigationController.transitioningDelegate isKindOfClass:[PTKMessagePreviewTransitionDelegate class]]) {
//            PTKMessagePreviewTransitionDelegate *messageTransitionDelegate = (PTKMessagePreviewTransitionDelegate *)self.navigationController.transitioningDelegate;
//            [messageTransitionDelegate setFromFrame:[messagePreview messageViewFromFrame]];
//            [messageTransitionDelegate setToOrigin:CGPointMake(kMessagePadding.left, self.presentingViewController.view.frame.size.height - messagePreview.messageView.frame.size.height - messageTransitionDelegate.screenBottomPadding)];
//            [messageTransitionDelegate setMessageView:messagePreview.messageView];
//        }
//        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//    } else {
//        [messagePreview dismissViewControllerAnimated:YES completion:nil];
//    }
//}
//
//@end
