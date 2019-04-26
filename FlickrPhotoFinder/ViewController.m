//
//  ViewController.m
//  FlickrPhotoFinder
//
//  Created by Lomtev on 19.04.2019.
//  Copyright © 2019 Александр Ломтев. All rights reserved.
//

#import "ViewController.h"
#import "NetworkService.h"
#import "ImageEditView.h"
#import "PhotoCollectionViewCell.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, NetworkServiceOutputProtocol, UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ImageEditView *imageEditView;

@property (nonatomic, strong) NetworkService *networkService;

@property (nonatomic, strong) NSArray<Photo *> *imageData;

@property (nonatomic, strong) NSString *lastSearchText;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.imageUrls = nil;
    
    [self createUI];
}

- (void)createUI
{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 5, CGRectGetWidth(self.view.bounds), 50)];
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
    
    UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionViewLayout.itemSize = CGSizeMake(180, 180);
    collectionViewLayout.minimumInteritemSpacing = 10;

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchBar.frame) + 5, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.searchBar.frame)) collectionViewLayout: collectionViewLayout];
    self.collectionView.backgroundColor = UIColor.blueColor;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    [self.view addSubview:self.collectionView];
}

- (void)createMenuView
{
    
}

- (void)loadPicWithSearchString:(NSString *) string
{
    self.networkService = [NetworkService new];
    self.networkService.output = self;
    [self.networkService configureUrlSessionWithParams:nil];
    [self.networkService findFlickrPhotoWithSearchString:string];
}

# pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageData == nil ? 0 : self.imageData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.photoObject = self.imageData[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.imageEditView = [ImageEditView createUIWithParentFrame:self.view.frame
                                                             andImageData:self.imageData[indexPath.row]];
    [self.imageEditView.button addTarget:self action:@selector(closeImageEditView:)
                   forControlEvents:UIControlEventTouchUpInside];
    [self.imageEditView.filterSlider addTarget:self action:@selector(sliderValueChange:)
                   forControlEvents:UIControlEventValueChanged];
    
    
    [self.view addSubview:self.imageEditView];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 1.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromBottom;
    [self.view.layer addAnimation:transition forKey:kCATransition];
}

#pragma mark - NetworkServiceOutput

- (void)loadingIsDoneWithDataRecieved:(NSArray *)dataRecieved
{
    self.imageData = dataRecieved;
    [self.collectionView reloadData];
}


#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchText = searchBar.text;
    if(searchText.length > 3)
    {
        if(![self.lastSearchText isEqualToString: searchText])
        {
            self.lastSearchText = searchText;
            [self loadPicWithSearchString: searchText];
        }
    }
}

- (void)closeImageEditView:(ImageEditView *)view
{
    if(view != nil)
    {
        [view.superview removeFromSuperview];
        
        CATransition *transition = [CATransition animation];
        transition.duration = 1.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromTop;
        [self.view.layer addAnimation:transition forKey:kCATransition];
    }
}

- (void)sliderValueChange:(UISlider *)slider
{
    CIImage *beginImage = [CIImage imageWithData:self.imageEditView.photo.photoData];

    CIContext *context = [CIContext contextWithOptions:nil];
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"
                                  keysAndValues: kCIInputImageKey, beginImage,
                        @"inputIntensity", [NSNumber numberWithDouble:slider.value], nil];

    CIImage *outputImage = [filter outputImage];

    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImage = [UIImage imageWithCGImage:cgimg];
    [self.imageEditView updateImage:newImage];
    CGImageRelease(cgimg);
    
}

@end
