//
//  PhotoTableViewCell.m
//  FlickrPhotoFinder
//
//  Created by Lomtev on 25.04.2019.
//  Copyright © 2019 Александр Ломтев. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@interface PhotoCollectionViewCell()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation PhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imageView = [UIImageView new];
        self.imageView.frame = self.contentView.frame;
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)setPhotoObject:(Photo *)photoObject
{
    _photoObject = photoObject;
    self.imageView.image = [UIImage imageWithData: _photoObject.photoData];
}

@end
