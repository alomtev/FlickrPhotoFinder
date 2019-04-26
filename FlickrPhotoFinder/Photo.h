//
//  Photo.h
//  FlickrPhotoFinder
//
//  Created by Lomtev on 25.04.2019.
//  Copyright © 2019 Александр Ломтев. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Photo : NSObject

@property (nonatomic, strong) NSString *photoUrl;
@property (nonatomic, strong) NSData *photoData;

- (instancetype)initWithPhotoUrl:(NSString *)url andData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
