//
//  PhotoTableViewCell.h
//  FlickrPhotoFinder
//
//  Created by Lomtev on 25.04.2019.
//  Copyright © 2019 Александр Ломтев. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

NS_ASSUME_NONNULL_BEGIN

@interface PhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) Photo *photoObject;

@end

NS_ASSUME_NONNULL_END
