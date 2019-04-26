//
//  ImageEditView.h
//  FlickrPhotoFinder
//
//  Created by Lomtev on 23.04.2019.
//  Copyright © 2019 Александр Ломтев. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImageEditView : UIView

@property (nonatomic, strong) Photo *photo;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UISlider *filterSlider;

+ (instancetype)createUIWithParentFrame:(CGRect)parentFrame andImageData:(Photo *)imageData;

- (void)updateImage:(UIImage *)newImage;

@end

NS_ASSUME_NONNULL_END
