//
//  ImageEditView.m
//  FlickrPhotoFinder
//
//  Created by Lomtev on 23.04.2019.
//  Copyright © 2019 Александр Ломтев. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"
#import "ImageEditView.h"

@interface ImageEditView()

@property (nonatomic, strong) UIImageView *imageView;

@end


@implementation ImageEditView

+ (instancetype)createUIWithParentFrame:(CGRect)parentFrame andImageData:(Photo *)photo
{
    ImageEditView *imageEditView = [[ImageEditView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(parentFrame),CGRectGetHeight(parentFrame))];
    imageEditView.backgroundColor = UIColor.whiteColor;
    imageEditView.photo = photo;

    imageEditView.imageView = [UIImageView new];
    imageEditView.imageView.frame = CGRectMake(0, 0, CGRectGetWidth(imageEditView.frame), CGRectGetHeight(imageEditView.frame) - 200);
    [imageEditView.imageView setImage: [UIImage imageWithData: imageEditView.photo.photoData]];
    [imageEditView addSubview:imageEditView.imageView];
    
    imageEditView.button = [UIButton buttonWithType:UIButtonTypeCustom];
    imageEditView.button.frame = CGRectMake(CGRectGetMidX(parentFrame) - 60, CGRectGetMaxY(parentFrame) - 100, 120, 50);
    imageEditView.button.backgroundColor = [UIColor grayColor];
    [imageEditView.button setTitle:@"Закрыть" forState:UIControlStateNormal];
    [imageEditView addSubview: imageEditView.button];
    
    imageEditView.filterSlider = [[UISlider alloc] initWithFrame:CGRectMake(50, CGRectGetMinY(imageEditView.button.frame) - 100, CGRectGetWidth(imageEditView.frame) - 100, 50)];
    [imageEditView addSubview: imageEditView.filterSlider];
    
    return imageEditView;
}

- (void)updateImage:(UIImage *)newImage
{
    self.imageView.image = newImage;
}


@end
